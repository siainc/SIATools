//
//  SIAFTPClient.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/04/30.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SIAFTPClientDelegate;
@class SIAFTPOperation, SIAFTPCommand, SIAFTPReply;

@interface SIAFTPClient :   NSObject <NSStreamDelegate>

+ (SIAFTPClient *)clientWithHostName:(NSString *)hostName port:(NSInteger)port;
- (id)initWithHostName:(NSString *)hostName port:(NSInteger)port;

@property (nonatomic, copy, readonly) NSString                   *hostName;
@property (nonatomic, assign, readonly) NSInteger                port;
@property (nonatomic, strong, readonly) NSInputStream            *inputStream;
@property (nonatomic, strong, readonly) NSOutputStream           *outputStream;
@property (nonatomic, strong, readonly) NSOperationQueue         *operationQueue;
@property (nonatomic, weak, readwrite) id <SIAFTPClientDelegate> delegate;
@property (nonatomic, strong, readonly) SIAFTPReply              *reply;

- (void)scheduleAndOpen;
- (void)closeAndRemoveSchedule;

- (void)addOperation:(SIAFTPOperation *)operation;

- (void)sendCommand:(SIAFTPCommand *)command;
@property (nonatomic, copy, readwrite) void (^recivingReply)(SIAFTPReply *reply);

@end

@protocol SIAFTPClientDelegate <NSObject>

@optional
- (void)ftpClient:(SIAFTPClient *)client stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
- (void)ftpClient:(SIAFTPClient *)client didFailWithError:(NSError *)error;

@end