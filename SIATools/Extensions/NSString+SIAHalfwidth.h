//
//  NSString+SIAHalfwidth.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/12/16.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Halfwidth)

@property (nonatomic, readonly) NSInteger sia_halfwidthLength;

- (CGFloat)sia_locationFromHalfwidthLocation:(NSInteger)from;
- (NSRange)sia_rangeFromHalfwidthRange:(NSRange)from;
- (NSString *)sia_stringByReplacingCharactersInHalfwidthRange:(NSRange)range withString:(NSString *)replacement;
+ (NSString *)sia_stringWithLength:(NSInteger)length left:(NSString *)left center:(NSString *)center right:(NSString *)right;

@end
