//
//  UIAlertView+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "UIAlertView+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIAlertView (SIABlocks)

- (void)showWithClicked:(void (^)(NSInteger buttonIndex))block
{
    [self setClickedUsingBlock:block];
    [self show];
}

- (void)setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block;
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(alertView:clickedButtonAtIndex:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView, NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

- (void)setCancelUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(alertViewCancel:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView)
          {
              block();
          }];
     }];
}

- (void)setWillPresentUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(willPresentAlertView:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView)
          {
              block();
          }];
     }];
}

- (void)setDidPresentUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(didPresentAlertView:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView)
          {
              block();
          }];
     }];
}

- (void)setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(alertView:willDismissWithButtonIndex:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView, NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

- (void)setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(alertView:didDismissWithButtonIndex:)
                                   block:^ void (SIABlockProtocol *protocol, UIAlertView *alertView, NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

- (void)setShouldEnableFirstOtherButtonUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UIAlertViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(alertViewShouldEnableFirstOtherButton:)
                                   block:^ BOOL (SIABlockProtocol *protocol, UIAlertView *alertView)
          {
              return block();
          }];
     }];
}

@end
