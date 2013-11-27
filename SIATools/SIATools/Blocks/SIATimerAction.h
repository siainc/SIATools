//
//  SIATimerAction.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/07/16.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIATimerAction : NSObject

@property (nonatomic, weak, readonly) NSOperationQueue *queue;
@property (nonatomic, copy, readonly) void (^block)(NSTimer *timer);

@end

@interface NSTimer (NSTimerSIATimerActionExtensions)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
                          userInfo:(id)userInfo
                           repeats:(BOOL)yesOrNo
                             queue:(NSOperationQueue *)queue
                        usingBlock:(void (^)(NSTimer *timer))block;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
                                      queue:(NSOperationQueue *)queue
                                 usingBlock:(void (^)(NSTimer *timer))block;

@end