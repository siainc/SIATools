//
//  UITextField+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/11/26.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SIABlocks)

- (void)setShouldBeginEditingUsingBlock:(BOOL (^)())block;
- (void)setDidBeginEditingUsingBlock:(BOOL (^)())block;
- (void)setShouldEndEditingUsingBlock:(BOOL (^)())block;
- (void)setDidEndEditingUsingBlock:(void (^)())block;
- (void)shouldChangeCharactersUsingBlock:(BOOL (^)(NSRange range, NSString *replacementString))block;
- (void)setShouldClearUsingBlock:(BOOL (^)())block;
- (void)setShouldReturnUsingBlock:(BOOL (^)())block;

@end
