//
//  SIGeometry.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#ifndef _SIGeometry_h
#define _SIGeometry_h

#import <Foundation/Foundation.h>

#define TO_ANGLE(DEGREE) (DEGREE * M_PI / 180.)
#define TO_DEGREE(ANGLE) (ANGLE * 180. / M_PI)

CGRect CGRectMakePointToPoint(CGPoint point1, CGPoint point2);
CGRect CGRectIntoRect(CGRect inner, CGRect outer);
CGRect CGRectEvaluate(CGRect rect, ...);

#endif
