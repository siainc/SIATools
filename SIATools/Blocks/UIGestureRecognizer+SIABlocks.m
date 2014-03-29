//
//  UIGestureRecognizer+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/06/19.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UIGestureRecognizer+SIABlocks.h"

#import "NSObject+SIATools.h"
#import "SIABlockProtocol.h"

#define SIA_GESTURE_ACTION_SEL @selector(action:)
#define SIAGestureActionListKey "SIAGestureActionListKey"

@interface SIAGestureAction : NSObject

@property (nonatomic, copy, readonly) void (^block)();

@end

@implementation SIAGestureAction

- (id)initWithBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)action:(UIGestureRecognizer *)sender
{
    _block();
}

@end

@implementation UIGestureRecognizer (SIABlocks)

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

- (SIAGestureAction *)sia_addActionWithUsingBlock:(void (^)())block;
{
    SIAGestureAction *action = [[SIAGestureAction alloc] initWithBlock:block];
    [self addTarget:action action:SIA_GESTURE_ACTION_SEL];
    [[self sia_gestureActions] addObject:action];
    return action;
}

- (void)sia_removeAction:(SIAGestureAction *)action
{
    [self removeTarget:action action:SIA_GESTURE_ACTION_SEL];
    [[self sia_gestureActions] removeObject:action];
}

- (void)sia_shouldBeginUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UIGestureRecognizerDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(gestureRecognizerShouldBegin:)
                                   block:^BOOL (SIABlockProtocol *protocol, UIGestureRecognizer *gestureRecognizer)
          {
              return block();
          }];
     }];
}

- (void)sia_shouldRecognizeSimultaneouslyUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block
{
    [self sia_implementProtocol:@protocol(UIGestureRecognizerDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)
                                   block:^BOOL (SIABlockProtocol *protocol, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer)
          {
              return block(otherGestureRecognizer);
          }];
     }];
}

- (void)sia_shouldRequireFailureUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block
{
    [self sia_implementProtocol:@protocol(UIGestureRecognizerDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)
                                   block:^BOOL (SIABlockProtocol *protocol, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer)
          {
              return block(otherGestureRecognizer);
          }];
     }];
}

- (void)sia_shouldBeRequiredToFailUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block
{
    [self sia_implementProtocol:@protocol(UIGestureRecognizerDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:)
                                   block:^BOOL (SIABlockProtocol *protocol, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer)
          {
              return block(otherGestureRecognizer);
          }];
     }];
}

- (void)sia_shouldReceiveTouchUsingBlock:(BOOL (^)(UITouch *touch))block
{
    [self sia_implementProtocol:@protocol(UIGestureRecognizerDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(gestureRecognizer:shouldReceiveTouch:)
                                   block:^BOOL (SIABlockProtocol *protocol, UIGestureRecognizer *gestureRecognizer, UITouch *touch)
          {
              return block(touch);
          }];
     }];
}

@end
