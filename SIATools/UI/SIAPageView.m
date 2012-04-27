//
//  SIAPageView.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/01/27.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAPageView.h"

@interface SIAPageView ()

@property (nonatomic) NSMutableArray *pageViews;

@end

@implementation SIAPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.pageMargin = 10;
    self.pageViews = [NSMutableArray arrayWithCapacity:10];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
}

- (void)awakeFromNib
{
    [self reloadData];
}

- (void)layoutSubviews
{
    CGRect scrollViewFrame = CGRectInset(self.bounds, -0.5 * self.pageMargin, 0);
    self.scrollView.frame = scrollViewFrame;
    
    for (int i = 0; i < self.pageViews.count; i++) {
        UIView *v = [self.pageViews objectAtIndex:i];
        v.frame = [self pageViewFrameForIndex:i];
    }
    self.scrollView.contentSize = [self calcContentSize];
}

- (CGRect)pageViewFrameForIndex:(NSInteger)index
{
    CGRect frame = self.bounds;
    CGFloat offset = (self.pageMargin * 0.5 + CGRectGetWidth(self.bounds) + self.pageMargin * 0.5) * index + self.pageMargin * 0.5;
    frame.origin.x = offset;
    return frame;
}

- (CGSize)calcContentSize
{
    CGSize size = CGSizeZero;
    size.height = CGRectGetHeight(self.scrollView.bounds);
    size.width = (self.pageMargin * 0.5 + CGRectGetWidth(self.bounds) + self.pageMargin * 0.5) * self.pageViews.count;
    return size;
}

- (void)reloadData
{
    [self constructPageViews];
}

- (void)constructPageViews
{
    [self cleanPageViews];
    _numberOfPage = [self.delegate numberOfPageForPageScrollView:self];
    for (int i = 0; i < _numberOfPage; i++) {
        UIView *v = [self.delegate pageScrollView:self viewForIndex:i];
        [self.pageViews addObject:v];
        v.frame = [self pageViewFrameForIndex:i];
        [self.scrollView addSubview:v];
    }
    self.scrollView.contentSize = [self calcContentSize];
    [self setNeedsLayout];
}

- (void)cleanPageViews
{
    for (UIView *v in self.pageViews) {
        [v removeFromSuperview];
    }
    [self.pageViews removeAllObjects];
}

- (NSInteger)currentPageIndex
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.bounds);
    NSInteger index = floor((self.scrollView.contentOffset.x + pageWidth * 0.5) / pageWidth);
    return index;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    [self setCurrentPageIndex:currentPageIndex animated:NO];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated
{
    UIView *view = [self.pageViews objectAtIndex:currentPageIndex];
    CGRect frame = CGRectInset(view.frame, -0.5 * self.pageMargin, 0);
    [self.scrollView scrollRectToVisible:frame animated:animated];
}

- (BOOL)validatePageIndex:(NSInteger)pageIndex
{
    return(0 <= pageIndex && pageIndex < self.numberOfPage);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate pageScrollView:self didChangeIndex:[self currentPageIndex]];
}

@end
