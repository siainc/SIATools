//
//  UITextField+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "UITextField+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UITextField (SIABlocks)

- (void)sia_setShouldBeginEditingUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldShouldBeginEditing:)
                                   block:^BOOL (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

- (void)sia_setDidBeginEditingUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldDidBeginEditing:)
                                   block:^void (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

- (void)sia_setShouldEndEditingUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldShouldEndEditing:)
                                   block:^BOOL (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

- (void)sia_setDidEndEditingUsingBlock:(void (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldDidEndEditing:)
                                   block:^void (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

- (void)sia_setShouldChangeCharactersUsingBlock:(BOOL (^)(NSRange range, NSString *replacementString))block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)
                                   block:^BOOL (SIABlockProtocol *protocol, UITextField *textField, NSRange range, NSString *replacementString)
          {
              return block(range, replacementString);
          }];
     }];
}

- (void)sia_setShouldClearUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldShouldClear:)
                                   block:^BOOL (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

- (void)sia_setShouldReturnUsingBlock:(BOOL (^)())block
{
    [self sia_implementProtocol:@protocol(UITextFieldDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldShouldReturn:)
                                   block:^BOOL (SIABlockProtocol *protocol, UITextField *textField)
          {
              return block();
          }];
     }];
}

@end
