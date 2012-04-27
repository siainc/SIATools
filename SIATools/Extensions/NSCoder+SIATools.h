//
//  NSCoder+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/11.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCoder (SIATools)

- (void)sia_encodeInstanceVariable:(id)object;
- (void)sia_encodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder;
- (void)sia_decodeInstanceVariable:(id)object;
- (void)sia_decodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder;

@end
