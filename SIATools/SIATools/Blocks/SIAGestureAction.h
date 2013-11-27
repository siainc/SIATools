//
//  SIAGestureAction.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/06/19.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIAGestureAction : NSObject

@property (nonatomic, weak, readonly) NSOperationQueue  *queue;
@property (nonatomic, copy, readonly) void              (^block)();

@end

@interface UIGestureRecognizer (UIGestureRecognizerSIAGestureActionExtensions)

- (SIAGestureAction *)addActionWithQueue:(NSOperationQueue *)queue
                              usingBlock:(void (^)())block;
- (void)removeAction:(SIAGestureAction *)action;

@end