//
//  SIABaseOperation.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIABaseOperation : NSOperation

@property (assign, readwrite, getter = isConcurrent) BOOL concurrent;
@property (assign, readwrite, getter = isReady) BOOL ready;
@property (assign, readwrite, getter = isExecuting) BOOL executing;
@property (assign, readwrite, getter = isFinished) BOOL finished;
@property (assign, readwrite, getter = isCancelled) BOOL cancelled;

@property (nonatomic, copy, readwrite) void (^execution)();
@property (nonatomic, copy, readwrite) void (^cancellation)();

- (void)setupExecuting;
- (void)setupFinished;
- (void)setupCancelled;

@end
