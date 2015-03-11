//
//  NSURL+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/05/08.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SIATools)
+ (NSURL *)sia_URLWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path;
- (NSURL *)sia_URLByAppendingQueryWithDictionary:(NSDictionary *)dictionary;
- (NSURL *)sia_URLByAppendingQueryValuesAndKeys:(NSString *)firstValue, ...;
- (NSURL *)sia_URLByAppendingQueryValue:(NSString *)value andKey:(NSString *)key;
- (NSURL *)sia_URLByAppendingQuery:(NSString *)query;
@end

@interface NSString (NSURLForSIATools)
- (NSString *)sia_stringByURLEncode;
- (NSString *)sia_stringByURLDecode;
+ (NSString *)sia_queryStringWithValue:(NSString *)value andKey:(NSString *)key;
+ (NSString *)sia_queryStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)sia_queryStringWithValuesAndKeys:(NSString *)firstValue, ...;
+ (NSString *)sia_queryStringWithValuesAndKeys:(NSString *)firstValue list:(va_list)argumentList;
- (NSString *)sia_queryStringByAppendingDictionary:(NSDictionary *)dictionary;
- (NSString *)sia_queryStringByAppendingValue:(NSString *)value andKey:(NSString *)key;
- (NSString *)sia_queryStringByAppendingQueryString:(NSString *)query;
@end
