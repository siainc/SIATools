//
//  UIControl+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/12.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "UIControl+SIABlocks.h"

#import "NSObject+SIATools.h"

#define SIA_CONTROL_ACTION_SEL @selector(action:forEvent:)
#define SIAControlActionListKey "SIAControlActionListKey"

@interface SIAControlAction : NSObject

@property (nonatomic, assign, readonly) UIControlEvents controlEvents;
@property (nonatomic, copy, readonly) void (^block)(UIEvent *event);

@end

@implementation SIAControlAction

- (id)initWithControlEvents:(UIControlEvents)controlEvents
                 usingBlock:(void (^)(UIEvent *event))block
{
    self = [super init];
    if (self) {
        _controlEvents = controlEvents;
        _block = block;
    }
    return self;
}

- (void)action:(UIControl *)sender forEvent:(UIEvent *)event
{
    _block(event);
}

@end

@implementation UIControl (SIABlocks)

- (NSMutableArray *)sia_controlActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self sia_associatedObjectForKey:SIAControlActionListKey];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self sia_setAssociatedObject:actions forKey:SIAControlActionListKey];
        }
    }
    return actions;
}

- (SIAControlAction *)sia_addActionForControlEvents:(UIControlEvents)controlEvents
                                         usingBlock:(void (^)(UIEvent *event))block
{
    SIAControlAction *action = [[SIAControlAction alloc] initWithControlEvents:controlEvents usingBlock:block];
    [self addTarget:action action:SIA_CONTROL_ACTION_SEL forControlEvents:controlEvents];
    [[self sia_controlActions] addObject:action];
    return action;
}

- (void)sia_removeAction:(SIAControlAction *)action forControlEvents:(UIControlEvents)controlEvents
{
    [self removeTarget:action action:SIA_CONTROL_ACTION_SEL forControlEvents:controlEvents];
    [[self sia_controlActions] removeObject:action];
}

@end