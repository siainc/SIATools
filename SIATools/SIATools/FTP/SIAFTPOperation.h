//
//  SIAFTPOperation.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/01.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIABaseOperation.h"

@class SIAFTPClient, SIAFTPReply, SIAFTPCommand;

@interface SIAFTPOperation :   SIABaseOperation

@property (nonatomic, weak, readwrite) SIAFTPClient    *client;
@property (nonatomic, strong, readwrite) SIAFTPCommand *command;
@property (nonatomic, strong, readwrite) SIAFTPReply   *reply;
@property (nonatomic, strong, readwrite) NSError       *error;

- (void)reciveReply:(SIAFTPReply *)reply;

@end

@interface SIAFTPLoginOperation :   SIAFTPOperation

@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *password;

+ (SIAFTPLoginOperation *)operationWithUserName:(NSString *)userName password:(NSString *)password;
- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password;

@end

@interface SIAFTPRenameOperation :   SIAFTPOperation

@property (nonatomic, copy, readwrite) NSString *fromPath;
@property (nonatomic, copy, readwrite) NSString *toPath;

+ (SIAFTPRenameOperation *)operationWithFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
- (instancetype)initWithFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

@end

