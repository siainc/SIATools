//
//  NSArray+SITools.m
//
//  Created by KUROSAKI Ryota on 11/09/13.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSArray+SITools.h"

@implementation NSArray (SITools)
@dynamic firstObject;

- (id)firstObject
{
    return [self objectAtIndex:0 ifNil:nil];
}

- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    __block BOOL isYesAll = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isYes = predicate(obj, idx, stop);
        if (!(*stop)) {
            if (!isYes) {
                isYesAll = NO;
                *stop = YES;
            }
        }
    }];
    return isYesAll;
}

- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    __block BOOL isYesAny = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isYes = predicate(obj, idx, stop);
        if (!(*stop)) {
            if (isYes) {
                isYesAny = YES;
                *stop = YES;
            }
        }
    }];
    return isYesAny;
}

- (NSArray *)arrayByMap:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id object = block(obj, idx, stop);
        if (!(*stop)) {
            [array addObject:object];
        }
    }];
    return array;
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self objectOfObjectPassingTest:predicate ifNone:nil];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    __block id object = ifNone;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL pass = predicate(obj, idx, stop);
        if (!(*stop)) {
            if (pass) {
                object = obj;
                *stop = YES;
            }
        }
    }];
    return object;
}

- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL pass = predicate(obj, idx, stop);
        if (!(*stop) && pass) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL pass = predicate(obj, idx, stop);
        if (!(*stop) && !pass) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (id)maxObjectUsingComparator:(NSComparator)cmptr
{
    __block id maxObject = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!(*stop)) {
            if (maxObject == nil) {
                maxObject = obj;
            }
            else if (cmptr(maxObject, obj) == NSOrderedAscending) {
                maxObject = obj;
            }
        }
    }];
    return maxObject;
}

- (id)minObjectUsingComparator:(NSComparator)cmptr
{
    __block id minObject = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!(*stop)) {
            if (minObject == nil) {
                minObject = obj;
            }
            else if (cmptr(minObject, obj) == NSOrderedDescending) {
                minObject = obj;
            }
        }
    }];
    return minObject;
}

- (id)objectAtIndex:(NSUInteger)index ifNil:(id)ifNil
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    else {
        return ifNil;
    }
}

@end
