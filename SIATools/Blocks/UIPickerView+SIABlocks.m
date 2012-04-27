//
//  UIPickerView+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UIPickerView+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UIPickerView (SIABlocks)

- (void)sia_setNumberOfComponentsUsingBlock:(NSInteger (^)())block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDataSource)
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

- (void)sia_setNumberOfRowsUsingBlock:(NSInteger (^)(NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDataSource)
                 setterSelector:@selector(setDataSource:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(pickerView:numberOfRowsInComponent:)
                                   block:^NSInteger (SIABlockProtocol *protocol, UIPickerView *pickerView, NSInteger component)
          {
              return block(component);
          }];
     }];
}

- (void)sia_setWidthUsingBlock:(CGFloat (^)(NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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

- (void)sia_setRowHeightUsingBlock:(CGFloat (^)(NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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

- (void)sia_setTitleUsingBlock:(NSString *(^)(NSInteger row, NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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

- (void)sia_setAttributedTitleUsingBlock:(NSAttributedString *(^)(NSInteger row, NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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

- (void)sia_setViewUsingBlock:(UIView *(^)(NSInteger row, NSInteger component, UIView *reusingView))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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


- (void)sia_setDidSelectUsingBlock:(void (^)(NSInteger row, NSInteger component))block
{
    [self sia_implementProtocol:@protocol(UIPickerViewDelegate)
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
