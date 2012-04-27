//
//  SIAGeometry.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#ifndef _SIAGeometry_h
#define _SIAGeometry_h

#import <Foundation/Foundation.h>

#define TO_ANGLE(DEGREE) (DEGREE * M_PI / 180.)
#define TO_DEGREE(ANGLE) (ANGLE * 180. / M_PI)

CGRect SIACGRectMakePointToPoint(CGPoint point1, CGPoint point2);
CGRect SIACGRectIntoRect(CGRect inner, CGRect outer);

CGRect SIACGRectMoveOriginX(CGRect rect, CGFloat x);
CGRect SIACGRectMoveOriginY(CGRect rect, CGFloat y);
CGRect SIACGRectMoveOrigin(CGRect rect, CGFloat x, CGFloat y);
CGRect SIACGRectMoveX(CGRect rect, CGFloat x, CGFloat relativeX);
CGRect SIACGRectMoveY(CGRect rect, CGFloat y, CGFloat relativeY);
CGRect SIACGRectMove(CGRect rect, CGFloat x, CGFloat y, CGFloat relativeX, CGFloat relativeY);

CGRect SIACGRectExpandWidth(CGRect rect, CGFloat widthAmount, CGFloat relativeX);
CGRect SIACGRectExpandHeight(CGRect rect, CGFloat heightAmount, CGFloat relativeY);
CGRect SIACGRectExpand(CGRect rect, CGFloat widthAmount, CGFloat heightAmount, CGFloat relativeX, CGFloat relativeY);
CGRect SIACGRectResizeWidth(CGRect rect, CGFloat width, CGFloat relativeX);
CGRect SIACGRectResizeHeight(CGRect rect, CGFloat height, CGFloat relativeY);
CGRect SIACGRectResize(CGRect rect, CGFloat width, CGFloat height, CGFloat relativeX, CGFloat relativeY);

CGFloat SIACGRectGetPointX(CGRect rect, CGFloat relativeX);
CGFloat SIACGRectGetPointY(CGRect rect, CGFloat relativeY);
CGPoint SIACGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY);

CGRect SIACGRectContentMode(CGRect rect, CGRect parentRect, UIViewContentMode contentMode);

#endif
