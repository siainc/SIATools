//
//  NSDate+SITools.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SITools)

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format locale:(NSLocale *)locale;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                   hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                   hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
               calendar:(NSCalendar *)calendar;

@property(nonatomic,readonly) NSDateComponents *components;
- (NSDateComponents *)componentsWithCalendar:(NSCalendar *)calendar;

@end
