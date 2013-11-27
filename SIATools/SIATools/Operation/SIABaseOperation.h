//
//  SIABaseOperation.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIABaseOperation :   NSOperation

@property (nonatomic, assign, readwrite, getter = isConcurrent)   BOOL concurrent;
@property (nonatomic, assign, readwrite, getter = isReady)        BOOL ready;
@property (nonatomic, assign, readwrite, getter = isExecuting)    BOOL executing;
@property (nonatomic, assign, readwrite, getter = isFinished)     BOOL finished;
@property (nonatomic, assign, readwrite, getter = isCancelled)    BOOL cancelled;

@property (nonatomic, copy, readwrite) void (^execution)();
@property (nonatomic, copy, readwrite) void (^cancellation)();

- (void)setupExecuting;
- (void)setupFinished;
- (void)setupCancelled;

@end
