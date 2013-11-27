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
#import "SIAToolsLogger.h"

@interface SIAOverlayView ()
@property (nonatomic, copy, readwrite) NSArray *disableViewStatuses;
@end

@implementation SIAOverlayView

- (id)initWithFrame:(CGRect)frame
{
    SIAToolsDLog(@">>frame=%@", NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    SIAToolsDLog(@">>aDecoder=%@", aDecoder);
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

- (void)initialize
{
    SIAToolsDLog(@">>");
    _overlaidViewDisable = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    SIAToolsDLog(@"<<");
}

+ (SIAOverlayView *)rootOverlayViewWithRootView:(UIView *)rootView
{
    return [rootView.subviews objectOfObjectPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[SIAOverlayView class]];
    }];
}

+ (SIAOverlayView *)endOverlayViewWithRootView:(UIView *)rootView
{
    SIAOverlayView *endOverlayView = nil;
    SIAOverlayView *v              = [self rootOverlayViewWithRootView:rootView];
    while (v) {
        endOverlayView = v;
        v              = v.childOverlayView;
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
    SIAToolsDLog(@">>");
    [self showAnimated:NO completion:nil];
    SIAToolsDLog(@"<<");
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    SIAToolsDLog(@">>animated=%d, completion=%@", animated, completion);
    [self showAnimated:animated rootView:[UIApplication sharedApplication].keyWindow completion:completion];
    SIAToolsDLog(@"<<");
}

- (void)showAnimated:(BOOL)animated rootView:(UIView *)rootView completion:(void (^)(BOOL finished))completion
{
    SIAToolsDLog(@">>animated=%d, completion=%@", animated, completion);
    SIAOverlayView *endOverlayView = [SIAOverlayView endOverlayViewWithRootView:rootView];
    if (endOverlayView) {
        SIAToolsDLog(@"2枚目以降のOverlayの場合");
        self.parentOverlayView          = endOverlayView;
        endOverlayView.childOverlayView = self;
        
        self.overlaidView               = endOverlayView;
    }
    else {
        SIAToolsDLog(@"ルートOverlayの場合");
        self.parentOverlayView = nil;
        
        self.overlaidView      = rootView;
    }
    
    if (self.overlaidViewDisable) {
        self.disableViewStatuses = [self.overlaidView.subviews mappedArray:^id (id obj, NSUInteger idx, BOOL *stop) {
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
    SIAToolsDLog(@"<<");
}

- (void)dismiss
{
    SIAToolsDLog(@">>");
    [self dismissAnimated:NO completion:nil];
    SIAToolsDLog(@"<<");
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    SIAToolsDLog(@">>animated=%d, completion=%@", animated, completion);
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
    SIAToolsDLog(@"<<");
}

- (void)didMoveToSuperview
{
    SIAToolsDLog(@">>");
    SIAToolsDLog(@"サイズ固定、縦横ともにセンタリングで配置する");
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
    SIAToolsDLog(@"<<");
}

@end
