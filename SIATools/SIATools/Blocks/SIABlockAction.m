//
//  SIABlockAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/08.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIABlockAction.h"

#import "NSObject+SIATools.h"

@implementation SIABlockAction

+ (SIABlockAction *)createSubclassInstanceForSelector:(SEL)selector
{
    SIABlockAction *action = [SIABlockAction createSubclassInstance];
    action.selector = selector;
    return action;
}

- (void)addMethodWithTypes:(const char *)types block:(id)block
{
    [self addMethodWithSelector:self.selector types:types block:block];
}

@end

@implementation NSObject (NSObjectSIABlockActionExtensions)

- (NSMutableArray *)blockActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self associatedObjectForKey:@"SIABlockActionList"];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self setAssociatedObject:actions forKey:@"SIABlockActionList"];
        }
    }
    return actions;
}

- (SIABlockAction *)actionForSelector:(SEL)selector types:(const char *)types usingBlock:(id)block
{
    SIABlockAction *action = [SIABlockAction createSubclassInstanceForSelector:selector];
    [action addMethodWithTypes:types block:block];
    [self.blockActions addObject:action];
    return action;
}

- (void)disposeAction:(SIABlockAction *)action
{
    [self.blockActions removeObject:action];
}

@end

@implementation NSTimer (NSTimerSIABlockActionExtensions)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
                          userInfo:(id)userInfo
                           repeats:(BOOL)yesOrNo
                             block:(void (^)(id blockAction, NSTimer *timer))block
{
    SIABlockAction *blockAction = [SIABlockAction createSubclassInstanceForSelector:@selector(fire:)];
    [blockAction addMethodWithTypes:"v0@0@0" block:block];
    return [NSTimer timerWithTimeInterval:ti target:blockAction selector:blockAction.selector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
                                      block:(void (^)(id blockAction, NSTimer *timer))block
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti userInfo:userInfo repeats:yesOrNo block:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

@end