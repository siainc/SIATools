//
//  NSData+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/25.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "NSData+SIATools.h"

@implementation NSData (SIATools)

- (NSString *)sia_lightDescription
{
    return [NSString stringWithFormat:@"<NSData: %p length:%@>", self, @(self.length)];
}

@end
