//
//  SIAGeometry.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#ifndef _SIAGeometry_h
#define _SIAGeometry_h

#import <Foundation/Foundation.h>

#define TO_ANGLE(DEGREE) (DEGREE * M_PI / 180.)
#define TO_DEGREE(ANGLE) (ANGLE * 180. / M_PI)

CGRect CGRectMakePointToPoint(CGPoint point1, CGPoint point2);
CGRect CGRectIntoRect(CGRect inner, CGRect outer);
CGRect CGRectEvaluate(CGRect rect, ...);

typedef enum CGRectPositionFactor {
    CGRectPositionFactorMinX       = 0x1 << 0,
    CGRectPositionFactorMidX   = 0x1 << 1,
    CGRectPositionFactorMaxX   = 0x1 << 2,
    CGRectPositionFactorMinY   = 0x1 << 3,
    CGRectPositionFactorMidY   = 0x1 << 4,
    CGRectPositionFactorMaxY   = 0x1 << 5,
    
    CGRectPositionFactorCenter = CGRectPositionFactorMidX | CGRectPositionFactorMidY
} CGRectPositionFactor;

extern CGFloat const CGRectRateMinX;
extern CGFloat const CGRectRateMidX;
extern CGFloat const CGRectRateMaxX;
extern CGFloat const CGRectRateMinY;
extern CGFloat const CGRectRateMidY;
extern CGFloat const CGRectRateMaxY;

CGRect  CGRectTransferOrigin(CGRect frame, CGFloat xAmount, CGFloat yAmount);
CGRect  CGRectMoveX(CGRect frame, CGFloat x);
CGRect  CGRectMoveY(CGRect frame, CGFloat y);
CGRect  CGRectMoveOrigin(CGRect frame, CGFloat x, CGFloat y);
CGRect  CGRectExpandSize(CGRect frame, CGFloat widthAmount, CGFloat heightAmount, CGFloat centerRateX, CGFloat centerRateY);
CGRect  CGRectResizeWidth(CGRect frame, CGFloat width, CGFloat centerRateX, CGFloat centerRateY);
CGRect  CGRectResizeHeight(CGRect frame, CGFloat height, CGFloat centerRateX, CGFloat centerRateY);
CGRect  CGRectResizeSize(CGRect frame, CGFloat width, CGFloat height, CGFloat centerRateX, CGFloat centerRateY);

CGFloat CGRectRateFromFactor(CGRectPositionFactor factor);
CGPoint CGPointFromCGRectPositionFactor(CGRect frame, NSInteger factor);
CGPoint CGPointFromCGRectRate(CGRect frame, CGFloat rateX, CGFloat rateY);

#endif
