//
//  NSString+SIHalfwidth.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/12/16.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "NSString+SIHalfwidth.h"

@implementation NSString (Halfwidth)
@dynamic halfwidthLength;

- (NSInteger)halfwidthLength
{
    __block NSInteger length = 0;
#if 1
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                length += (strlen(substring.UTF8String) == 1) ? 1 : 2;
                            }];
#else // UTF-16ならこれでOK？
    length += string.length;
    length += (strlen(string.UTF8String) - string.length);
#endif
    return length;
}

- (CGFloat)locationFromHalfwidthLocation:(NSInteger)from
{
    NSInteger halrwidthLength = 0;
    CGFloat location = 0.0;
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *s = [self substringWithRange:range];
        halrwidthLength += s.halfwidthLength;
        if (from < halrwidthLength) {
            location = (CGFloat)i;
            if (s.halfwidthLength == 2) {
                if (halrwidthLength - from < 1) {
                    location += 0.5;
                }
            }
            break;
        }
    }
    return location;
}

- (NSRange)rangeFromHalfwidthRange:(NSRange)from
{
    CGFloat location = [self locationFromHalfwidthLocation:from.location];
    CGFloat length = [self locationFromHalfwidthLocation:NSMaxRange(from) - 1] + 1;
    NSRange range = NSMakeRange(floorf(location),
                                ceilf(length) - floorf(location));
    return range;
}

- (NSString *)stringByReplacingCharactersInHalfwidthRange:(NSRange)range withString:(NSString *)replacement
{
    CGFloat location = [self locationFromHalfwidthLocation:range.location];
    CGFloat length = [self locationFromHalfwidthLocation:NSMaxRange(range) - 1] + 1;
    NSString *s = replacement;
    if (location != (NSInteger)location) {
        s = [@" " stringByAppendingString:s];
    }
    if (length != (NSInteger)length) {
        s = [s stringByAppendingString:@" "];
    }
    NSString *ret = [self stringByReplacingCharactersInRange:[self rangeFromHalfwidthRange:range] withString:s];
    return ret;
}

+ (NSString *)stringWithLength:(NSInteger)length left:(NSString *)left center:(NSString *)center right:(NSString *)right
{
    NSMutableString *baseString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [baseString appendString:@" "];
    }
    NSString *string = baseString;
    if (left) {
        string = [string stringByReplacingCharactersInHalfwidthRange:NSMakeRange(0, left.halfwidthLength) withString:left];
    }
    if (center) {
        string = [string stringByReplacingCharactersInHalfwidthRange:NSMakeRange((string.halfwidthLength - center.halfwidthLength) / 2, center.halfwidthLength) withString:center];
    }
    if (right) {
        string = [string stringByReplacingCharactersInHalfwidthRange:NSMakeRange(string.halfwidthLength - right.halfwidthLength, right.halfwidthLength) withString:right];
    }
    return string;
}

@end
