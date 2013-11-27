//
//  SIAControlAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/12.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAControlAction.h"

#import "NSObject+SIATools.h"
#import "NSArray+SIATools.h"

#define SIA_CONTROL_ACTION_SEL @selector(action:forEvent:)

@implementation SIAControlAction

- (id)initWithControlEvents:(UIControlEvents)controlEvents
                      queue:(NSOperationQueue *)queue
                 usingBlock:(void (^)(UIEvent *event))block
{
    self = [super init];
    if (self) {
        _controlEvents = controlEvents;
        _queue         = queue;
        _block         = block;
    }
    return self;
}

- (void)action:(UIControl *)sender forEvent:(UIEvent *)event
{
    NSOperationQueue *queue = self.queue;
    if (queue == nil) {
        queue = [NSOperationQueue currentQueue];
    }
    
    [queue addOperationWithBlock:^{
        _block(event);
    }];
}

@end

@implementation UIControl (UIControlSIAControlActionExtensions)

- (NSMutableArray *)controlActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self associatedObjectForKey:@"SIAControlActionList"];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self setAssociatedObject:actions forKey:@"SIAControlActionList"];
        }
    }
    return actions;
}

- (SIAControlAction *)addActionForControlEvents:(UIControlEvents)controlEvents
                                          queue:(NSOperationQueue *)queue
                                     usingBlock:(void (^)(UIEvent *event))block
{
    SIAControlAction *action = [[SIAControlAction alloc] initWithControlEvents:controlEvents queue:queue usingBlock:block];
    [self addTarget:action action:SIA_CONTROL_ACTION_SEL forControlEvents:controlEvents];
    [self.controlActions addObject:action];
    return action;
}

- (void)removeAction:(SIAControlAction *)action forControlEvents:(UIControlEvents)controlEvents
{
    [self removeTarget:action action:SIA_CONTROL_ACTION_SEL forControlEvents:controlEvents];
    [self.controlActions removeObject:action];
}

@end