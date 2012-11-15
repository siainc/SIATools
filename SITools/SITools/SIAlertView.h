//
//  SIAlertView.h
//  SITools
//
//  Created by Kurosaki on 2011/10/12.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIAlertView : UIAlertView <UIAlertViewDelegate>

@property(nonatomic,copy) void (^clickedButtonAtIndexBlock)(NSInteger buttonIndex);
@property(nonatomic,copy) void (^cancelBlock)();
@property(nonatomic,copy) void (^willPresentBlock)();
@property(nonatomic,copy) void (^didPresentBlock)();
@property(nonatomic,copy) void (^willDismissWithButtonIndeBlock)(NSInteger buttonIndex);
@property(nonatomic,copy) void (^didDismissWithButtonIndexBlock)(NSInteger buttonIndex);
@property(nonatomic,copy) BOOL (^shouldEnableFirstOtherButtonBlock)();

@end
