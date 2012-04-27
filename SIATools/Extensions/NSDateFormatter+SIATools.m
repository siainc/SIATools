//
//  NSDateFormatter+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/06.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSDateFormatter+SIATools.h"

#import "NSArray+SIATools.h"

static NSMutableArray *_siatoolsDateFormatterPool;

@implementation NSDateFormatter (SIATools)

+ (NSDateFormatter *)sia_dateFormatterWithFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = locale;
    formatter.timeZone = timeZone;
    return formatter;
}

+ (NSDateFormatter *)sia_cachedObjectWithFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _siatoolsDateFormatterPool = [NSMutableArray arrayWithCapacity:5];
    });
    
    if (locale != nil) {
        locale = [NSLocale currentLocale];
    }
    if (timeZone != nil) {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    NSDateFormatter *formatter = [_siatoolsDateFormatterPool sia_objectOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDateFormatter *df = obj;
        if ([df.dateFormat isEqualToString:format] &&
            [df.locale.localeIdentifier isEqualToString:locale.localeIdentifier] &&
            df.timeZone.secondsFromGMT == timeZone.secondsFromGMT)
        {
            return YES;
        }
        return NO;
    } ifNoneBlock:^id{
        return [self sia_dateFormatterWithFormat:format locale:locale timeZone:timeZone];
    }];
    
    [_siatoolsDateFormatterPool removeObject:formatter];
    [_siatoolsDateFormatterPool sia_pushObject:formatter];
    if (_siatoolsDateFormatterPool.count > 5) {
        [_siatoolsDateFormatterPool sia_shiftObject];
    }
    return formatter;
}

@end
