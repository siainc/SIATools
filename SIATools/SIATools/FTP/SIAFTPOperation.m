//
//  SIAFTPOperation.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/01.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAFTPOperation.h"

#import "SIAFTPClient.h"
#import "SIAFTPCommand.h"
#import "SIAFTPReply.h"
#import "SIAFTPError.h"

@implementation SIAFTPOperation

- (void)start
{
    if (self.isFinished || self.isCancelled) {
        return;
    }
    if (!self.isReady || self.isExecuting) {
        @throw NSGenericException;
    }
    
    NSAssert(self.client != nil, @"ftp clientの指定必須");
    [self.client sendCommand:self.command];
    
    [self setupExecuting];
}

- (void)reciveReply:(SIAFTPReply *)reply
{
    _reply = reply;
    [self setupFinished];
}

@end

@implementation SIAFTPLoginOperation

+ (SIAFTPLoginOperation *)operationWithUserName:(NSString *)userName password:(NSString *)password
{
    return [[SIAFTPLoginOperation alloc] initWithUserName:userName password:password];
}

- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password
{
    NSAssert(userName != nil, @"userNameを指定する必要がある");
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
    }
    return self;
}

- (void)start
{
    if (self.isFinished || self.isCancelled) {
        return;
    }
    if (!self.isReady || self.isExecuting) {
        @throw NSGenericException;
    }
    
    NSAssert(self.client != nil, @"ftp clientの指定必須");
    if (self.client.reply.code == 220) {
        [self sendUserName];
    }
    
    [self setupExecuting];
}

- (void)sendUserName
{
    SIAFTPCommand *command = [SIAFTPCommand commandWithString:[NSString stringWithFormat:@"USER %@", self.userName]];
    [self.client sendCommand:command];
}

- (void)sendPassword
{
    if (self.password.length == 0) {
        self.error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorCommandReply userInfo:@{ @"reply": self.reply }];
        [self setupFinished];
        return;
    }
    SIAFTPCommand *command = [SIAFTPCommand commandWithString:[NSString stringWithFormat:@"PASS %@", self.password]];
    [self.client sendCommand:command];
}

- (void)reciveReply:(SIAFTPReply *)reply;
{
    if (!self.executing) {
        return;
    }
    self.reply = reply;
    switch (self.reply.code) {
        case 220: {
            [self sendUserName];
        } break;
        case 331: {
            [self sendPassword];
        } break;
        case 230: {
            [self setupFinished];
        } break;
        default: {
            self.error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorCommandReply userInfo:@{ @"reply": self.reply }];
            [self setupFinished];
        } break;
    }
}

@end

@implementation SIAFTPRenameOperation

+ (SIAFTPRenameOperation *)operationWithFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    return [[SIAFTPRenameOperation alloc] initWithFromPath:fromPath toPath:toPath];
}

- (instancetype)initWithFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSAssert(fromPath != nil, @"fromPathの指定必須");
    NSAssert(toPath != nil, @"toPathの指定必須");
    self = [super init];
    if (self) {
        _fromPath = fromPath;
        _toPath   = toPath;
    }
    return self;
}

- (void)start
{
    if (self.isFinished || self.isCancelled) {
        return;
    }
    if (!self.isReady || self.isExecuting) {
        @throw NSGenericException;
    }
    
    NSAssert(self.client != nil, @"ftp clientの指定必須");
    [self sendRenameFrom];
    
    [self setupExecuting];
}

- (void)sendRenameFrom
{
    SIAFTPCommand *command = [SIAFTPCommand commandWithString:[NSString stringWithFormat:@"RNFR %@", self.fromPath]];
    [self.client sendCommand:command];
}

- (void)sendRenameTo
{
    SIAFTPCommand *command = [SIAFTPCommand commandWithString:[NSString stringWithFormat:@"RNTO %@", self.toPath]];
    [self.client sendCommand:command];
}

- (void)reciveReply:(SIAFTPReply *)reply
{
    if (!self.executing) {
        return;
    }
    self.reply = reply;
    switch (self.reply.code) {
        case 350: {
            [self sendRenameTo];
        } break;
        case 250: {
            [self setupFinished];
        } break;
        default: {
            self.error = [NSError errorWithDomain:SIAFTPErrorDoman code:SIAFTPErrorCommandReply userInfo:@{ @"reply": self.reply }];
            [self setupFinished];
        } break;
    }
}

@end
