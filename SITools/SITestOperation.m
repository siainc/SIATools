//
//  SITestOperation.m
//  SIQueue
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "SITestOperation.h"

@implementation SITestOperation

- (id)initWithMessage:(NSString *)message;
{
    self = [super init];
    if (self) {
        _message = message;
    }
    return self;
}

- (void)start
{
    [self setReady:NO];
    [self setExecuting:YES];
    NSLog(@"S:%@", self.message);

    [NSThread sleepForTimeInterval:0.5];

    if (self.isCancelled) {
        [self setExecuting:NO];
        [self setCancelled:YES];
        [self setFinished:YES];
    }
    else {
        NSLog(@"E:%@", self.message);
        [self setExecuting:NO];
        [self setFinished:YES];
    }
}

- (NSOperation*)retryOperation
{
    SITestOperation *operation = [[SITestOperation alloc] initWithMessage:self.message];
    return operation;
}

@end
