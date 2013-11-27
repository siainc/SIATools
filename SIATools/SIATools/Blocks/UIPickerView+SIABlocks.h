//
//  UIPickerView+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (SIABlocks)

- (void)setNumberOfComponentsUsingBlock:(NSInteger (^)())block;
- (void)setNumberOfRowsUsingBlock:(NSInteger (^)(NSInteger component))block;
- (void)setWidthUsingBlock:(CGFloat (^)(NSInteger component))block;
- (void)setRowHeightUsingBlock:(CGFloat (^)(NSInteger component))block;
- (void)setTitleUsingBlock:(NSString *(^)(NSInteger row, NSInteger component))block;
- (void)setAttributedTitleUsingBlock:(NSAttributedString *(^)(NSInteger row, NSInteger component))block;
- (void)setViewUsingBlock:(UIView *(^)(NSInteger row, NSInteger component, UIView *reusingView))block;
- (void)setDidSelectUsingBlock:(void (^)(NSInteger row, NSInteger component))block;

@end
