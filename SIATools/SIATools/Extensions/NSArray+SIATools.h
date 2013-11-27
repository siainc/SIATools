//
//  NSArray+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SIATools)

@property (nonatomic, readonly) id firstObject;
- (NSArray *)firstObjectsWithNumber:(NSUInteger)number;
- (NSArray *)lastObjectsWithNumber:(NSUInteger)number;
@property (nonatomic, readonly) NSInteger firstIndex;
@property (nonatomic, readonly) NSInteger lastIndex;
- (BOOL)validateIndex:(NSInteger)index;
- (id)objectAtIndex:(NSUInteger)index ifNil:(id)ifNil;
- (id)objectAtIndex:(NSUInteger)index ifNilBlock:(id (^)())ifNilBlock;
- (NSArray *)flattenArray;
- (NSArray *)reverseArray;
- (id)sampleObject;
- (NSArray *)sampleObjectsWithNumber:(NSInteger)number;
- (NSArray *)shuffleArray;

- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
                    ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)maxObjectUsingComparator:(NSComparator)cmptr;
- (id)minObjectUsingComparator:(NSComparator)cmptr;
- (id)inject:(id (^)(id result, id obj))injection;
- (id)inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue;

@end

@interface NSMutableArray (SIATools)

- (id)popObject;
- (NSArray *)popObjectsWithNumber:(NSUInteger)number;
- (void)pushObject:(id)object;
- (void)pushObjects:(NSArray *)array;

- (id)shiftObject;
- (NSArray *)shiftObjectsWithNumber:(NSUInteger)number;
- (void)unshiftObject:(id)object;
- (void)unshiftObjects:(NSArray *)array;

- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)removeObjectsRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

+ (instancetype)arrayWithObject:(id)anObject count:(NSUInteger)count;
+ (instancetype)arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize;

@end
