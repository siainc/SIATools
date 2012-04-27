//
//  NSString+SIHalfwidth.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/12/16.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import "NSString+SIAHalfwidth.h"

@implementation NSString (Halfwidth)
@dynamic sia_halfwidthLength;

- (NSInteger)sia_halfwidthLength
{
    __block NSInteger length = 0;
#if 1
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop) {
                              length += (strlen(substring.UTF8String) == 1) ? 1 : 2;
                          }];
#else // UTF-16ならこれでOK？
    length += string.length;
    length += (strlen(string.UTF8String) - string.length);
#endif
    return length;
}

- (CGFloat)sia_locationFromHalfwidthLocation:(NSInteger)from
{
    NSInteger halrwidthLength = 0;
    CGFloat location = 0.0;
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *s = [self substringWithRange:range];
        halrwidthLength += s.sia_halfwidthLength;
        if (from < halrwidthLength) {
            location = (CGFloat)i;
            if (s.sia_halfwidthLength == 2) {
                if (halrwidthLength - from < 1) {
                    location += 0.5;
                }
            }
            break;
        }
    }
    return location;
}

- (NSRange)sia_rangeFromHalfwidthRange:(NSRange)from
{
    CGFloat location = [self sia_locationFromHalfwidthLocation:from.location];
    CGFloat length = [self sia_locationFromHalfwidthLocation:NSMaxRange(from) - 1] + 1;
    NSRange range = NSMakeRange(floorf(location),
                                ceilf(length) - floorf(location));
    return range;
}

- (NSString *)sia_stringByReplacingCharactersInHalfwidthRange:(NSRange)range withString:(NSString *)replacement
{
    CGFloat location = [self sia_locationFromHalfwidthLocation:range.location];
    CGFloat length = [self sia_locationFromHalfwidthLocation:NSMaxRange(range) - 1] + 1;
    NSString *s = replacement;
    if (location != (NSInteger)location) {
        s = [@" " stringByAppendingString:s];
    }
    if (length != (NSInteger)length) {
        s = [s stringByAppendingString:@" "];
    }
    NSString *ret = [self stringByReplacingCharactersInRange:[self sia_rangeFromHalfwidthRange:range] withString:s];
    return ret;
}

+ (NSString *)sia_stringWithLength:(NSInteger)length left:(NSString *)left center:(NSString *)center right:(NSString *)right
{
    NSMutableString *baseString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [baseString appendString:@" "];
    }
    NSString *string = baseString;
    if (left) {
        string = [string sia_stringByReplacingCharactersInHalfwidthRange:NSMakeRange(0, left.sia_halfwidthLength) withString:left];
    }
    if (center) {
        string = [string sia_stringByReplacingCharactersInHalfwidthRange:NSMakeRange((string.sia_halfwidthLength - center.sia_halfwidthLength) / 2,
                                                                                     center.sia_halfwidthLength)
                                                              withString:center];
    }
    if (right) {
        string = [string sia_stringByReplacingCharactersInHalfwidthRange:NSMakeRange(string.sia_halfwidthLength - right.sia_halfwidthLength,
                                                                                     right.sia_halfwidthLength) withString:right];
    }
    return string;
}

@end
