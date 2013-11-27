//
//  UIImage+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/26.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (SIATools)

- (UIImage *)imageByResizingSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (UIImage *)imageByResizingAspectFitSize:(CGSize)fitSize;

@end
