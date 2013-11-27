//
//  UIImage+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/26.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "UIImage+SIATools.h"

#import <QuartzCore/QuartzCore.h>
#import "SIAToolsLogger.h"

@implementation UIImage (SIATools)

- (UIImage *)imageByResizingSize:(CGSize)size contentMode:(UIViewContentMode)contentMode
{
    SIAToolsDLog(@">>size=%@, contentMode=%d", NSStringFromCGSize(size), contentMode);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    imageView.contentMode = contentMode;
    imageView.image       = self;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    SIAToolsDLog(@"<<%@", image);
    return image;
}

- (UIImage *)imageByResizingAspectFitSize:(CGSize)fitSize
{
    SIAToolsDLog(@">>fitSize=%@", NSStringFromCGSize(fitSize));
    UIImage *thumbnailImage = nil;
    CGSize  standardSize    = fitSize;
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
    SIAToolsDLog(@"<<%@", thumbnailImage);
    return thumbnailImage;
}

@end
