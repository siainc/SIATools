//
//  UIView+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/12/20.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UIView+SIATools.h"

#import "NSArray+SIATools.h"
#import "NSEnumerator+SIATools.h"

@implementation UIView (SIATools)

- (NSEnumerator *)sia_superviewEnumerator
{
    SIAEnumerator *enumerator = [SIAEnumerator enumeratorWithTraceBlock:^id(NSInteger index, UIView *previousObject) {
        return previousObject ? previousObject.superview : self.superview;
    }];
    return enumerator;
}

- (NSEnumerator *)sia_recursiveSubviewsEnumerator
{
    return [self sia_recursiveSubviewsEnumeratorWithMaxDepth:NSIntegerMax];
}

- (NSEnumerator *)sia_recursiveSubviewsEnumeratorWithMaxDepth:(NSInteger)maxDepth
{
    SIASubviewsEnumerator *enumerator = [[SIASubviewsEnumerator alloc] initWithView:self maxDepth:maxDepth];
    return enumerator;
}

- (UIView *)sia_recursiveSubviewAtIndex:(NSInteger)index maxDepth:(NSInteger)maxDepth
{
    UIView *view = nil;
    for (int i = 0; i < index + 1; i++) {
        view = [self sia_nextRecursiveSubviewWithPreviousView:view maxDepth:maxDepth];
    }
    return view;
}

- (UIView *)sia_nextRecursiveSubviewWithPreviousView:(UIView *)currentView maxDepth:(NSInteger)maxDepth
{
    if (maxDepth == 0) {
        return nil;
    }
    if (currentView == self) {
        return nil;
    }
    if (currentView == nil) {
        return self.subviews.sia_firstObject;
    }
    
    if (currentView.subviews.sia_firstObject) {
        NSInteger currentViewDepth = [self sia_depthToView:currentView];
        if (currentViewDepth < 0) {
            return nil;
        }
        
        if (maxDepth < 0 || currentViewDepth < maxDepth) {
            return currentView.subviews.sia_firstObject;
        }
        else {
            [self sia_nextSiblingSubviewWithPreviousView:currentView];
        }
    }
    
    return [self sia_nextSiblingSubviewWithPreviousView:currentView];
}

- (UIView *)sia_nextSiblingSubviewWithPreviousView:(UIView *)currentView
{
    UIView *parentView = currentView.superview;
    NSInteger index = [parentView.subviews indexOfObject:currentView];
    if (index + 1 < parentView.subviews.count) {
        return parentView.subviews[index + 1];
    }
    else if (parentView == self) {
        return nil;
    }
    else {
        return [self sia_nextSiblingSubviewWithPreviousView:parentView];
    }
}

- (NSInteger)sia_depthToView:(UIView *)view
{
    if (view == self) {
        // viewがselfの場合、距離は0
        return 0;
    }
    
    NSInteger depth = 0;
    for (UIView *v in view.sia_superviewEnumerator) {
        // selfより下層の場合は 0 < depth
        depth++;
        if (v == self) {
            return depth;
        }
    }
    
    depth = 0;
    for (UIView *v in self.sia_superviewEnumerator) {
        // selfより上層の場合は depth < 0
        depth--;
        if (v == view) {
            return depth;
        }
    }
    
    return NSNotFound;
}

@end

@implementation SIASubviewsEnumerator

- (instancetype)initWithView:(UIView *)rootView maxDepth:(NSInteger)maxDepth
{
    self = [super init];
    if (self) {
        _rootView = rootView;
        _maxDepth = maxDepth;
    }
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    if (self.maxDepth == 0) {
        return 0;
    }
    
    if (buffer != NULL && len > 0) {
        state->itemsPtr = buffer;
    }
    else {
        return 0;
    }
    
    if (state->state == 0) {
        state->mutationsPtr = (unsigned long *)(__bridge void *)self;
    }
    
    NSInteger containedCount = 0;
    for (int i = 0; i < len; i++) {
        UIView *previousView = (__bridge_transfer UIView *)(void *)state->extra[0];
        UIView *v = [self.rootView sia_nextRecursiveSubviewWithPreviousView:previousView maxDepth:self.maxDepth];
        if (v != nil) {
            state->itemsPtr[i] = v;
            state->extra[0] = (unsigned long)(__bridge_retained void *)v;
            containedCount++;
            state->state++;
        }
        else {
            break;
        }
    }
    
    return containedCount;
}

@end
