//
//  UITextField+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SIABlocks)

- (void)sia_setShouldBeginEditingUsingBlock:(BOOL (^)())block;
- (void)sia_setDidBeginEditingUsingBlock:(void (^)())block;
- (void)sia_setShouldEndEditingUsingBlock:(BOOL (^)())block;
- (void)sia_setDidEndEditingUsingBlock:(void (^)())block;
- (void)sia_setShouldChangeCharactersUsingBlock:(BOOL (^)(NSRange range, NSString *replacementString))block;
- (void)sia_setShouldClearUsingBlock:(BOOL (^)())block;
- (void)sia_setShouldReturnUsingBlock:(BOOL (^)())block;

@end
