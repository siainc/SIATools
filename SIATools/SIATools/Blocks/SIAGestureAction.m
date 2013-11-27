//
//  SIAGestureAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/06/19.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIAGestureAction.h"

#import "NSObject+SIATools.h"

#define SIA_GESTURE_ACTION_SEL @selector(action:)

@implementation SIAGestureAction

- (id)initWithQueue:(NSOperationQueue *)queue
         usingBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        _queue         = queue;
        _block         = block;
    }
    return self;
}

- (void)action:(UIGestureRecognizer *)sender
{
    NSOperationQueue *queue = self.queue;
    if (queue == nil) {
        queue = [NSOperationQueue currentQueue];
    }
    
    [queue addOperationWithBlock:^{
        _block(sender);
    }];
}

@end

@implementation UIGestureRecognizer (SIATools)

- (NSMutableArray *)gestureActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self associatedObjectForKey:@"SIAGestureActionList"];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self setAssociatedObject:actions forKey:@"SIAGestureActionList"];
        }
    }
    return actions;
}

- (SIAGestureAction *)addActionWithQueue:(NSOperationQueue *)queue
                              usingBlock:(void (^)())block;
{
    SIAGestureAction *action = [[SIAGestureAction alloc] initWithQueue:queue usingBlock:block];
    [self addTarget:action action:SIA_GESTURE_ACTION_SEL];
    [self.gestureActions addObject:action];
    return action;

}

- (void)removeAction:(SIAGestureAction *)action
{
    [self removeTarget:action action:SIA_GESTURE_ACTION_SEL];
    [self.gestureActions removeObject:action];
}

@end
