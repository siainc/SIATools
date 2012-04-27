//
//  UIAlertView+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UIAlertView+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIAlertView (SIABlocks)

- (void)sia_showWithClicked:(void (^)(NSInteger buttonIndex))block
{
    [self sia_setClickedUsingBlock:block];
    [self show];
}

- (void)sia_setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block;
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setCancelUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setWillPresentUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setDidPresentUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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

- (void)sia_setShouldEnableFirstOtherButtonUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UIAlertViewDelegate)
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
