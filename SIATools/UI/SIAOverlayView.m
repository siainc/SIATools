//
//  SIAOverlayView.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/05.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIAOverlayView.h"
#import "SIAWeakReference.h"
#import "NSArray+SIATools.h"

@interface SIAOverlayView ()
@property (nonatomic, copy, readwrite) NSArray *disableViewStatuses;
@end

@implementation SIAOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _overlaidViewDisable = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

+ (SIAOverlayView *)rootOverlayViewWithRootView:(UIView *)rootView
{
    return [rootView.subviews sia_objectOfObjectPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[SIAOverlayView class]];
    }];
}

+ (SIAOverlayView *)endOverlayViewWithRootView:(UIView *)rootView
{
    SIAOverlayView *endOverlayView = nil;
    SIAOverlayView *v = [self rootOverlayViewWithRootView:rootView];
    while (v) {
        endOverlayView = v;
        v = v.childOverlayView;
    }
    return endOverlayView;
}

- (SIAOverlayView *)rootOvarlayView
{
    SIAOverlayView *v = self;
    while (v.parentOverlayView != nil) {
        v = v.parentOverlayView;
    }
    return v;
}

- (SIAOverlayView *)endOverlayView
{
    SIAOverlayView *v = self;
    while (v.childOverlayView != nil) {
        v = v.childOverlayView;
    }
    return v;
}

- (void)show
{
    [self showAnimated:NO completion:nil];
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self showAnimated:animated rootView:[UIApplication sharedApplication].keyWindow completion:completion];
}

- (void)showAnimated:(BOOL)animated rootView:(UIView *)rootView completion:(void (^)(BOOL finished))completion
{
    SIAOverlayView *endOverlayView = [SIAOverlayView endOverlayViewWithRootView:rootView];
    if (endOverlayView) {
        // 2枚目以降のOverlayの場合
        self.parentOverlayView = endOverlayView;
        endOverlayView.childOverlayView = self;
        
        self.overlaidView = endOverlayView;
    }
    else {
        // ルートOverlayの場合
        self.parentOverlayView = nil;
        
        self.overlaidView = rootView;
    }
    
    if (self.overlaidViewDisable) {
        self.disableViewStatuses = [self.overlaidView.subviews sia_mappedArray:^id (id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = (UIView *)obj;
            return @{ @"view": [SIAWeakReference referenceWithObject:view],
                      @"userInteractionEnabled": @(view.userInteractionEnabled) };
        }];
        [self.overlaidView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setUserInteractionEnabled:NO];
        }];
    }
    
    if (self.willShowing) {
        self.willShowing();
    }
    if (animated) {
        [UIView transitionWithView:self.overlaidView.superview
                          duration:0.3
                           options:(UIViewAnimationOptionTransitionCrossDissolve |
                                    UIViewAnimationOptionCurveEaseOut)
                        animations:^{
                            [self.overlaidView addSubview:self];
                        } completion:^(BOOL finished) {
                            if (completion) {
                                completion(finished);
                            }
                            if (self.didShowing) {
                                self.didShowing(finished);
                            }
                        }];
    }
    else {
        [self.overlaidView addSubview:self];
        BOOL finished = YES;
        if (completion) {
            completion(finished);
        }
        if (self.didShowing) {
            self.didShowing(finished);
        }
    }
}

- (void)dismiss
{
    [self dismissAnimated:NO completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self.disableViewStatuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *v = [[obj objectForKey:@"view"] object];
        BOOL enabled = [[obj objectForKey:@"userInteractionEnabled"] boolValue];
        v.userInteractionEnabled = enabled;
    }];
    if (self.childOverlayView) {
        [self.childOverlayView dismissAnimated:NO completion:nil];
    }
    if (self.parentOverlayView) {
        self.parentOverlayView.childOverlayView = nil;
    }
    
    if (self.willDismissing) {
        self.willDismissing();
    }
    if (animated) {
        [UIView transitionWithView:self.overlaidView
                          duration:0.3
                           options:(UIViewAnimationOptionTransitionCrossDissolve |
                                    UIViewAnimationOptionCurveEaseIn)
                        animations:^{
                            [self removeFromSuperview];
                        } completion:^(BOOL finished) {
                            if (completion) {
                                completion(finished);
                            }
                            if (self.didDismissing) {
                                self.didDismissing(finished);
                            }
                        }];
    }
    else {
        [self removeFromSuperview];
        BOOL finished = YES;
        if (completion) {
            completion(finished);
        }
        if (self.didDismissing) {
            self.didDismissing(finished);
        }
    }
}

- (void)didMoveToSuperview
{
    // サイズ固定、縦横ともにセンタリングで配置する
    if (self.superview != nil && self.overlaidView != nil) {
        [self.overlaidView addConstraint:
         [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                         toItem:self.overlaidView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.overlaidView addConstraint:
         [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                         toItem:self.overlaidView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[self(==%f)]", CGRectGetWidth(self.frame)]
                                             options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[self(==%f)]", CGRectGetHeight(self.frame)]
                                             options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
}

@end
