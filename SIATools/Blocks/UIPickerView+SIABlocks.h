//
//  UIPickerView+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (SIABlocks)

- (void)sia_setNumberOfComponentsUsingBlock:(NSInteger (^)())block;
- (void)sia_setNumberOfRowsUsingBlock:(NSInteger (^)(NSInteger component))block;
- (void)sia_setWidthUsingBlock:(CGFloat (^)(NSInteger component))block;
- (void)sia_setRowHeightUsingBlock:(CGFloat (^)(NSInteger component))block;
- (void)sia_setTitleUsingBlock:(NSString *(^)(NSInteger row, NSInteger component))block;
- (void)sia_setAttributedTitleUsingBlock:(NSAttributedString *(^)(NSInteger row, NSInteger component))block;
- (void)sia_setViewUsingBlock:(UIView *(^)(NSInteger row, NSInteger component, UIView *reusingView))block;
- (void)sia_setDidSelectUsingBlock:(void (^)(NSInteger row, NSInteger component))block;

@end
