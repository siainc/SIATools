//
//  NSDateFormatter+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/06.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (SIATools)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;
+ (NSDateFormatter *)cachedObjectWithFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

@end
