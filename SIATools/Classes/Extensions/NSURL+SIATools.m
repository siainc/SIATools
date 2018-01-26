//
//  NSURL+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/05/08.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#import "NSURL+SIATools.h"

@implementation NSURL (SIATools)

+ (NSURL *)sia_URLWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path
{
    NSString *URLString = [NSString stringWithFormat:@"%@://%@", scheme, host];
    if (!path.isAbsolutePath) {
        URLString = [URLString stringByAppendingString:@"/"];
    }
    URLString = [URLString stringByAppendingString:path];
    return [NSURL URLWithString:URLString];
}

- (NSURL *)sia_URLByAppendingQueryWithDictionary:(NSDictionary *)dictionary
{
    __block NSURL *URL = self;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }
        else if ([key respondsToSelector:@selector(stringValue)]) {
            keyString = [key stringValue];
        }
        else {
            keyString = [key description];
        }
        
        NSString *valueString = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }
        else if ([obj respondsToSelector:@selector(stringValue)]) {
            valueString = [obj stringValue];
        }
        else {
            valueString = [obj description];
        }
        
        NSString *query = [NSString sia_queryStringWithValue:valueString andKey:keyString];
        URL = [URL sia_URLByAppendingQuery:query];
    }];
    return URL;
}

- (NSURL *)sia_URLByAppendingQueryValuesAndKeys:(NSString *)firstValue, ...
{
    NSURL *URL = nil;
    va_list argumentList;
    if (firstValue) {
        va_start(argumentList, firstValue);
        NSString *query = [NSString sia_queryStringWithValuesAndKeys:firstValue list:argumentList];
        va_end(argumentList);
        URL = [self sia_URLByAppendingQuery:query];
    }
    return URL;
}

- (NSURL *)sia_URLByAppendingQueryValue:(NSString *)value andKey:(NSString *)key
{
    NSString *query = [NSString sia_queryStringWithValue:value andKey:key];
    return [self sia_URLByAppendingQuery:query];
}

- (NSURL *)sia_URLByAppendingQuery:(NSString *)query
{
    if (query.length == 0) {
        return self;
    }
    
    NSString *newQuery = self.query;
    if (newQuery.length > 0) {
        if (![newQuery hasSuffix:@"&"]) {
            newQuery = [newQuery stringByAppendingString:@"&"];
        }
        newQuery = [newQuery stringByAppendingString:query];
    }
    else {
        newQuery = query;
    }
    
    NSString *URLString = self.absoluteString;
    if (self.path.length > 0) {
        NSArray *components = [URLString componentsSeparatedByString:@"?"];
        URLString = [[components objectAtIndex:0] stringByAppendingFormat:@"?%@", newQuery];
    }
    else {
        NSArray *components = [URLString componentsSeparatedByString:@"?"];
        URLString = [[components objectAtIndex:0] stringByAppendingFormat:@"/?%@", newQuery];
    }
    return [NSURL URLWithString:URLString];
}

@end

@implementation NSString (NSURLForSIATools)

+ (NSString *)sia_queryStringWithValue:(NSString *)value andKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@=%@", key, value.sia_stringByURLEncode];
}

- (NSString *)sia_stringByURLEncode
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)sia_stringByURLDecode
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}

+ (NSString *)sia_queryStringWithDictionary:(NSDictionary *)dictionary
{
    return [@"" sia_queryStringByAppendingDictionary:dictionary];
}

+ (NSString *)sia_queryStringWithValuesAndKeys:(NSString *)firstValue, ...
{
    va_list argumentList;
    NSString *query = nil;
    if (firstValue) {
        va_start(argumentList, firstValue);
        query = [self sia_queryStringWithValuesAndKeys:firstValue list:argumentList];
        va_end(argumentList);
    }
    return query;
}

+ (NSString *)sia_queryStringWithValuesAndKeys:(NSString *)firstValue list:(va_list)argumentList
{
    NSString *query = nil;
    if (firstValue) {
        query = @"";
        NSString *value = firstValue;
        NSString *key = va_arg(argumentList, NSString *);
        query = [query sia_queryStringByAppendingValue:value andKey:key];
        while ((value = va_arg(argumentList, NSString *)) != nil) {
            key = va_arg(argumentList, NSString *);
            query = [query sia_queryStringByAppendingValue:value andKey:key];
        }
    }
    return query;
}

- (NSString *)sia_queryStringByAppendingDictionary:(NSDictionary *)dictionary
{
    __block NSString *queryString = self;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }
        else if ([key respondsToSelector:@selector(stringValue)]) {
            keyString = [key stringValue];
        }
        else {
            keyString = [key description];
        }
        
        NSString *valueString = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }
        else if ([obj respondsToSelector:@selector(stringValue)]) {
            valueString = [obj stringValue];
        }
        else {
            valueString = [obj description];
        }
        
        queryString = [queryString sia_queryStringByAppendingValue:valueString andKey:keyString];
    }];
    return queryString;
}

- (NSString *)sia_queryStringByAppendingValue:(NSString *)value andKey:(NSString *)key
{
    return [self sia_queryStringByAppendingQueryString:[NSString sia_queryStringWithValue:value andKey:key]];
}

- (NSString *)sia_queryStringByAppendingQueryString:(NSString *)query
{
    NSString *newQuery = nil;
    if (self.length > 0) {
        if (query.length > 0) {
            newQuery = [NSString stringWithFormat:@"%@%@%@", self, ([self hasSuffix:@"&"] ? @"" : @"&"), query];
        }
        else {
            newQuery = query;
        }
    }
    else {
        newQuery = query;
    }
    return newQuery;
}

@end
