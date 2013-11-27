//
//  SIAFTPClient.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/04/30.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAFTPClient.h"

#import "NSStream+SIATools.h"
#import "NSArray+SIATools.h"
#import "SIALogger.h"
#import "SIAFTPOperation.h"
#import "SIAFTPCommand.h"
#import "SIAFTPReply.h"
#import "SIAFTPError.h"

NSString *const SIAFTPErrorDoman = @"SIAFTPErrorDoman";

@interface SIAFTPClient ()
@property (nonatomic, strong, readwrite) NSMutableData *inputBuffer;
@property (nonatomic, strong, readwrite) NSMutableData *outputBuffer;
@end

@implementation SIAFTPClient

+ (SIAFTPClient *)clientWithHostName:(NSString *)hostName port:(NSInteger)port
{
    return [[SIAFTPClient alloc] initWithHostName:hostName port:port];
}

- (id)initWithHostName:(NSString *)hostName port:(NSInteger)port
{
    self = [super init];
    if (self) {
        _hostName = hostName;
        _port     = port;
        NSInputStream  *is = nil;
        NSOutputStream *os = nil;
        [NSStream getStreamsToHostName:_hostName port:_port inputStream:&is outputStream:&os];
        _inputStream           = is;
        _outputStream          = os;
        _inputStream.delegate  = self;
        _outputStream.delegate = self;
        _operationQueue        = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)scheduleAndOpen
{
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
}

- (void)closeAndRemoveSchedule
{
    [self.inputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream close];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)sendCommand:(SIAFTPCommand *)command
{
    NSAssert(command != nil, @"commandの指定必須");
    if (self.outputBuffer == nil) {
        self.outputBuffer = [NSMutableData data];
    }
    [self.outputBuffer appendData:[command data]];
    [self sendBuffer];
}

- (void)sendBuffer
{
    if (self.outputBuffer.length == 0) {
        return;
    }
    
    if ([self.outputStream hasSpaceAvailable]) {
        NSInteger bytesWritten = 0;
        bytesWritten = [self.outputStream write:self.outputBuffer.bytes maxLength:self.outputBuffer.length];
        if (bytesWritten == -1) {
            if ([self.delegate respondsToSelector:@selector(ftpClient:didFailWithError:)]) {
                NSError *error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorStreamWrite userInfo:@{ @"stream": self.outputStream }];
                [self.delegate ftpClient:self didFailWithError:error];
            }
        }
        else if (bytesWritten == self.outputBuffer.length) {
            self.outputBuffer = nil;
        }
        else {
            [self.outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}

- (void)addOperation:(SIAFTPOperation *)operation
{
    operation.client = self;
    [self.operationQueue addOperation:operation];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if ([self.delegate respondsToSelector:@selector(ftpClient:stream:handleEvent:)]) {
        [self.delegate ftpClient:self stream:aStream handleEvent:eventCode];
    }
    
    if (aStream == self.inputStream) {
        switch (eventCode) {
            case NSStreamEventOpenCompleted: {
                DLog(@"SIAFTP", @"FTPのストリームを開けた");
            } break;
            case NSStreamEventHasBytesAvailable: {
                NSInteger bytesRead;
                uint8_t   buffer[32768];
                
                DLog(@"SIAFTP", @"FTPの受信中");
                
                // Pull some data off the network.
                
                bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    if ([self.delegate respondsToSelector:@selector(ftpClient:didFailWithError:)]) {
                        NSError *error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorStreamRead userInfo:@{ @"stream": aStream }];
                        [self.delegate ftpClient:self didFailWithError:error];
                    }
                } else if (bytesRead == 0) {
                    DLog(@"SIAFTP", @"ネットワークの読み込み終了");
                } else {
                    if (self.inputBuffer == nil) {
                        self.inputBuffer = [NSMutableData dataWithCapacity:bytesRead];
                    }
                    [self.inputBuffer appendBytes:buffer length:bytesRead];
                    
                    NSString *command = [[NSString alloc] initWithData:self.inputBuffer encoding:NSASCIIStringEncoding];
                    NSRange  range    = [command rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
                                                                 options:NSBackwardsSearch];
                    if (NSMaxRange(range) == command.length) {
                        _reply = [SIAFTPReply replyWithString:command];
                        if (self.recivingReply) {
                            self.recivingReply(self.reply);
                        }
                        for (SIAFTPOperation *command in self.operationQueue.operations) {
                            [command reciveReply:self.reply];
                        }
                        self.inputBuffer = nil;
                    }
                }
            } break;
            case NSStreamEventHasSpaceAvailable: {
                NSAssert(NO, @"input streamでは発生しない");
            } break;
            case NSStreamEventErrorOccurred: {
                if ([self.delegate respondsToSelector:@selector(ftpClient:didFailWithError:)]) {
                    NSError *error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorStreamEvent userInfo:@{ @"stream": aStream }];
                    [self.delegate ftpClient:self didFailWithError:error];
                }
            } break;
            case NSStreamEventEndEncountered: {
                // ignore
            } break;
            default: {
                assert(NO);
            } break;
        }
    }
    else if (aStream == self.outputStream) {
        switch (eventCode) {
            case NSStreamEventOpenCompleted: {
                DLog(@"SIAFTP", @"FTPのストリームを開けた");
            } break;
            case NSStreamEventHasBytesAvailable: {
                NSAssert(NO, @"output streamでは発生しない");
            } break;
            case NSStreamEventHasSpaceAvailable: {
                DLog(@"SIAFTP", @"FTPの送信中");
                [self sendBuffer];
            } break;
            case NSStreamEventErrorOccurred: {
                if ([self.delegate respondsToSelector:@selector(ftpClient:didFailWithError:)]) {
                    NSError *error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorStreamEvent userInfo:@{ @"stream": aStream }];
                    [self.delegate ftpClient:self didFailWithError:error];
                }
            } break;
            case NSStreamEventEndEncountered: {
                // ignore
            } break;
            default: {
                assert(NO);
            } break;
        }
    }
}

@end
