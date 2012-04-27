//
//  NSString+SITools.m
//  SITools
//
//  Created by Kurosaki Ryota on 12/04/26.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import "NSString+SITools.h"

@implementation NSString (SITools)

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format 
{
    NSString *string = [self stringFromDate:date withFormat:format locale:[NSLocale currentLocale]];
    return string;
}

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format locale:(NSLocale*)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = locale;
    NSString *string = [formatter stringFromDate:date];
    return string;
}

@end
