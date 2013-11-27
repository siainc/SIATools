//
//  UIAlertView+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (SIABlocks)

- (void)showWithClicked:(void (^)(NSInteger buttonIndex))button;

- (void)setClickedUsingBlock:(void (^)(NSInteger buttonIndex))block;
- (void)setCancelUsingBlock:(void (^)())block;
- (void)setWillPresentUsingBlock:(void (^)())block;
- (void)setDidPresentUsingBlock:(void (^)())block;
- (void)setWillDismissUsingBlock:(void (^)(NSInteger buttonIndex))block;
- (void)setDidDismissUsingBlock:(void (^)(NSInteger buttonIndex))block;
- (void)setShouldEnableFirstOtherButtonUsingBlock:(BOOL (^)())block;

@end
