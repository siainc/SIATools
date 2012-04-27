//
//  UIView+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/12/20.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SIATools)

- (NSEnumerator *)sia_superviewEnumerator;
- (NSEnumerator *)sia_recursiveSubviewsEnumerator;
- (NSEnumerator *)sia_recursiveSubviewsEnumeratorWithMaxDepth:(NSInteger)maxDepth;

- (UIView *)sia_recursiveSubviewAtIndex:(NSInteger)index maxDepth:(NSInteger)maxDepth;
- (UIView *)sia_nextRecursiveSubviewWithPreviousView:(UIView *)currentView maxDepth:(NSInteger)maxDepth;
- (UIView *)sia_nextSiblingSubviewWithPreviousView:(UIView *)currentView;
- (NSInteger)sia_depthToView:(UIView *)view;

@end

@interface SIASubviewsEnumerator : NSEnumerator

- (instancetype)initWithView:(UIView *)rootView maxDepth:(NSInteger)maxDepth;

@property (nonatomic, strong, readonly) UIView *rootView;
@property (nonatomic, assign, readonly) NSInteger maxDepth;

@end