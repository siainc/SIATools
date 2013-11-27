//
//  SIABlockAction.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/08.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIAExpandableObject.h"

@interface SIABlockAction :   SIAExpandableObject

@property (nonatomic, assign) SEL selector;
+ (SIABlockAction *)createSubclassInstanceForSelector:(SEL)selector;
- (void)addMethodWithTypes:(const char *)types block:(id)block;

@end

@interface NSObject (NSObjectSIABlockActionExtensions)

- (SIABlockAction *)actionForSelector:(SEL)selector types:(const char *)types usingBlock:(id)block;
- (void)disposeAction:(SIABlockAction *)action;

@end
