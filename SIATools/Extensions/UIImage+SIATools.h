//
//  UIImage+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/26.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (SIATools)

- (UIImage *)sia_imageByResizingSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (UIImage *)sia_imageByResizingAspectFitSize:(CGSize)fitSize;

@end
