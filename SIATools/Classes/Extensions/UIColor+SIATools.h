//
//  UIColor+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/26.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SIATools)

+ (UIColor *)sia_colorWithHexString:(NSString *)hexString;
+ (UIColor *)sia_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@property (readonly, nonatomic) NSString *hexString;
- (NSString *)hexStringHasAlpha:(BOOL)hasAlpha;

@end
