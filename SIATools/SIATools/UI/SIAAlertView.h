//
//  SIAAlertView.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/12.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIAAlertView :   UIAlertView <UIAlertViewDelegate>

@property (nonatomic, copy) void (^clickedButtonAtIndexBlock)(NSInteger buttonIndex);
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^willPresentBlock)();
@property (nonatomic, copy) void (^didPresentBlock)();
@property (nonatomic, copy) void (^willDismissWithButtonIndeBlock)(NSInteger buttonIndex);
@property (nonatomic, copy) void (^didDismissWithButtonIndexBlock)(NSInteger buttonIndex);
@property (nonatomic, copy) BOOL (^shouldEnableFirstOtherButtonBlock)();

- (void)showWithClicked:(void (^)(NSInteger buttonIndex))clicked;

@property (nonatomic, strong) UIView                    *customView;
@property (nonatomic, readonly) UIProgressView          *progressView;
@property (nonatomic, readonly) UIActivityIndicatorView *indicatorView;
+ (SIAAlertView *)loadingAlertViewWithTitle:(NSString *)title
                                    message:(NSString *)message
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                          otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (SIAAlertView *)progressAlertViewWithTitle:(NSString *)title
                                     message:(NSString *)message
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
