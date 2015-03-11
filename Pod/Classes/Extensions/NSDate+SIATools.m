//
//  NSDate+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2015 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSDate+SIATools.h"

@implementation NSDate (SIATools)
@dynamic sia_components;

+ (NSDate *)sia_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                        hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDate *date = [self sia_dateWithYear:year month:month day:day
                                     hour:hour minute:minute second:second
                                 calendar:[NSCalendar currentCalendar]];
    return date;
}

+ (NSDate *)sia_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                        hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
                    calendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (NSDateComponents *)sia_components
{
    NSDateComponents *components = [self sia_componentsWithCalendar:[NSCalendar currentCalendar]];
    return components;
}

- (NSDateComponents *)sia_componentsWithCalendar:(NSCalendar *)calendar
{
    NSUInteger unitFlags = (NSEraCalendarUnit |
                            NSYearCalendarUnit |
                            NSMonthCalendarUnit |
                            NSDayCalendarUnit |
                            NSHourCalendarUnit |
                            NSMinuteCalendarUnit |
                            NSSecondCalendarUnit |
                            NSWeekCalendarUnit |
                            NSWeekdayCalendarUnit |
                            NSWeekdayOrdinalCalendarUnit |
                            NSQuarterCalendarUnit |
                            NSWeekOfMonthCalendarUnit |
                            NSWeekOfYearCalendarUnit |
                            NSYearForWeekOfYearCalendarUnit);
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    return components;
}

@end
