//
//  SIAKeyboardAdjuster.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/24.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAKeyboardAdjuster.h"
#import "SIAToolsLogger.h"

@interface SIAKeyboardAdjuster ()
@property (nonatomic, strong) NSMutableArray *targets;
@end

@implementation SIAKeyboardAdjuster

- (id)init
{
    SIAToolsDLog(@">>");
    self = [super init];
    if (self) {
        _targets = [NSMutableArray arrayWithCapacity:1];
    }
    SIAToolsDLog(@"<<");
    return self;
}

- (void)dealloc
{
    SIAToolsDLog(@">>");
    [self stopAdjustment];
    SIAToolsDLog(@"<<");
}

- (void)startAdjustment
{
    SIAToolsDLog(@">>");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    SIAToolsDLog(@"<<");
}

- (void)stopAdjustment
{
    SIAToolsDLog(@">>");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    _scrollView.contentInset          = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    SIAToolsDLog(@"<<");
}

- (void)addTargetView:(UIView *)targetView
{
    SIAToolsDLog(@">>targetView=%@", targetView);
    [self addTargetView:targetView visibleView:nil];
    SIAToolsDLog(@"<<");
}

- (void)addTargetView:(UIView *)targetView visibleView:(UIView *)visibleView
{
    SIAToolsDLog(@">>targetView=%@, visibleView=%@", targetView, visibleView);
    if (targetView == nil) {
        SIAToolsDLog(@"<<");
        return;
    }
    NSMutableDictionary *targetSet = [NSMutableDictionary dictionaryWithObject:targetView forKey:@"targetView"];
    if (visibleView) {
        [targetSet setValue:visibleView forKey:@"visibleView"];
    }
    [self removeTargetView:targetView visibleView:visibleView];
    [_targets addObject:targetSet];
    SIAToolsDLog(@"<<");
}

- (void)removeTargetView:(UIView *)targetView
{
    SIAToolsDLog(@">>targetView=%@", targetView);
    [self removeTargetView:targetView visibleView:nil];
    SIAToolsDLog(@"<<");
}

- (void)removeTargetView:(UIView *)targetView visibleView:(UIView *)visibleView
{
    SIAToolsDLog(@">>targetView=%@, visibleView=%@", targetView, visibleView);
    [_targets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *d = (NSDictionary *)obj;
        UIView *tv = [d valueForKey:@"targetView"];
        UIView *vv = [d valueForKey:@"visibleView"];
        if (tv == targetView && vv == visibleView) {
            [_targets removeObject:d];
            *stop = YES;
        }
    }];
    SIAToolsDLog(@"<<");
}

- (void)displayFirstResponder
{
    SIAToolsDLog(@">>");
    UIView       *firstResponder = nil;
    UIView       *visibleView    = nil;
    
    NSDictionary *target         = [self searchFirstResponderTarget];
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
        visibleView    = firstResponder;
    }
    
    if (visibleView && _scrollView) {
        SIAToolsDLog(@"表示するビューと_scrollViewが見つかった場合、スクロールしてvisibleViewを見えるようにする");
        CGRect frameInScroll = [_scrollView convertRect:visibleView.frame fromView:visibleView.superview];
        CGRect insetRect     = UIEdgeInsetsInsetRect(_scrollView.bounds, _scrollView.contentInset);
        if (!CGRectContainsRect(insetRect, frameInScroll)) {
            [_scrollView scrollRectToVisible:frameInScroll animated:YES];
        }
    }
    SIAToolsDLog(@">>");
}

- (NSDictionary *)searchFirstResponderTarget
{
    SIAToolsDLog(@">>");
    __block NSDictionary *target = nil;
    [_targets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *d = (NSDictionary *)obj;
        UIView *v = [d valueForKey:@"targetView"];
        if (v.isFirstResponder) {
            target = d;
            *stop = YES;
        }
    }];
    SIAToolsDLog(@"<<%@", target);
    return target;
}

- (UIView *)searchFirstResponderInSubviews:(UIView *)parentView
{
    SIAToolsDLog(@">>parentView=%@", parentView);
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
    SIAToolsDLog(@"<<%@", firstResponder);
    return firstResponder;
}

- (UIScrollView *)searchParentScrollView:(UIView *)view
{
    SIAToolsDLog(@">>view=%@", view);
    UIScrollView *scrollView = nil;
    UIView       *superview  = view;
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
    SIAToolsDLog(@"<<%@", scrollView);
    return scrollView;
}

#pragma mark - Keyboard notification

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    SIAToolsDLog(@">>aNotification=%@", aNotification);
    if (_scrollView == nil) {
        NSDictionary *target = [self searchFirstResponderTarget];
        _scrollView = [self searchParentScrollView:[target valueForKey:@"targetView"]];
    }
    
    NSDictionary   *info             = [aNotification userInfo];
    CGSize         kbSize            = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect         scrollFrame       = [_scrollView.superview convertRect:_scrollView.frame toView:_scrollView.window];
    CGFloat        bottomPadding     = CGRectGetMaxY(_scrollView.window.bounds) - CGRectGetMaxY(scrollFrame);
    UIEdgeInsets   contentInsets     = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - bottomPadding, 0.0);
    
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
    }];
    
    [self displayFirstResponder];
    SIAToolsDLog(@"<<");
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    SIAToolsDLog(@">>aNotification=%@", aNotification);
    NSDictionary   *info             = [aNotification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
    SIAToolsDLog(@"<<");
}

@end
