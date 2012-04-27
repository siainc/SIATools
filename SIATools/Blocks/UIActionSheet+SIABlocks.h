//
//  UIActionSheet+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (SIABlocks)

- (void)sia_setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block;
- (void)sia_setCancelUsingBlock:(void (^)())block;
- (void)sia_setWillPresentUsingBlock:(void (^)())block;
- (void)sia_setDidPresentUsingBlock:(void (^)())block;
- (void)sia_setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block;
- (void)sia_setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block;

@end
