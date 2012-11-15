//
//  SIImageButton.m
//  SICache
//
//  Created by KUROSAKI Ryota on 2010/09/24.
//  Copyright (c) 2010 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIImageButton.h"
#import "SIImageCache.h"
#import "SIConnectionOperation.h"

@interface SIImageButton ()
@property(nonatomic,weak) id observer;
@end

@implementation SIImageButton

- (void)dealloc
{
    [SIImageCache.sharedCache removeObserver:self.observer];
    [_indicatorView removeFromSuperview];
}

- (void)setDownloadedImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self stopIndicator];
}

#pragma mark - property method

- (void)setImageURL:(NSURL *)URL
{
    if (![URL isEqual:_imageURL]) {
        _imageURL = URL;
		
		if ([URL isFileURL] || [[URL absoluteString] hasPrefix:@"/"] ) {
			UIImage *image = [UIImage imageWithContentsOfFile:[URL path]];
            [self setBackgroundImage:image forState:UIControlStateNormal];
			return;
		}
        
        [self startIndicator];

        self.observer = [SIImageCache.sharedCache cacheImageForURL:_imageURL receiver:^(NSString *path) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self setDownloadedImage:image];
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

@end
