//
//  UIImage+SITools.m
//
//  Created by KUROSAKI Ryota on 11/10/26.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "UIImage+SITools.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (SITools)

- (UIImage *)imageByResizingSize:(CGSize)size contentMode:(UIViewContentMode)contentMode
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    imageView.contentMode = contentMode;
    imageView.image = self;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByResizingAspectFitSize:(CGSize)fitSize
{
    UIImage *thumbnailImage = nil;
    CGSize standardSize = fitSize;
    if ((standardSize.width / standardSize.height) > (self.size.width / self.size.height)) {
        // 長辺：高さ
        if (standardSize.height < self.size.height) {
            CGSize thumbnailSize = CGSizeMake(standardSize.height * self.size.width / self.size.height, standardSize.height);
            UIGraphicsBeginImageContext(thumbnailSize);
            [self drawInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
            thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else {
            thumbnailImage = self;
        }
    }
    else {
        if (standardSize.width < self.size.width) {
            CGSize thumbnailSize = CGSizeMake(standardSize.width, standardSize.width * self.size.height / self.size.width);
            UIGraphicsBeginImageContext(thumbnailSize);
            [self drawInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
            thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else {
            thumbnailImage = self;
        }
    }
    return thumbnailImage;
}

@end
