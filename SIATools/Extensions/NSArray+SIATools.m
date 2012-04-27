//
//  NSArray+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSArray+SIATools.h"

#import "NSEnumerator+SIATools.h"

@implementation NSArray (SIATools)
@dynamic sia_firstObject;
@dynamic sia_firstIndex;
@dynamic sia_lastIndex;

- (id)sia_firstObject
{
    return [self sia_objectAtIndex:0 ifNil:nil];
}

- (NSArray *)sia_firstObjectsWithNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(0, MIN(number, self.count))];
}

- (NSArray *)sia_lastObjectsWithNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                               MIN(number, self.count))];
}

- (NSInteger)sia_firstIndex
{
    return self.count > 0 ? 0 : NSNotFound;
}

- (NSInteger)sia_lastIndex
{
    return self.count > 0 ? self.count - 1 : NSNotFound;
}

- (NSInteger)sia_indexFromMinusIndex:(NSInteger)minusIndex
{
    if (minusIndex == NSNotFound) {
        return NSNotFound;
    }
    if (self.count * -1 <= minusIndex && minusIndex < 0) {
        return self.count + minusIndex;
    }
    return minusIndex;
}

- (NSInteger)sia_minusIndexFromIndex:(NSInteger)index
{
    if (index == NSNotFound) {
        return NSNotFound;
    }
    if ([self sia_validateIndex:index]) {
        return index - self.count;
    }
    return index;
}

- (BOOL)sia_validateIndex:(NSInteger)index
{
    return 0 <= index && index < self.count;
}

- (id)sia_objectAtIndex:(NSUInteger)index
{
    return [self sia_objectAtIndex:index ifNil:nil];
}

- (id)sia_objectAtIndex:(NSUInteger)index ifNil:(id)ifNil
{
    id object = ifNil;
    NSInteger normalizedIndex = [self sia_indexFromMinusIndex:index];
    if (normalizedIndex < self.count) {
        object = [self objectAtIndex:normalizedIndex];
    }
    return object;
}

- (id)sia_objectAtIndex:(NSUInteger)index ifNilBlock:(id (^)())ifNilBlock
{
    id object = nil;
    NSInteger normalizedIndex = [self sia_indexFromMinusIndex:index];
    if (normalizedIndex < self.count) {
        object = [self objectAtIndex:normalizedIndex];
    }
    else {
        object = ifNilBlock();
    }
    return object;
}

- (NSArray *)sia_flattenArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in array) {
        @autoreleasepool {
            if ([obj isKindOfClass:[NSArray class]]) {
                [array addObjectsFromArray:[obj sia_flattenArray]];
            }
            else {
                [array addObject:obj];
            }
        }
    }
    return array;
}

- (NSArray *)sia_reverseArray
{
    return self.reverseObjectEnumerator.allObjects;
}

- (id)sia_sampleObject
{
    NSInteger sampleIndex = arc4random() % self.count;
    return self[sampleIndex];
}

- (NSArray *)sia_sampleObjectsWithNumber:(NSInteger)number
{
    NSAssert(0 <= number && number <= self.count, @"配列要素数以内であること");
    NSMutableArray *source = self.mutableCopy;
    NSMutableArray *destination = @[].mutableCopy;
    for (int i = 0; i < number; i++) {
        NSInteger sampleIndex = arc4random() % source.count;
        [destination addObject:source[sampleIndex]];
        [source removeObjectAtIndex:sampleIndex];
    }
    return destination;
}

- (NSArray *)sia_shuffleArray
{
    return [self sia_sampleObjectsWithNumber:self.count];
}

- (BOOL)sia_isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_isYesAll:predicate];
}

- (BOOL)sia_isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_isYesAny:predicate];
}

- (NSArray *)sia_mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    return [self.objectEnumerator sia_mappedArray:block];
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_objectOfObjectPassingTest:predicate ifNone:nil];
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self.objectEnumerator sia_objectOfObjectPassingTest:predicate ifNone:ifNone];
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
                        ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self.objectEnumerator sia_objectOfObjectPassingTest:predicate ifNoneBlock:ifNoneBlock];
}

- (NSArray *)sia_arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_arrayOfObjectPassingTest:predicate];
}

- (NSArray *)sia_arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_arrayOfObjectRejectTest:predicate];
}

- (id)sia_maxObjectUsingComparator:(NSComparator)cmptr
{
    return [self.objectEnumerator sia_maxObjectUsingComparator:cmptr];
}

- (id)sia_minObjectUsingComparator:(NSComparator)cmptr
{
    return [self.objectEnumerator sia_minObjectUsingComparator:cmptr];
}

- (id)sia_inject:(id (^)(id result, id obj))injection
{
    return [self sia_inject:injection initialValue:nil];
}

- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue
{
    return [self.objectEnumerator sia_inject:injection initialValue:initialValue];
}

@end

@implementation NSArray (SIAToolsRubyLike)

- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (BOOL)all:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_isYesAll:predicate];
}

- (BOOL)any:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_isYesAny:predicate];
}

- (NSArray *)map:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    return [self sia_mappedArray:block];
}

- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_objectOfObjectPassingTest:predicate];
}

- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self sia_objectOfObjectPassingTest:predicate ifNone:ifNone];
}

- (id)find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self sia_objectOfObjectPassingTest:predicate ifNoneBlock:ifNoneBlock];
}

- (NSArray *)findAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_arrayOfObjectPassingTest:predicate];
}

- (NSArray *)reject:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_arrayOfObjectRejectTest:predicate];
}

- (id)max:(NSComparator)cmptr
{
    return [self sia_maxObjectUsingComparator:cmptr];
}

- (id)min:(NSComparator)cmptr
{
    return [self sia_minObjectUsingComparator:cmptr];
}

@end

@implementation NSMutableArray (SIATools)

- (id)sia_popObject
{
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

- (NSArray *)sia_popObjectsWithNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self sia_lastObjectsWithNumber:number]];
    [self removeObjectsInRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                           MIN(number, self.count))];
    return array;
}

- (void)sia_pushObject:(id)object
{
    [self addObject:object];
}

- (void)sia_pushObjects:(NSArray *)array
{
    [self addObjectsFromArray:array];
}

- (id)sia_shiftObject
{
    id object = self.sia_firstObject;
    if ([self sia_validateIndex:0]) {
        [self removeObjectAtIndex:0];
    }
    return object;
}

- (NSArray *)sia_shiftObjectsWithNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self sia_firstObjectsWithNumber:number]];
    [self removeObjectsInRange:NSMakeRange(0, MIN(number, self.count))];
    return array;
}

- (void)sia_unshiftObject:(id)object
{
    [self insertObject:object atIndex:0];
}

- (void)sia_unshiftObjects:(NSArray *)array
{
    [self insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
}

- (void)sia_removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexSet];
}

- (void)sia_removeObjectsRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL (id obj,
                                                                    NSUInteger idx,
                                                                    BOOL *stop) {
        return !predicate(obj, idx, stop);
    }];
    [self removeObjectsAtIndexes:indexSet];
}

+ (instancetype)sia_arrayWithObject:(id)anObject count:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [array addObject:anObject];
    }
    return array;
}

+ (instancetype)sia_arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numItems];
    BOOL stop = NO;
    for (NSUInteger i = 0; i < numItems; i++) {
        @autoreleasepool {
            id obj = initialize(i, &stop);
            if (obj) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
        }
    }
    return array;
}

@end

@implementation NSMutableArray (SIAToolsRubyLike)

- (id)pop
{
    return [self sia_popObject];
}

- (NSArray *)pop:(NSUInteger)number
{
    return [self sia_popObjectsWithNumber:number];
}

- (void)push:(id)object
{
    [self sia_pushObject:object];
}

- (void)pushs:(NSArray *)array
{
    [self sia_pushObjects:array];
}

- (id)shift
{
    return [self sia_shiftObject];
}

- (NSArray *)shift:(NSUInteger)number
{
    return [self sia_shiftObjectsWithNumber:number];
}

- (void)unshift:(id)object
{
    [self sia_unshiftObject:object];
}

- (void)unshifts:(NSArray *)array
{
    [self sia_unshiftObjects:array];
}

- (void)removeIf:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    [self sia_removeObjectsPassingTest:predicate];
}

@end
