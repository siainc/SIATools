//
//  UIActionSheet+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UIActionSheet+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIActionSheet (SIABlocks)

- (void)sia_setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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

- (void)sia_setCancelUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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

- (void)sia_setWillPresentUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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

- (void)sia_setDidPresentUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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

- (void)sia_setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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

- (void)sia_setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block
{
    [self sia_implementProtocol:@protocol(UIActionSheetDelegate)
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
