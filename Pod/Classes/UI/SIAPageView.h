//
//  SIAPageView.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/01/27.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIAPageViewDelegate;

@interface SIAPageView : UIView <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat pageMargin;
@property (nonatomic, weak) IBOutlet id <SIAPageViewDelegate> delegate;
- (void)reloadData;
@property (nonatomic, readonly) NSInteger numberOfPage;
@property (nonatomic, assign) NSInteger currentPageIndex;
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated;
- (BOOL)validatePageIndex:(NSInteger)pageIndex;

@end

@protocol SIAPageViewDelegate <NSObject>

@required
- (NSInteger)numberOfPageForPageScrollView:(SIAPageView *)pageView;
- (UIView *)pageScrollView:(SIAPageView *)pageView viewForIndex:(NSInteger)index;

@optional
- (void)pageScrollView:(SIAPageView *)pageView didChangeIndex:(NSInteger)index;

@end