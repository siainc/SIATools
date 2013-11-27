//
//  UITextField+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "UITextField+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UITextField (SIABlocks)

- (void)setShouldBeginEditingUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
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

- (void)setDidBeginEditingUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldDidBeginEditing:)
                                   block:^void (SIABlockProtocol *protocol, UITextField *textField)
          {
              block();
          }];
     }];
}

- (void)setShouldEndEditingUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
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

- (void)setDidEndEditingUsingBlock:(void (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
             setterSelector:@selector(setDelegate:)
                 usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(textFieldDidEndEditing:)
                                   block:^void (SIABlockProtocol *protocol, UITextField *textField)
          {
              block();
          }];
     }];
}

- (void)shouldChangeCharactersUsingBlock:(BOOL (^)(NSRange range, NSString *replacementString))block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
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

- (void)setShouldClearUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
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

- (void)setShouldReturnUsingBlock:(BOOL (^)())block
{
    [self implementProtocol:@protocol(UITextFieldDelegate)
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
