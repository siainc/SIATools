//
//  SIATimerAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/07/16.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "SIATimerAction.h"

#import "NSObject+SIATools.h"

#define SIA_TIMER_ACTION_SEL @selector(fire:)
#define SIATimerActionsListKey "SIATimerActionsListKey"

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
    if (self.queue && self.queue != [NSOperationQueue currentQueue]) {
        [self.queue addOperationWithBlock:^{
            _block(timer);
        }];
    }
    else {
        _block(timer);
    }
}

@end

@implementation NSTimer (NSTimerSIATimerActionExtensions)

- (NSMutableArray *)sia_timerActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self sia_associatedObjectForKey:SIATimerActionsListKey];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self sia_setAssociatedObject:actions forKey:SIATimerActionsListKey];
        }
    }
    return actions;
}

+ (NSTimer *)sia_timerWithTimeInterval:(NSTimeInterval)ti
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
    [[timer sia_timerActions] addObject:action];
    return timer;
}

+ (NSTimer *)sia_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       userInfo:(id)userInfo
                                        repeats:(BOOL)yesOrNo
                                          queue:(NSOperationQueue *)queue
                                     usingBlock:(void (^)(NSTimer *timer))block
{
    NSTimer *timer = [NSTimer sia_timerWithTimeInterval:ti userInfo:userInfo repeats:yesOrNo queue:queue usingBlock:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

@end