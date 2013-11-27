//
//  SIAFTPCommand.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/02.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAFTPCommand.h"

@implementation SIAFTPCommand

+ (SIAFTPCommand *)commandWithString:(NSString *)string
{
    return [[SIAFTPCommand alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    NSAssert(string.length > 0, @"コマンドの指定必須");
    self = [super init];
    if (self) {
        _stringValue = string;
    }
    return self;
}

- (NSData *)data
{
    NSData *data = [[self.stringValue stringByAppendingString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding];
    return data;
}

@end
