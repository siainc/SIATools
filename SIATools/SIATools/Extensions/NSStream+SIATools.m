//
//  NSStream+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/04/30.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "NSStream+SIATools.h"

@implementation NSStream (SIATools)

+ (void)getStreamsToHostName:(NSString *)hostName
                        port:(NSInteger)port
                 inputStream:(NSInputStream **)inputStream
                outputStream:(NSOutputStream **)outputStream
{
    NSAssert(hostName.length > 0, @"ホスト名を指定する必要がある", hostName);
    NSAssert(0 < port && port < 65536, @"ポートは1-65535の範囲内でなければいけない port:%d", port);
    NSAssert(inputStream != NULL || outputStream != NULL, @"input/outputのいずれかの指定必須");
    
    CFReadStreamRef  readStream  = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(
                                       kCFAllocatorDefault,
                                       (__bridge CFStringRef)hostName,
                                       port,
                                       (inputStream != NULL) ? &readStream : NULL,
                                       (outputStream != NULL) ? &writeStream : NULL
                                       );
    
    if (inputStream != NULL) {
        *inputStream = CFBridgingRelease(readStream);
    }
    if (outputStream != NULL) {
        *outputStream = CFBridgingRelease(writeStream);
    }
}

@end
