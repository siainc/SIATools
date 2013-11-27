//
//  SIATimerAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/07/16.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIATimerAction.h"

#import "NSObject+SIATools.h"

#define SIA_TIMER_ACTION_SEL @selector(fire:)

@implementation SIATimerAction

- (id)initWithQueue:(NSOperationQueue *)queue
              block:(void (^)())block
{
    self = [super init];
    if (self) {
        _queue = queue;
        _block = block;
    }
    return self;
}

- (void)fire:(NSTimer *)timer
{
    NSOperationQueue *queue = self.queue;
    if (queue == nil) {
        queue = [NSOperationQueue currentQueue];
    }
    
    [queue addOperationWithBlock:^{
        _block(timer);
    }];
}

@end

@implementation NSTimer (NSTimerSIATimerActionExtensions)

- (NSMutableArray *)timerActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self associatedObjectForKey:@"SIATimerActionsList"];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self setAssociatedObject:actions forKey:@"SIATimerActionsList"];
        }
    }
    return actions;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
                          userInfo:(id)userInfo
                           repeats:(BOOL)yesOrNo
                             queue:(NSOperationQueue *)queue
                        usingBlock:(void (^)(NSTimer *timer))block
{
    SIATimerAction *action = [[SIATimerAction alloc] initWithQueue:queue block:block];
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti
                                             target:action
                                           selector:SIA_TIMER_ACTION_SEL
                                           userInfo:userInfo
                                            repeats:yesOrNo];
    [timer.timerActions addObject:action];
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
                                      queue:(NSOperationQueue *)queue
                                 usingBlock:(void (^)(NSTimer *timer))block
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti userInfo:userInfo repeats:yesOrNo queue:queue usingBlock:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

@end