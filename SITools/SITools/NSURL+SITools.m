//
//  NSURL+SITools.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/05/08.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "NSURL+SITools.h"

@implementation NSURL (SITools)

+ (NSURL *)URLWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path
{
    NSString *URLString = [NSString stringWithFormat:@"%@://%@", scheme, host];
    if (!path.isAbsolutePath) {
        URLString = [URLString stringByAppendingString:@"/"];
    }
    URLString = [URLString stringByAppendingString:path];
    return [NSURL URLWithString:URLString];
}

- (NSURL *)URLByAppendingQueryValuesAndKeys:(NSString *)firstValue, ...
{
    NSURL *URL = nil;
    va_list argumentList;
    if (firstValue) {
        va_start(argumentList, firstValue);
        NSString *query = [NSString queryStringWithValuesAndKeys:firstValue list:argumentList];
        va_end(argumentList);
        URL = [self URLByAppendingQuery:query];
    }
    return URL;
}

- (NSURL *)URLByAppendingQueryValue:(NSString *)value andKey:(NSString *)key
{
    NSString *query = [NSString queryStringWithValue:value andKey:key];
    return [self URLByAppendingQuery:query];
}

- (NSURL *)URLByAppendingQuery:(NSString *)query
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
    
    NSString *newPath = self.path;
    if (newPath.length > 0) {
        newPath = [newPath stringByAppendingString:@"?"];
        newPath = [newPath stringByAppendingString:newQuery];
    }
    else {
        newPath = [@"/?" stringByAppendingString:newQuery];
    }
    
    NSString *URLString = self.absoluteString;
    NSArray *components = [URLString componentsSeparatedByString:@"?"];
    URLString = [[components objectAtIndex:0] stringByAppendingFormat:@"?%@", newQuery];
    return [NSURL URLWithString:URLString];
//    return [[NSURL alloc] initWithScheme:self.scheme host:self.host path:newPath];
}

@end

@implementation NSString (NSURLForSITools)

+ (NSString *)queryStringWithValue:(NSString *)value andKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@=%@", key, value.stringByURLEncode];
}

- (NSString *)stringByURLEncode
{  
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)stringByURLDecode
{  
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}  

+ (NSString *)queryStringWithValuesAndKeys:(NSString *)firstValue, ...
{
    va_list argumentList;
    NSString *query = nil;
    if (firstValue) {
        va_start(argumentList, firstValue);
        query = [self queryStringWithValuesAndKeys:firstValue list:argumentList];
        va_end(argumentList);
    }
    return query;
}

+ (NSString *)queryStringWithValuesAndKeys:(NSString *)firstValue list:(va_list)argumentList
{
    NSString *query = nil;
    if (firstValue) {
        query = @"";
        NSString *value = firstValue;
        NSString *key = va_arg(argumentList, NSString *);
        query = [query queryStringByAppendingValue:value andKey:key];
        while ((value = va_arg(argumentList, NSString *)) != nil) {
            key = va_arg(argumentList, NSString *);
            query = [query queryStringByAppendingValue:value andKey:key];
        }
    }
    return query;
}

- (NSString *)queryStringByAppendingValue:(NSString *)value andKey:(NSString *)key
{
    return [self queryStringByAppendingQueryString:[NSString queryStringWithValue:value andKey:key]];
}

- (NSString *)queryStringByAppendingQueryString:(NSString *)query
{
    NSString *newQuery = nil;
    if (self.length > 0) {
        if (query.length > 0) {
            newQuery = [NSString stringWithFormat:@"%@%@%@", self, ([self hasSuffix:@"&"]?@"":@"&"), query];
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
