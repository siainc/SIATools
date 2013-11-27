//
//  NSString+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSString+SIATools.h"

#import "NSArray+SIATools.h"
#import "NSDateFormatter+SIATools.h"

@implementation NSString (SIATools)

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    NSString *string = [self stringFromDate:date withFormat:format locale:nil];
    return string;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale
{
    return [self stringFromDate:date withFormat:format locale:locale timeZone:nil];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [NSDateFormatter cachedObjectWithFormat:format locale:locale timeZone:timeZone];
    return [formatter stringFromDate:date];
}

- (NSArray *)versionComponents
{
    NSError              *error  = nil;
    NSRegularExpression  *regex  = [NSRegularExpression regularExpressionWithPattern:@"^\\d+(\\.\\d+)*\\.?$" options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (result.numberOfRanges == 0) {
        return nil;
    }
    
    NSArray *components = [[self componentsSeparatedByString:@"."] mappedArray:^id (id obj, NSUInteger idx, BOOL *stop) {
        return @([obj integerValue]);
    }];
    return components;
}

- (NSComparisonResult)compareVersion:(NSString *)versionString
{
    NSArray   *my    = [self versionComponents];
    NSArray   *other = [versionString versionComponents];
    
    NSInteger max    = MAX(my.count, other.count);
    for (int i = 0; i < max; i++) {
        NSInteger a = [[my objectAtIndex:i ifNil:@(0)] integerValue];
        NSInteger b = [[other objectAtIndex:i ifNil:@(0)] integerValue];
        if (a < b) {
            return NSOrderedAscending;
        }
        else if (a > b) {
            return NSOrderedDescending;
        }
        else {
            continue;
        }
    }
    return NSOrderedSame;
}

- (NSString *)stringByAppendingFileNameSuffix:(NSString *)suffix
{
    NSString *extension = self.pathExtension;
    NSString *baseName  = self.stringByDeletingPathExtension;
    return [[baseName stringByAppendingString:suffix] stringByAppendingPathExtension:extension];
}

- (NSString *)imageNameStringByAppendingResolution:(BOOL)resolution deviceModifier:(BOOL)deviceModifier fourInch:(BOOL)fourInch
{
    NSMutableString *suffix = @"".mutableCopy;
    if (fourInch && CGRectGetHeight([UIScreen mainScreen].bounds) >= 568) {
        [suffix appendString:@"-568h"];
    }
    if (resolution && [UIScreen mainScreen].scale == 2.0) {
        [suffix appendString:@"@2x"];
    }
    if (deviceModifier) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [suffix appendString:@"~iphone"];
        }
        else {
            [suffix appendString:@"~ipad"];
        }
    }
    return [self stringByAppendingFileNameSuffix:suffix];
}

@end
