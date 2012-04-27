//
//  SIAControlAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/12.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAControlAction.h"

#import "NSObject+SIATools.h"

#define SIA_CONTROL_ACTION_SEL @selector(action:forEvent:)
#define SIAControlActionListKey "SIAControlActionListKey"

@implementation SIAControlAction

- (id)initWithControlEvents:(UIControlEvents)controlEvents
                      queue:(NSOperationQueue *)queue
                 usingBlock:(void (^)(UIEvent *event))block
{
    self = [super init];
    if (self) {
        _controlEvents = controlEvents;
        _queue = queue;
        _block = block;
    }
    return self;
}

- (void)action:(UIControl *)sender forEvent:(UIEvent *)event
{
    if (self.queue && self.queue != [NSOperationQueue currentQueue]) {
        [self.queue addOperationWithBlock:^{
            _block(event);
        }];
    }
    else {
        _block(event);
    }
}

@end

@implementation UIControl (UIControlSIAControlActionExtensions)

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
                                              queue:(NSOperationQueue *)queue
                                         usingBlock:(void (^)(UIEvent *event))block
{
    SIAControlAction *action = [[SIAControlAction alloc] initWithControlEvents:controlEvents queue:queue usingBlock:block];
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