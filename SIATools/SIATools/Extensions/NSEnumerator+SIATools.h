//
//  NSEnumerator+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEnumerator (SIATools)

- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)maxObjectUsingComparator:(NSComparator)cmptr;
- (id)minObjectUsingComparator:(NSComparator)cmptr;
- (id)inject:(id (^)(id result, id obj))injection;
- (id)inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue;

@end
