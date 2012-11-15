//
//  UIImage+SITools.h
//
//  Created by KUROSAKI Ryota on 11/10/26.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (SITools)

- (UIImage *)imageByResizingSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (UIImage *)imageByResizingAspectFitSize:(CGSize)fitSize;

@end
