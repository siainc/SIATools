//
//  NSEnumerator+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEnumerator (SIATools)

- (void)sia_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (BOOL)sia_isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)sia_isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)sia_mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)sia_arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)sia_arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)sia_maxObjectUsingComparator:(NSComparator)cmptr;
- (id)sia_minObjectUsingComparator:(NSComparator)cmptr;
- (id)sia_inject:(id (^)(id result, id obj))injection;
- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue;

@end

@interface NSEnumerator (SIAToolsRubyLike)

- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (BOOL)all:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)any:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)map:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)findAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)reject:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)max:(NSComparator)cmptr;
- (id)min:(NSComparator)cmptr;

@end

@interface SIAEnumerator : NSEnumerator

+ (SIAEnumerator *)enumeratorWithTraceBlock:(id (^)(NSInteger index, id previousObject))traceBlock;

@end
