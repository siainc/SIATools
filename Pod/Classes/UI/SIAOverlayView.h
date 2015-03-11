//
//  SIAOverlayView.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/05.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIAOverlayView : UIView

@property (nonatomic, weak, readwrite) UIView *overlaidView;
@property (nonatomic, weak, readwrite) SIAOverlayView *parentOverlayView;
@property (nonatomic, strong, readwrite) SIAOverlayView *childOverlayView;
@property (nonatomic, assign, readwrite) BOOL overlaidViewDisable;

- (void)show;
- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)showAnimated:(BOOL)animated rootView:(UIView *)rootView completion:(void (^)(BOOL finished))completion;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@property (nonatomic, copy, readwrite) void (^willShowing)();
@property (nonatomic, copy, readwrite) void (^didShowing)(BOOL finished);
@property (nonatomic, copy, readwrite) void (^willDismissing)();
@property (nonatomic, copy, readwrite) void (^didDismissing)(BOOL finished);

+ (SIAOverlayView *)rootOverlayViewWithRootView:(UIView *)rootView;
+ (SIAOverlayView *)endOverlayViewWithRootView:(UIView *)rootView;

- (SIAOverlayView *)rootOvarlayView;
- (SIAOverlayView *)endOverlayView;

@end
