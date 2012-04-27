//
//  NSArray+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SIATools)

@property (nonatomic, readonly) id sia_firstObject;
- (NSArray *)sia_firstObjectsWithNumber:(NSUInteger)number;
- (NSArray *)sia_lastObjectsWithNumber:(NSUInteger)number;
@property (nonatomic, readonly) NSInteger sia_firstIndex;
@property (nonatomic, readonly) NSInteger sia_lastIndex;
- (NSInteger)sia_indexFromMinusIndex:(NSInteger)minusIndex;
- (NSInteger)sia_minusIndexFromIndex:(NSInteger)index;
- (BOOL)sia_validateIndex:(NSInteger)index;
- (id)sia_objectAtIndex:(NSUInteger)index;
- (id)sia_objectAtIndex:(NSUInteger)index ifNil:(id)ifNil;
- (id)sia_objectAtIndex:(NSUInteger)index ifNilBlock:(id (^)())ifNilBlock;
- (NSArray *)sia_flattenArray;
- (NSArray *)sia_reverseArray;
- (id)sia_sampleObject;
- (NSArray *)sia_sampleObjectsWithNumber:(NSInteger)number;
- (NSArray *)sia_shuffleArray;

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

@interface NSArray (SIAToolsRubyLike)

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

@interface NSMutableArray (SIATools)

- (id)sia_popObject;
- (NSArray *)sia_popObjectsWithNumber:(NSUInteger)number;
- (void)sia_pushObject:(id)object;
- (void)sia_pushObjects:(NSArray *)array;

- (id)sia_shiftObject;
- (NSArray *)sia_shiftObjectsWithNumber:(NSUInteger)number;
- (void)sia_unshiftObject:(id)object;
- (void)sia_unshiftObjects:(NSArray *)array;

- (void)sia_removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)sia_removeObjectsRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

+ (instancetype)sia_arrayWithObject:(id)anObject count:(NSUInteger)count;
+ (instancetype)sia_arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize;

@end

@interface NSMutableArray (SIAToolsRubyLike)

- (id)pop;
- (NSArray *)pop:(NSUInteger)number;
- (void)push:(id)object;
- (void)pushs:(NSArray *)array;

- (id)shift;
- (NSArray *)shift:(NSUInteger)number;
- (void)unshift:(id)object;
- (void)unshifts:(NSArray *)array;

- (void)removeIf:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

@end
