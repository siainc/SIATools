//
//  UIActionSheet+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "UIActionSheet+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIActionSheet (SIABlocks)

- (void)setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(actionSheet:clickedButtonAtIndex:)
                                   block:^void (NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

- (void)setCancelUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(actionSheetCancel:)
                                   block:^void ()
          {
              block();
          }];
     }];
}

- (void)setWillPresentUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(willPresentActionSheet:)
                                   block:^void ()
          {
              block();
          }];
     }];
}

- (void)setDidPresentUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(didPresentActionSheet:)
                                   block:^void ()
          {
              block();
          }];
     }];
}

- (void)setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(actionSheet:willDismissWithButtonIndex:)
                                   block:^void (NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

- (void)setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self implementProtocol:@protocol(UIActionSheetDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(actionSheet:didDismissWithButtonIndex:)
                                   block:^void (NSInteger buttonIndex)
          {
              block(buttonIndex);
          }];
     }];
}

@end
