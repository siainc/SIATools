//
//  SIGeometry.c
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "SIGeometry.h"

/**
 * 2点を対角とする長方形を返す.
 * @param point1 頂点1.
 * @param point2 頂点2.
 * @return 長方形のrect.
 */
CGRect CGRectMakePointToPoint(CGPoint point1, CGPoint point2)
{
    CGRect rect = CGRectZero;
    rect.origin.x = MIN(point1.x, point2.x);
    rect.origin.y = MIN(point1.y, point2.y);
    rect.size.width = fabsf((point1.x > point2.x)
                            ? point1.x - point2.x
                            : point2.x - point1.x);
    rect.size.height = fabsf((point1.y > point2.y)
                             ? point1.y - point2.y
                             : point2.y - point1.y);
    return rect;
}

/**
 * innerをouterの範囲内に収まる一番近い箇所に移動する.
 * outerよりinnerの高さ/幅が大きい場合の動作は不定.
 * @param inner 内部のrect.
 * @param outer 外部(最大の範囲)のrect.
 * @return innerがouter内に収まる場合はinner. 収まらない場合はouter内の一番近いところに移動したinner.
 */
CGRect CGRectIntoRect(CGRect inner, CGRect outer)
{
    CGRect rect = inner;
    if (CGRectGetMinX(inner) < 0) {
        rect.origin.x = 0;
    }
    if (CGRectGetMinY(inner) < 0) {
        rect.origin.y = 0;
    }
    if (CGRectGetMaxX(outer) < CGRectGetMaxX(inner)) {
        rect.origin.x -= CGRectGetMaxX(inner) - CGRectGetMaxX(outer);
    }
    if (CGRectGetMaxY(outer) < CGRectGetMaxY(inner)) {
        rect.origin.y -= CGRectGetMaxY(inner) - CGRectGetMaxY(outer);
    }
    return rect;
}

CGRect CGRectEvaluate(CGRect rect, ...)
{
    va_list args;
    va_start(args, rect);
     
    while (YES) {
        NSString *operation = va_arg(args, id);
        if (operation == nil) {
            break;
        }
         
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([xywh])([+-=])(\\d+(?:\\.\\d)?)?" options:0 error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:operation options:0 range:NSMakeRange(0, operation.length)];
        if (result.numberOfRanges == 4) {
            NSString *param = [operation substringWithRange:[result rangeAtIndex:1]];
            NSString *mark = [operation substringWithRange:[result rangeAtIndex:2]];
            CGFloat value = 0.0;
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