//
//  NSString+SITools.h
//  SITools
//
//  Created by Kurosaki Ryota on 12/04/26.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SITools)

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format locale:(NSLocale*)locale;

@end
