//
//  SIAlertView.m
//  SITools
//
//  Created by Kurosaki on 2011/10/12.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAlertView.h"

@interface SIAlertView ()
@property(nonatomic,weak) id<UIAlertViewDelegate> intarnalDelegate;
@end

@implementation SIAlertView

- (id)init
{
    self = [super init];
    if (self) {
        super.delegate = self;
    }
    return self;
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
