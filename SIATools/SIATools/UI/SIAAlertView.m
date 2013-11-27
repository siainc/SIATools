//
//  SIAAlertView.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/12.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAAlertView.h"
#import "SIAToolsLogger.h"

@interface SIAAlertView ()
@property (nonatomic, unsafe_unretained) id <UIAlertViewDelegate> intarnalDelegate;
@end

@implementation SIAAlertView
@dynamic progressView;
@dynamic indicatorView;

+ (SIAAlertView *)loadingAlertViewWithTitle:(NSString *)title
                                    message:(NSString *)message
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                          otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    SIAToolsDLog(@">>title=%@, message=%@, cancelButtonTitle=%@, otherButtonTitles=%@", title, message, cancelButtonTitle, otherButtonTitles);
    SIAAlertView *alertView = [[SIAAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:nil];
    va_list argumentList;
    if (otherButtonTitles) {
        va_start(argumentList, otherButtonTitles);
        NSString *otherButtonTitle = otherButtonTitles;
        while (otherButtonTitle != nil) {
            [alertView addButtonWithTitle:otherButtonTitle];
            otherButtonTitle = va_arg(argumentList, NSString *);
        }
        va_end(argumentList);
    }
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    alertView.customView = indicatorView;
    SIAToolsDLog(@"<<%@", alertView);
    return alertView;
}

+ (SIAAlertView *)progressAlertViewWithTitle:(NSString *)title
                                     message:(NSString *)message
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    SIAToolsDLog(@">>title=%@, message=%@, cancelButtonTitle=%@, otherButtonTitles=%@", title, message, cancelButtonTitle, otherButtonTitles);
    SIAAlertView *alertView = [[SIAAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:nil];
    va_list argumentList;
    if (otherButtonTitles) {
        va_start(argumentList, otherButtonTitles);
        NSString *otherButtonTitle = otherButtonTitles;
        while (otherButtonTitle != nil) {
            [alertView addButtonWithTitle:otherButtonTitle];
            otherButtonTitle = va_arg(argumentList, NSString *);
        }
        va_end(argumentList);
    }
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progress = 0;
    CGRect         frame         = progressView.frame;
    frame.size.width      = 200;
    progressView.frame    = frame;
    alertView.customView  = progressView;
    SIAToolsDLog(@"<<%@", alertView);
    return alertView;
}

- (void)setCustomView:(UIView *)customView
{
    [_customView removeFromSuperview];
    _customView = customView;
    NSMutableString *message = [self.message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].mutableCopy;
    if (message == nil) {
        message = [NSMutableString string];
    }
    if (_customView) {
        if (message.length > 0) {
            [message appendString:@"\n"];
        }
        NSInteger newLineNumber = ceil(CGRectGetHeight(_customView.frame) / 20.0);
        for (int i = 0; i < newLineNumber; i++) {
            [message appendString:@"\n"];
        }
    }
    self.message = message;
    [self setNeedsLayout];
    [self sizeToFit];
    if (_customView) {
        _customView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:_customView];
    }
}

- (UIActivityIndicatorView *)indicatorView
{
    if ([self.customView isKindOfClass:[UIActivityIndicatorView class]]) {
        return (UIActivityIndicatorView *)self.customView;
    }
    return nil;
}

- (UIProgressView *)progressView
{
    if ([self.customView isKindOfClass:[UIProgressView class]]) {
        return (UIProgressView *)self.customView;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.customView) {
        CGFloat labelMaxY = 0;
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                labelMaxY = MAX(labelMaxY, CGRectGetMaxY(v.frame));
            }
        }
        CGRect frame = self.customView.frame;
        frame.origin.x = floorf((CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2.0);
        if (labelMaxY > 0) {
            frame.origin.y = labelMaxY - CGRectGetHeight(frame);
        }
        else {
            frame.origin.y = 0;
        }
        self.customView.frame = frame;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        super.delegate = self;
    }
    return self;
}

- (void)showWithClicked:(void (^)(NSInteger buttonIndex))clicked
{
    self.clickedButtonAtIndexBlock = clicked;
    [self show];
}

- (void)setDelegate:(id)delegate
{
    if (delegate != self) {
        self.intarnalDelegate = delegate;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_clickedButtonAtIndexBlock) {
        _clickedButtonAtIndexBlock(buttonIndex);
    }
    if ([_intarnalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_intarnalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    if ([_intarnalDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [_intarnalDelegate alertViewCancel:alertView];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (_willPresentBlock) {
        _willPresentBlock();
    }
    if ([_intarnalDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_intarnalDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (_didPresentBlock) {
        _didPresentBlock();
    }
    if ([_intarnalDelegate respondsToSelector:@selector(didAddSubview:)]) {
        [_intarnalDelegate didPresentAlertView:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_willDismissWithButtonIndeBlock) {
        _willDismissWithButtonIndeBlock(buttonIndex);
    }
    if ([_intarnalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [_intarnalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_didDismissWithButtonIndexBlock) {
        _didDismissWithButtonIndexBlock(buttonIndex);
    }
    if ([_intarnalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [_intarnalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    BOOL enable = YES;
    if (_shouldEnableFirstOtherButtonBlock) {
        enable = _shouldEnableFirstOtherButtonBlock();
    }
    if ([_intarnalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        enable = [_intarnalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    return enable;
}

@end
