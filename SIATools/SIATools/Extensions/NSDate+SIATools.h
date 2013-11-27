//
//  NSDate+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SIATools)

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format locale:(NSLocale *)locale;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
                calendar:(NSCalendar *)calendar;

@property (nonatomic, readonly) NSDateComponents *components;
- (NSDateComponents *)componentsWithCalendar:(NSCalendar *)calendar;

@end
