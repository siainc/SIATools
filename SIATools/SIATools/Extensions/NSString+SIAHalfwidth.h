//
//  NSString+SIAHalfwidth.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/12/16.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Halfwidth)

@property (nonatomic, readonly) NSInteger halfwidthLength;

- (CGFloat)locationFromHalfwidthLocation:(NSInteger)from;
- (NSRange)rangeFromHalfwidthRange:(NSRange)from;
- (NSString *)stringByReplacingCharactersInHalfwidthRange:(NSRange)range withString:(NSString *)replacement;
+ (NSString *)stringWithLength:(NSInteger)length left:(NSString *)left center:(NSString *)center right:(NSString *)right;

@end
