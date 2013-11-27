//
//  SIAGeometry.c
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import "SIAGeometry.h"

CGFloat const CGRectRateMinX = 0.0;
CGFloat const CGRectRateMidX = 0.5;
CGFloat const CGRectRateMaxX = 1.0;
CGFloat const CGRectRateMinY = 0.0;
CGFloat const CGRectRateMidY = 0.5;
CGFloat const CGRectRateMaxY = 1.0;

/**
 * 2点を対角とする長方形を返す.
 * @param point1 頂点1.
 * @param point2 頂点2.
 * @return 長方形のrect.
 */
inline CGRect CGRectMakePointToPoint(CGPoint point1, CGPoint point2)
{
    CGRect rect = CGRectZero;
    rect.origin.x   = MIN(point1.x, point2.x);
    rect.origin.y   = MIN(point1.y, point2.y);
    rect.size.width = fabsf((point1.x > point2.x) ?
                            point1.x - point2.x :
                            point2.x - point1.x);
    rect.size.height = fabsf((point1.y > point2.y) ?
                             point1.y - point2.y :
                             point2.y - point1.y);
    return rect;
}

/**
 * innerをouterの範囲内に収まる一番近い箇所に移動する.
 * outerよりinnerの高さ/幅が大きい場合の動作は不定.
 * @param inner 内部のrect.
 * @param outer 外部(最大の範囲)のrect.
 * @return innerがouter内に収まる場合はinner. 収まらない場合はouter内の一番近いところに移動したinner.
 */
inline CGRect CGRectIntoRect(CGRect inner, CGRect outer)
{
    CGRect rect = inner;
    if (CGRectGetMinX(inner) < CGRectGetMinX(outer)) {
        rect.origin.x = CGRectGetMinX(outer);
    }
    if (CGRectGetMinY(inner) < CGRectGetMinY(outer)) {
        rect.origin.y = CGRectGetMinY(outer);
    }
    if (CGRectGetMaxX(outer) < CGRectGetMaxX(inner)) {
        rect.origin.x -= CGRectGetMaxX(inner) - CGRectGetMaxX(outer);
    }
    if (CGRectGetMaxY(outer) < CGRectGetMaxY(inner)) {
        rect.origin.y -= CGRectGetMaxY(inner) - CGRectGetMaxY(outer);
    }
    return rect;
}

inline CGRect CGRectEvaluate(CGRect rect, ...)
{
    va_list args;
    va_start(args, rect);
    
    while (YES) {
        NSString *operation = va_arg(args, id);
        if (operation == nil) {
            break;
        }
        
        NSError              *error  = nil;
        NSRegularExpression  *regex  = [NSRegularExpression regularExpressionWithPattern:@"([xywh])([+-=])(\\d+(?:\\.\\d)?)?" options:0 error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:operation options:0 range:NSMakeRange(0, operation.length)];
        if (result.numberOfRanges == 4) {
            NSString *param = [operation substringWithRange:[result rangeAtIndex:1]];
            NSString *mark  = [operation substringWithRange:[result rangeAtIndex:2]];
            CGFloat  value  = 0.0;
            if ([result rangeAtIndex:3].location == NSNotFound) {
                value = va_arg(args, double);
            }
            else {
                NSString *valueString = [operation substringWithRange:[result rangeAtIndex:3]];
                value = valueString.floatValue;
            }
            if ([mark isEqualToString:@"="]) {
                if ([param isEqualToString:@"x"]) {
                    rect.origin.x = value;
                }
                else if ([param isEqualToString:@"y"]) {
                    rect.origin.y = value;
                }
                else if ([param isEqualToString:@"w"]) {
                    rect.size.width = value;
                }
                else if ([param isEqualToString:@"h"]) {
                    rect.size.height = value;
                }
            }
            else {
                if ([param isEqualToString:@"x"]) {
                    rect.origin.x += value * ([mark isEqualToString:@"+"] ? 1 : -1);
                }
                else if ([param isEqualToString:@"y"]) {
                    rect.origin.y += value * ([mark isEqualToString:@"+"] ? 1 : -1);
                }
                else if ([param isEqualToString:@"w"]) {
                    rect.size.width += value * ([mark isEqualToString:@"+"] ? 1 : -1);
                }
                else if ([param isEqualToString:@"h"]) {
                    rect.size.height += value * ([mark isEqualToString:@"+"] ? 1 : -1);
                }
            }
        }
    }
    va_end(args);
    return rect;
}

inline CGRect CGRectTransferOrigin(CGRect frame, CGFloat xAmount, CGFloat yAmount)
{
    return CGRectMake(frame.origin.x + xAmount, frame.origin.y + yAmount, frame.size.width, frame.size.height);
}

inline CGRect CGRectMoveX(CGRect frame, CGFloat x)
{
    return CGRectMoveOrigin(frame, x, frame.origin.y);
}

inline CGRect CGRectMoveY(CGRect frame, CGFloat y)
{
    return CGRectMoveOrigin(frame, frame.origin.x, y);
}

inline CGRect CGRectMoveOrigin(CGRect frame, CGFloat x, CGFloat y)
{
    return CGRectMake(x, y, frame.size.width, frame.size.height);
}

inline CGRect CGRectExpandSize(CGRect frame, CGFloat widthAmount, CGFloat heightAmount, CGFloat centerRateX, CGFloat centerRateY)
{
    return CGRectResizeSize(frame, frame.size.width + widthAmount, frame.size.height + heightAmount, centerRateX, centerRateY);
}

inline CGRect CGRectResizeWidth(CGRect frame, CGFloat width, CGFloat centerRateX, CGFloat centerRateY)
{
    return CGRectResizeSize(frame, width, frame.size.height, centerRateX, centerRateY);
}

inline CGRect CGRectResizeHeight(CGRect frame, CGFloat height, CGFloat centerRateX, CGFloat centerRateY)
{
    return CGRectResizeSize(frame, frame.size.width, height, centerRateX, centerRateY);
}

inline CGRect CGRectResizeSize(CGRect frame, CGFloat width, CGFloat height, CGFloat centerRateX, CGFloat centerRateY)
{
    CGFloat widthAmount  = width - frame.size.width;
    CGFloat heightAmount = height - frame.size.height;
    
    CGFloat xAmount      = -1.0 * widthAmount * centerRateX;
    CGFloat yAmount      = -1.0 * heightAmount * centerRateY;
    
    return CGRectMake(frame.origin.x + xAmount, frame.origin.y + yAmount, width, height);
}

inline CGFloat CGRectRateFromFactor(CGRectPositionFactor factor)
{
    CGFloat rate = 0.0;
    switch (factor) {
        case CGRectPositionFactorMinX:
            rate = CGRectRateMinX;
            break;
        case CGRectPositionFactorMidX:
            rate = CGRectRateMidX;
            break;
        case CGRectPositionFactorMaxX:
            rate = CGRectRateMaxX;
            break;
        case CGRectPositionFactorMinY:
            rate = CGRectRateMinY;
            break;
        case CGRectPositionFactorMidY:
            rate = CGRectRateMidY;
            break;
        case CGRectPositionFactorMaxY:
            rate = CGRectRateMaxY;
            break;
        default:
            break;
    }
    return rate;
}

inline CGPoint CGPointFromCGRectPositionFactor(CGRect frame, NSInteger factor)
{
    return CGPointFromCGRectRate(frame,
                                 CGRectRateFromFactor((CGRectPositionFactorMinX | CGRectPositionFactorMidX | CGRectPositionFactorMaxX) & factor),
                                 CGRectRateFromFactor((CGRectPositionFactorMinY | CGRectPositionFactorMidY | CGRectPositionFactorMaxY) & factor));
}

inline CGPoint CGPointFromCGRectRate(CGRect frame, CGFloat rateX, CGFloat rateY)
{
    return CGPointMake(frame.origin.x + frame.size.width * rateX, frame.origin.y + frame.size.height * rateY);
}

