//
//  SIKeyboardAdjuster.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/11/24.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIKeyboardAdjuster.h"

@implementation SIKeyboardAdjuster
{
    NSMutableArray *_targets;
}

- (id)init
{
    self = [super init];
    if (self) {
        _targets = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc
{
    [self stopAdjustment];
}

- (void)startAdjustment
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopAdjustment
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)addTargetView:(UIView *)targetView
{
    [self addTargetView:targetView visibleView:nil];
}

- (void)addTargetView:(UIView *)targetView visibleView:(UIView *)visibleView
{
    if (targetView == nil) {
        return;
    }
    NSMutableDictionary *targetSet = [NSMutableDictionary dictionaryWithObject:targetView forKey:@"targetView"];
    if (visibleView) {
        [targetSet setValue:visibleView forKey:@"visibleView"];
    }
    [_targets addObject:targetSet];
}

- (void)removeTargetView:(UIView *)targetView
{
    [self removeTargetView:targetView visibleView:nil];
}

- (void)removeTargetView:(UIView *)targetView visibleView:(UIView *)visibleView
{
    [_targets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *d = (NSDictionary *)obj;
        UIView *tv = [d valueForKey:@"targetView"];
        UIView *vv = [d valueForKey:@"visibleView"];
        if (tv == targetView && vv == visibleView) {
            [_targets removeObject:d];
            *stop = YES;
        }
    }];
}

- (void)displayFirstResponder
{
    UIView *firstResponder = nil;
    UIView *visibleView = nil;
    
    NSDictionary *target = [self searchFirstResponderTarget];
    if (target) {
        firstResponder = [target valueForKey:@"targetView"];
        if (_scrollView == nil) {
            _scrollView = [self searchParentScrollView:firstResponder];
        }
        visibleView = [target valueForKey:@"visibleView"];
        if (visibleView == nil) {
            visibleView = firstResponder;
        }
    }
    else {
        firstResponder = [self searchFirstResponderInSubviews:_scrollView];
        visibleView = firstResponder;
    }
    
    if (visibleView && _scrollView) {
        CGRect frameInScroll = [_scrollView convertRect:visibleView.frame fromView:visibleView.superview];
        CGRect insetRect = UIEdgeInsetsInsetRect(_scrollView.bounds, _scrollView.contentInset);
        if (!CGRectContainsRect(insetRect, frameInScroll)) {
            [_scrollView scrollRectToVisible:frameInScroll animated:YES];
        }
    }
}

- (NSDictionary *)searchFirstResponderTarget
{
    __block NSDictionary *target = nil;
    [_targets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *d = (NSDictionary *)obj;
        UIView *v = [d valueForKey:@"targetView"];
        if (v.isFirstResponder) {
            target = d;
            *stop = YES;
        }
    }];
    return target;
}

- (UIView *)searchFirstResponderInSubviews:(UIView *)parentView
{
    __block UIView *firstResponder = nil;
    [parentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *v = (UIView *)obj;
        if (v.isFirstResponder) {
            firstResponder = v;
            *stop = YES;
        }
        else {
            firstResponder = [self searchFirstResponderInSubviews:v];
            if (firstResponder) {
                *stop = YES;
            }
        }
    }];
    return firstResponder;
}

- (UIScrollView *)searchParentScrollView:(UIView *)view
{
    UIScrollView *scrollView = nil;
    UIView *superview = view;
    while (YES) {
        superview = superview.superview;
        if (superview == nil) {
            break;
        }
        if ([superview isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)superview;
            break;
        }
    }
    return scrollView;
}

#pragma mark - Keyboard notification

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    if (_scrollView == nil) {
        NSDictionary *target = [self searchFirstResponderTarget];
        _scrollView = [self searchParentScrollView:[target valueForKey:@"targetView"]];
    }
    
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect scrollFrame = [_scrollView.superview convertRect:_scrollView.frame toView:_scrollView.window];
    CGFloat bottomPadding = CGRectGetMaxY(_scrollView.window.bounds) - CGRectGetMaxY(scrollFrame);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - bottomPadding, 0.0);
    
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
    }];
    
    [self displayFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration animations:^{
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

@end
