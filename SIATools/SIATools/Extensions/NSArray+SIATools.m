//
//  NSArray+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSArray+SIATools.h"

#import "NSEnumerator+SIATools.h"
#import "SIAToolsLogger.h"

@implementation NSArray (SIATools)
@dynamic firstObject;
@dynamic firstIndex;
@dynamic lastIndex;

- (id)firstObject
{
    return [self objectAtIndex:0 ifNil:nil];
}

- (NSArray *)firstObjectsWithNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(0, MIN(number, self.count))];
}

- (NSArray *)lastObjectsWithNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                               MIN(number, self.count))];
}

- (NSInteger)firstIndex
{
    return self.count > 0 ? 0 : NSNotFound;
}

- (NSInteger)lastIndex
{
    return self.count > 0 ? self.count - 1 : NSNotFound;
}

- (BOOL)validateIndex:(NSInteger)index
{
    return 0 <= index && index < self.count;
}

- (id)objectAtIndex:(NSUInteger)index ifNil:(id)ifNil
{
    SIAToolsVLog(@">>index=%lu, ifNil=%@", index, ifNil);
    id object = ifNil;
    if (index < self.count) {
        object = [self objectAtIndex:index];
    }
    SIAToolsVLog(@"<<%@", object);
    return object;
}

- (id)objectAtIndex:(NSUInteger)index ifNilBlock:(id (^)())ifNilBlock
{
    SIAToolsVLog(@">>index=%lu, ifNilBlock=%@", index, ifNilBlock);
    id object = nil;
    if (index < self.count) {
        object = [self objectAtIndex:index];
    }
    else {
        object = ifNilBlock();
    }
    SIAToolsVLog(@"<<%@", object);
    return object;
}

- (NSArray *)flattenArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [array addObjectsFromArray:[obj flattenArray]];
        }
        else {
            [array addObject:obj];
        }
    }
    return array;
}

- (NSArray *)reverseArray
{
    return self.reverseObjectEnumerator.allObjects;
}

- (id)sampleObject
{
    NSInteger sampleIndex = arc4random() % self.count;
    return self[sampleIndex];
}

- (NSArray *)sampleObjectsWithNumber:(NSInteger)number
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

- (NSArray *)shuffleArray
{
    return [self sampleObjectsWithNumber:self.count];
}

- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator isYesAll:predicate];
}

- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator isYesAny:predicate];
}

- (NSArray *)mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    return [self.objectEnumerator mappedArray:block];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self objectOfObjectPassingTest:predicate ifNone:nil];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self.objectEnumerator objectOfObjectPassingTest:predicate ifNone:ifNone];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
                    ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self.objectEnumerator objectOfObjectPassingTest:predicate ifNoneBlock:ifNoneBlock];
}

- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator arrayOfObjectPassingTest:predicate];
}

- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator arrayOfObjectRejectTest:predicate];
}

- (id)maxObjectUsingComparator:(NSComparator)cmptr
{
    return [self.objectEnumerator maxObjectUsingComparator:cmptr];
}

- (id)minObjectUsingComparator:(NSComparator)cmptr
{
    return [self.objectEnumerator minObjectUsingComparator:cmptr];
}

- (id)inject:(id (^)(id result, id obj))injection
{
    return [self inject:injection initialValue:nil];
}

- (id)inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue
{
    return [self.objectEnumerator inject:injection initialValue:initialValue];
}

@end

@implementation NSMutableArray (SIATools)

- (id)popObject
{
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

- (NSArray *)popObjectsWithNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self lastObjectsWithNumber:number]];
    [self removeObjectsInRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                           MIN(number, self.count))];
    return array;
}

- (void)pushObject:(id)object
{
    [self addObject:object];
}

- (void)pushObjects:(NSArray *)array
{
    [self addObjectsFromArray:array];
}

- (id)shiftObject
{
    id object = self.firstObject;
    if ([self validateIndex:0]) {
        [self removeObjectAtIndex:0];
    }
    return object;
}

- (NSArray *)shiftObjectsWithNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self firstObjectsWithNumber:number]];
    [self removeObjectsInRange:NSMakeRange(0, MIN(number, self.count))];
    return array;
}

- (void)unshiftObject:(id)object
{
    [self insertObject:object atIndex:0];
}

- (void)unshiftObjects:(NSArray *)array
{
    [self insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
}

- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexSet];
}

- (void)removeObjectsRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL (id obj,
                                                                    NSUInteger idx,
                                                                    BOOL *stop) {
        return !predicate(obj, idx, stop);
    }];
    [self removeObjectsAtIndexes:indexSet];
}

+ (instancetype)arrayWithObject:(id)anObject count:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [array addObject:anObject];
    }
    return array;
}

+ (instancetype)arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numItems];
    BOOL           stop   = NO;
    for (NSUInteger i = 0; i < numItems; i++) {
        id obj = initialize(i, &stop);
        if (obj) {
            [array addObject:obj];
        }
        if (stop) {
            break;
        }
    }
    return array;
}

@end

