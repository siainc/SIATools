//
//  NSString+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SIATools)

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

- (NSArray *)versionComponents;
- (NSComparisonResult)compareVersion:(NSString *)versionString;
- (NSString *)stringByAppendingFileNameSuffix:(NSString *)suffix;
- (NSString *)imageNameStringByAppendingResolution:(BOOL)resolution deviceModifier:(BOOL)deviceModifier fourInch:(BOOL)fourInch;

@end
