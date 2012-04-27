//
//  NSString+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SIATools)

+ (NSString *)sia_stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)sia_stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale;
+ (NSString *)sia_stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

- (NSArray *)sia_versionComponents;
- (NSComparisonResult)sia_compareVersion:(NSString *)versionString;
- (NSString *)sia_stringByAppendingFileNameSuffix:(NSString *)suffix;
- (NSString *)sia_imageNameStringByAppendingResolution:(BOOL)resolution deviceModifier:(BOOL)deviceModifier fourInch:(BOOL)fourInch;

@end
