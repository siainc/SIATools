//
//  NSTimer+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/07/16.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "NSTimer+SIABlocks.h"

#import "NSObject+SIATools.h"

#define SIA_TIMER_ACTION_SEL @selector(fire:)
#define SIATimerActionKey "SIATimerActionKey"

@interface SIATimerAction : NSObject

@property (nonatomic, copy, readonly) void (^block)();

@end

@implementation SIATimerAction

- (id)initWithBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)fire:(NSTimer *)timer
{
    _block();
}

@end

@implementation NSTimer (SIABlocks)

+ (NSTimer *)sia_timerWithTimeInterval:(NSTimeInterval)ti
                               repeats:(BOOL)yesOrNo
                            usingBlock:(void (^)())block
{
    SIATimerAction *action = [[SIATimerAction alloc] initWithBlock:block];
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti
                                             target:action
                                           selector:SIA_TIMER_ACTION_SEL
                                           userInfo:nil
                                            repeats:yesOrNo];
    [timer sia_setAssociatedObject:action forKey:SIATimerActionKey];
    return timer;
}

+ (NSTimer *)sia_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                        repeats:(BOOL)yesOrNo
                                     usingBlock:(void (^)())block
{
    NSTimer *timer = [NSTimer sia_timerWithTimeInterval:ti repeats:yesOrNo usingBlock:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

@end