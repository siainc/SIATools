//
//  UIPickerView+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "UIPickerView+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIPickerView (SIABlocks)

- (void)setNumberOfComponentsUsingBlock:(NSInteger (^)())block
{
    [self implementProtocol:@protocol(UIPickerViewDataSource)
             setterSelector:@selector(setDataSource:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(numberOfComponentsInPickerView:)
                                   block:^NSInteger (SIABlockProtocol *protocol, UIPickerView *pickerView)
          {
              return block();
          }];
     }];
}

- (void)setNumberOfRowsUsingBlock:(NSInteger (^)(NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDataSource)
             setterSelector:@selector(setDataSource:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(numberOfComponentsInPickerView:)
                                   block:^NSInteger (SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger component)
          {
              return block(component);
          }];
     }];
}

- (void)setWidthUsingBlock:(CGFloat (^)(NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:widthForComponent:)
                                   block:^CGFloat (SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger component)
          {
              return block(component);
          }];
     }];
}

- (void)setRowHeightUsingBlock:(CGFloat (^)(NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:rowHeightForComponent:)
                                   block:^CGFloat (SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger component)
          {
              return block(component);
          }];
     }];
}

- (void)setTitleUsingBlock:(NSString *(^)(NSInteger row, NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:titleForRow:forComponent:)
                                   block:^NSString *(SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger row, NSInteger component)
          {
              return block(row, component);
          }];
     }];
}

- (void)setAttributedTitleUsingBlock:(NSAttributedString *(^)(NSInteger row, NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:attributedTitleForRow:forComponent:)
                                   block:^NSAttributedString *(SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger row, NSInteger component)
          {
              return block(row, component);
          }];
     }];
}

- (void)setViewUsingBlock:(UIView *(^)(NSInteger row, NSInteger component, UIView *reusingView))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)
                                   block:^UIView *(SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger row, NSInteger component, UIView *reusingView)
          {
              return block(row, component, reusingView);
          }];
     }];
}


- (void)setDidSelectUsingBlock:(void (^)(NSInteger row, NSInteger component))block
{
    [self implementProtocol:@protocol(UIPickerViewDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:didSelectRow:inComponent:)
                                   block:^void (SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger row, NSInteger component)
          {
               block(row, component);
          }];
     }];
}

@end
