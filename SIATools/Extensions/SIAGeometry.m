//
//  SIAGeometry.c
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import "SIAGeometry.h"

/**
 * 2点を対角とする長方形を返す.
 * @param point1 頂点1.
 * @param point2 頂点2.
 * @return 長方形のrect.
 */
inline CGRect SIACGRectMakePointToPoint(CGPoint point1, CGPoint point2)
{
    CGRect rect = CGRectZero;
    rect.origin.x = MIN(point1.x, point2.x);
    rect.origin.y = MIN(point1.y, point2.y);
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
inline CGRect SIACGRectIntoRect(CGRect inner, CGRect outer)
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

inline CGRect SIACGRectMoveOriginX(CGRect rect, CGFloat x)
{
    return SIACGRectMoveOrigin(rect, x, rect.origin.y);
}

inline CGRect SIACGRectMoveOriginY(CGRect rect, CGFloat y)
{
    return SIACGRectMoveOrigin(rect, rect.origin.x, y);
}

inline CGRect SIACGRectMoveOrigin(CGRect rect, CGFloat x, CGFloat y)
{
    return SIACGRectMove(rect, x, y, 0., 0.);
}

inline CGRect SIACGRectMoveX(CGRect rect, CGFloat x, CGFloat relativeX)
{
    return SIACGRectMove(rect, x, SIACGRectGetPointY(rect, 0.), relativeX, 0.);
}

inline CGRect SIACGRectMoveY(CGRect rect, CGFloat y, CGFloat relativeY)
{
    return SIACGRectMove(rect, SIACGRectGetPointX(rect, 0.), y, 0., relativeY);
}

inline CGRect SIACGRectMove(CGRect rect, CGFloat x, CGFloat y, CGFloat relativeX, CGFloat relativeY)
{
    CGPoint relativePoint = SIACGRectGetPoint(rect, relativeX, relativeY);
    CGRect moveRect = rect;
    moveRect.origin.x += x - relativePoint.x;
    moveRect.origin.y += y - relativePoint.y;
    return moveRect;
}

inline CGRect SIACGRectExpandWidth(CGRect rect, CGFloat widthAmount, CGFloat relativeX)
{
    return SIACGRectExpand(rect, widthAmount, 0, relativeX, 0);
}

inline CGRect SIACGRectExpandHeight(CGRect rect, CGFloat heightAmount, CGFloat relativeY)
{
    return SIACGRectExpand(rect, 0, heightAmount, 0, relativeY);
}

inline CGRect SIACGRectExpand(CGRect rect, CGFloat widthAmount, CGFloat heightAmount, CGFloat relativeX, CGFloat relativeY)
{
    return SIACGRectResize(rect, rect.size.width + widthAmount, rect.size.height + heightAmount, relativeX, relativeY);
}

inline CGRect SIACGRectResizeWidth(CGRect rect, CGFloat width, CGFloat relativeX)
{
    return SIACGRectResize(rect, width, rect.size.height, relativeX, 0);
}

inline CGRect SIACGRectResizeHeight(CGRect rect, CGFloat height, CGFloat relativeY)
{
    return SIACGRectResize(rect, rect.size.width, height, 0, relativeY);
}

inline CGRect SIACGRectResize(CGRect rect, CGFloat width, CGFloat height, CGFloat relativeX, CGFloat relativeY)
{
    CGFloat widthAmount = width - rect.size.width;
    CGFloat heightAmount = height - rect.size.height;
    
    CGFloat xAmount = -1.0 * widthAmount * relativeX;
    CGFloat yAmount = -1.0 * heightAmount * relativeY;
    
    return CGRectMake(rect.origin.x + xAmount, rect.origin.y + yAmount, width, height);
}

inline CGFloat SIACGRectGetPointX(CGRect rect, CGFloat relativeX)
{
    return rect.origin.x + rect.size.width * relativeX;
}

inline CGFloat SIACGRectGetPointY(CGRect rect, CGFloat relativeY)
{
    return rect.origin.y + rect.size.height * relativeY;
}

inline CGPoint SIACGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY)
{
    return CGPointMake(SIACGRectGetPointX(rect, relativeX),
                       SIACGRectGetPointY(rect, relativeY));
}

CGRect SIACGRectContentMode(CGRect rect, CGRect parentRect, UIViewContentMode contentMode)
{
    CGRect result = rect;
    
    if (contentMode == UIViewContentModeScaleToFill) {
        result = parentRect;
    }
    else if (contentMode == UIViewContentModeScaleAspectFit) {
        if ((parentRect.size.width / parentRect.size.height) > (rect.size.width / rect.size.height)) {
            // rectの高さをparentRectの高さに揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.height * rect.size.width / rect.size.height,
                                     parentRect.size.height);
        }
        else {
            // rectの幅をparentRectの幅に揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.width,
                                     parentRect.size.width * rect.size.height / rect.size.width);
        }
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.5),
                               SIACGRectGetPointY(parentRect, 0.5),
                               0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeScaleAspectFill) {
        if ((parentRect.size.width / parentRect.size.height) > (rect.size.width / rect.size.height)) {
            // rectの幅をparentRectの幅に揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.width,
                                     parentRect.size.width * rect.size.height / rect.size.width);
        }
        else {
            // rectの高さをparentRectの高さに揃えるようにリサイズする
            result.size = CGSizeMake(parentRect.size.height * rect.size.width / rect.size.height,
                                     parentRect.size.height);
        }
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.5),
                               SIACGRectGetPointY(parentRect, 0.5),
                               0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeRedraw) {
        // nothing to do
    }
    else if (contentMode == UIViewContentModeCenter) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.5),
                               SIACGRectGetPointY(parentRect, 0.5),
                               0.5, 0.5);
    }
    else if (contentMode == UIViewContentModeTop) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.5),
                               SIACGRectGetPointY(parentRect, 0.0),
                               0.5, 0.0);
    }
    else if (contentMode == UIViewContentModeBottom) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.5),
                               SIACGRectGetPointY(parentRect, 1.0),
                               0.5, 1.0);
    }
    else if (contentMode == UIViewContentModeLeft) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.0),
                               SIACGRectGetPointY(parentRect, 0.5),
                               0.0, 0.5);
    }
    else if (contentMode == UIViewContentModeRight) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 1.0),
                               SIACGRectGetPointY(parentRect, 0.5),
                               1.0, 0.5);
    }
    else if (contentMode == UIViewContentModeTopLeft) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.0),
                               SIACGRectGetPointY(parentRect, 0.0),
                               0.0, 0.0);
    }
    else if (contentMode == UIViewContentModeTopRight) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 1.0),
                               SIACGRectGetPointY(parentRect, 0.5),
                               1.0, 0.5);
    }
    else if (contentMode == UIViewContentModeBottomLeft) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 0.0),
                               SIACGRectGetPointY(parentRect, 1.0),
                               0.0, 1.0);
    }
    else if (contentMode == UIViewContentModeBottomRight) {
        result = SIACGRectMove(result,
                               SIACGRectGetPointX(parentRect, 1.0),
                               SIACGRectGetPointY(parentRect, 1.0),
                               1.0, 1.0);
    }
    
    return result;
}
