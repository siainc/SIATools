//
//  NSString+SITools.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SITools)

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format locale:(NSLocale *)locale;

@end
