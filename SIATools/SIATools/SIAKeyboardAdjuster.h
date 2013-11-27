//
//  SIAKeyboardAdjuster.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/24.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAKeyboardAdjuster :   NSObject

@property (nonatomic, assign) BOOL         searchSubviewsEnabled;
@property (nonatomic, strong) UIScrollView *scrollView;
- (void)startAdjustment;
- (void)stopAdjustment;
- (void)addTargetView:(UIView *)targetView;
- (void)addTargetView:(UIView *)targetView visibleView:(UIView *)visibleView;
- (void)removeTargetView:(UIView *)targetView;
- (void)removeTargetView:(UIView *)targetView visibleView:(UIView *)visibleView;
- (void)displayFirstResponder;

@end
