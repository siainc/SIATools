//
//  UIGestureRecognizer+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/06/19.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SIAGestureAction;

@interface UIGestureRecognizer (SIABlocks)

- (SIAGestureAction *)sia_addActionWithUsingBlock:(void (^)())block;
- (void)sia_removeAction:(SIAGestureAction *)action;

- (void)sia_shouldBeginUsingBlock:(BOOL (^)())block;
- (void)sia_shouldRecognizeSimultaneouslyUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block;
- (void)sia_shouldRequireFailureUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block;
- (void)sia_shouldBeRequiredToFailUsingBlock:(BOOL (^)(UIGestureRecognizer *otherGestureRecognizer))block;
- (void)sia_shouldReceiveTouchUsingBlock:(BOOL (^)(UITouch *touch))block;

@end