//
//  SIAImageView.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/06/04.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAImageView.h"
#import "SIAImageCache.h"
#import "SIAConnectionOperation.h"
#import "SIAToolsLogger.h"

@interface SIAImageView ()
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) id observer;
@end

@implementation SIAImageView

- (void)dealloc
{
    SIAToolsDLog(@">>");
    [SIAImageCache.sharedCache removeObserver:self.observer];
    [_indicatorView removeFromSuperview];
    SIAToolsDLog(@">>");
}

- (void)setImageURL:(NSURL *)URL
{
    SIAToolsDLog(@">>URL=%@", URL);
    if (![URL isEqual:self.imageURL]) {
        _imageURL  = URL;
        self.image = nil;
        
        if ([URL isFileURL] || [[URL absoluteString] hasPrefix:@"/"]) {
            SIAToolsDLog(@"ローカルのファイルしていなのでそのまま読み込む");
            UIImage *image = [UIImage imageWithContentsOfFile:[URL path]];
            self.image = image;
            SIAToolsDLog(@"<<");
            return;
        }
        
        [self startIndicator];
        
        self.observer = [SIAImageCache.sharedCache cacheImageForURL:_imageURL receiver:^(NSString *path) {
            SIAToolsDLog(@">>path=%@", path);
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            self.image = image;
            [SIAImageCache.sharedCache removeObserver:self.observer];
            SIAToolsDLog(@"<<");
        }];
    }
    SIAToolsDLog(@"<<");
}

- (void)startIndicator
{
    SIAToolsDLog(@">>");
    if (!self.indicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:indicatorView];
        self.indicatorView   = indicatorView;
    }
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    SIAToolsDLog(@"<<");
}

- (void)stopIndicator
{
    SIAToolsDLog(@">>");
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    SIAToolsDLog(@"<<");
}

- (void)setImage:(UIImage *)image
{
    SIAToolsDLog(@">>image=%@", image);
    [super setImage:image];
    [self stopIndicator];
    SIAToolsDLog(@"<<");
}

@end
