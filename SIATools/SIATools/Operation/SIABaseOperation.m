//
//  SIABaseOperation.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIABaseOperation.h"

#import "SIAToolsLogger.h"

/**
 * NSOperationを継承し、cancalled, finished, executing, ready, concurrentのgetter/setterを管理する.
 */
@implementation SIABaseOperation
@synthesize concurrent = _concurrent;
@synthesize ready      = _ready;
@synthesize executing  = _executing;
@synthesize finished   = _finished;
@synthesize cancelled  = _cancelled;

- (id)init
{
    SIAToolsDLog(@">>");
    self = [super init];
    if (self != nil) {
        _concurrent = NO;
        _ready      = YES;
        _executing  = NO;
        _finished   = NO;
        _cancelled  = NO;
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

#pragma mark - Property

- (BOOL)isConcurrent
{
    return _concurrent;
}

- (void)setConcurrent:(BOOL)concurrent
{
    if (_concurrent != concurrent) {
        [self willChangeValueForKey:@"isConcurrent"];
        _concurrent = concurrent;
        [self didChangeValueForKey:@"isConcurrent"];
    }
}

- (BOOL)isReady
{
    return _ready;
}

- (void)setReady:(BOOL)ready
{
    if (_ready != ready) {
        [self willChangeValueForKey:@"isReady"];
        _ready = ready;
        [self didChangeValueForKey:@"isReady"];
    }
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setExecuting:(BOOL)executing
{
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
        if (_executing && self.execution) {
            self.execution();
        }
    }
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)setFinished:(BOOL)finished
{
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isCancelled
{
    return _cancelled;
}

- (void)setCancelled:(BOOL)cancelled
{
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
        if (_cancelled && self.cancellation) {
            self.cancellation();
        }
    }
}

- (void)setupExecuting
{
    self.ready     = NO;
    self.executing = YES;
}

- (void)setupFinished
{
    self.executing = NO;
    self.finished  = YES;
}

- (void)setupCancelled
{
    self.ready     = NO;
    self.cancelled = YES;
    self.executing = NO;
    self.finished  = YES;
}

@end
