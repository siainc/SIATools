//
//  SIAFTPReply.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/02.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAFTPReply.h"

@implementation SIAFTPReply

+ (SIAFTPReply *)replyWithString:(NSString *)string
{
    return [[SIAFTPReply alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    NSAssert(string.length > 0, @"stringの指定は必須");
    self = [super init];
    if (self) {
        _stringValue = string;
        if (string.length >= 3) {
            _code = [[string substringToIndex:3] integerValue];
        }
        if (string.length >= 5) {
            _message = [string substringFromIndex:4];
            // TODO 改行取り除くべき？
        }
    }
    return self;
}

@end
