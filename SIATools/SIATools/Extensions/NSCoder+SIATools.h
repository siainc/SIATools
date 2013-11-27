//
//  NSCoder+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/11.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCoder (SIATools)

- (void)encodeInstanceVariable:(id)object;
- (void)encodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder;
- (void)decodeInstanceVariable:(id)object;
- (void)decodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder;

@end
