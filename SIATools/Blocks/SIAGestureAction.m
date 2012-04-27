//
//  SIAGestureAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/06/19.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "SIAGestureAction.h"

#import "NSObject+SIATools.h"

#define SIA_GESTURE_ACTION_SEL @selector(action:)
#define SIAGestureActionListKey "SIAGestureActionListKey"

@implementation SIAGestureAction

- (id)initWithQueue:(NSOperationQueue *)queue
         usingBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        _queue = queue;
        _block = block;
    }
    return self;
}

- (void)action:(UIGestureRecognizer *)sender
{
    if (self.queue && self.queue != [NSOperationQueue currentQueue]) {
        [self.queue addOperationWithBlock:^{
            _block(sender);
        }];
    }
    else {
        _block(sender);
    }
}

@end

@implementation UIGestureRecognizer (UIGestureRecognizerSIAGestureActionExtensions)

- (NSMutableArray *)sia_gestureActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self sia_associatedObjectForKey:SIAGestureActionListKey];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self sia_setAssociatedObject:actions forKey:SIAGestureActionListKey];
        }
    }
    return actions;
}

- (SIAGestureAction *)sia_addActionWithQueue:(NSOperationQueue *)queue
                                  usingBlock:(void (^)())block;
{
    SIAGestureAction *action = [[SIAGestureAction alloc] initWithQueue:queue usingBlock:block];
    [self addTarget:action action:SIA_GESTURE_ACTION_SEL];
    [[self sia_gestureActions] addObject:action];
    return action;
}

- (void)sia_removeAction:(SIAGestureAction *)action
{
    [self removeTarget:action action:SIA_GESTURE_ACTION_SEL];
    [[self sia_gestureActions] removeObject:action];
}

@end
