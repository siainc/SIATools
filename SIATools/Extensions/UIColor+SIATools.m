//
//  UIColor+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/26.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import "UIColor+SIATools.h"

@implementation UIColor (SIATools)

+ (UIColor *)sia_colorWithHexString:(NSString *)hexString
{
    NSError *validateError = nil;
    NSRegularExpression *validateRegex = [NSRegularExpression regularExpressionWithPattern:@"^#?[0-9A-Fa-f]{3,8}" options:0 error:&validateError];
    if (validateError) {
        return nil;
    }
    NSTextCheckingResult *validateResult = [validateRegex firstMatchInString:hexString options:0 range:NSMakeRange(0, hexString.length)];
    if (validateResult.numberOfRanges == 0) {
        return nil;
    }
    
    NSString *value = hexString;
    if ([hexString characterAtIndex:0] == '#') {
        value = [value substringFromIndex:1];
    }
    
    UIColor *color = nil;
    CGFloat rgbaMax = 255.0;
    NSRegularExpression *regex = nil;
    NSError *error = nil;
    if (value.length == 6 || value.length == 8) {
        // rgb (max 255)
        rgbaMax = 255.0;
        regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})?"
                                                          options:0 error:&error];
    }
    else if (value.length == 3 || value.length == 4) {
        // rgb (max 15)
        rgbaMax = 15.0;
        regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])?"
                                                          options:0 error:&error];
    }
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *result = [regex firstMatchInString:value options:0 range:NSMakeRange(0, value.length)];
    if (result.numberOfRanges > 0) {
        unsigned int r = 0, g = 0, b = 0, a = rgbaMax;
        [[NSScanner scannerWithString:[value substringWithRange:[result rangeAtIndex:1]]] scanHexInt:&r];
        [[NSScanner scannerWithString:[value substringWithRange:[result rangeAtIndex:2]]] scanHexInt:&g];
        [[NSScanner scannerWithString:[value substringWithRange:[result rangeAtIndex:3]]] scanHexInt:&b];
        if ([result rangeAtIndex:4].location != NSNotFound) {
            [[NSScanner scannerWithString:[value substringWithRange:[result rangeAtIndex:4]]] scanHexInt:&a];
        }
        color = [UIColor colorWithRed:r / rgbaMax green:g / rgbaMax blue:b / rgbaMax alpha:a / rgbaMax];
    }
    return color;
}

@end
