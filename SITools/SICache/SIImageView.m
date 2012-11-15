//
//  SIImageView.m
//  SICache
//
//  Created by KUROSAKI Ryota on 2012/06/04.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIImageView.h"
#import "SIImageCache.h"
#import "SIConnectionOperation.h"

@interface SIImageView ()
@property(strong,nonatomic) UIActivityIndicatorView *indicatorView;
@property(weak,nonatomic) id observer;
@end

@implementation SIImageView

- (void)dealloc
{
    [SIImageCache.sharedCache removeObserver:self.observer];
    [_indicatorView removeFromSuperview];
}

- (void)setImageURL:(NSURL *)URL
{
    if (![URL isEqual:self.imageURL]) {
        _imageURL = URL;
        
        [self startIndicator];
        
        self.observer = [SIImageCache.sharedCache cacheImageForURL:_imageURL receiver:^(NSString *path) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            self.image = image;
            [SIImageCache.sharedCache removeObserver:self.observer];
        }];
    }
}

- (void)startIndicator
{
    if (!self.indicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:indicatorView];
        self.indicatorView = indicatorView;
    }
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)stopIndicator
{
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self stopIndicator];
}

@end
