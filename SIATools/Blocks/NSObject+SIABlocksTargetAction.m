//
//  NSObject+SIABlocksTargetAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/08.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "NSObject+SIABlocksTargetAction.h"

#import "NSObject+SIATools.h"

#define SIABlockActionListKey "SIABlockActionListKey"

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

@implementation NSObject (SIABlocksTargetAction)

- (NSMutableArray *)sia_blockActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self sia_associatedObjectForKey:SIABlockActionListKey];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self sia_setAssociatedObject:actions forKey:SIABlockActionListKey];
        }
    }
    return actions;
}

- (SIABlockAction *)sia_actionForSelector:(SEL)selector types:(const char *)types usingBlock:(id)block
{
    SIABlockAction *action = [SIABlockAction createSubclassInstanceForSelector:selector];
    [action addMethodWithTypes:types block:block];
    [[self sia_blockActions] addObject:action];
    return action;
}

- (void)sia_disposeAction:(SIABlockAction *)action
{
    [[self sia_blockActions] removeObject:action];
}

@end
