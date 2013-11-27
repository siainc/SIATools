//
//  NSEnumerator+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import "NSEnumerator+SIATools.h"

#import "SIAToolsLogger.h"

@implementation NSEnumerator (SIATools)

- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    SIAToolsVLog(@">>predicate=%@", predicate);
    BOOL       isYesAll = YES;
    BOOL       stop     = NO;
    NSUInteger idx      = 0;
    for (id obj in self) {
        isYesAll = predicate(obj, idx, &stop);
        if (!isYesAll) {
            break;
        }
        if (stop) {
            isYesAll = NO;
            break;
        }
        idx++;
    }
    SIAToolsVLog(@"<<%d", isYesAll);
    return isYesAll;
}

- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    SIAToolsVLog(@">>predicate=%@", predicate);
    BOOL       isYesAny = NO;
    BOOL       stop     = NO;
    NSUInteger idx      = 0;
    for (id obj in self) {
        isYesAny = predicate(obj, idx, &stop);
        if (isYesAny) {
            break;
        }
        if (stop) {
            break;
        }
        idx++;
    }
    SIAToolsVLog(@"<<%d", isYesAny);
    return isYesAny;
}

- (NSArray *)mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    SIAToolsVLog(@">>block=%@", block);
    NSMutableArray *array = [NSMutableArray array];
    BOOL           stop   = NO;
    NSUInteger     idx    = 0;
    for (id obj in self) {
        id object = block(obj, idx, &stop);
        if (object) {
            [array addObject:object];
        }
        if (stop) {
            break;
        }
        idx++;
    }
    SIAToolsVLog(@"<<%@", array);
    return array;
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self objectOfObjectPassingTest:predicate ifNone:nil];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    SIAToolsVLog(@">>predicate=%@, ifNone=%@", predicate, ifNone);
    return [self objectOfObjectPassingTest:predicate ifNoneBlock:^id {
        return ifNone;
    }];
}

- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock
{
    SIAToolsVLog(@">>predicate=%@, ifNone=%@", predicate, ifNone);
    __block id object = nil;
    BOOL       stop   = NO;
    NSUInteger idx    = 0;
    for (id obj in self) {
        BOOL pass = predicate(obj, idx, &stop);
        if (pass) {
            object = obj;
            break;
        }
        if (stop) {
            break;
        }
        idx++;
    }
    if (object == nil) {
        object = ifNoneBlock();
    }
    SIAToolsVLog(@"<<%@", object);
    return object;
}

- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    SIAToolsVLog(@">>predicate=%@", predicate);
    NSMutableArray *array = [NSMutableArray array];
    BOOL           stop   = NO;
    NSUInteger     idx    = 0;
    for (id obj in self) {
        BOOL pass = predicate(obj, idx, &stop);
        if (pass) {
            [array addObject:obj];
        }
        if (stop) {
            break;
        }
        idx++;
    }
    SIAToolsVLog(@"<<%@", array);
    return array;
}

- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    SIAToolsVLog(@">>predicate=%@", predicate);
    NSMutableArray *array = [NSMutableArray array];
    BOOL           stop   = NO;
    NSUInteger     idx    = 0;
    for (id obj in self) {
        BOOL pass = predicate(obj, idx, &stop);
        if (!pass) {
            [array addObject:obj];
        }
        if (stop) {
            break;
        }
        idx++;
    }
    SIAToolsVLog(@"<<%@", array);
    return array;
}

- (id)maxObjectUsingComparator:(NSComparator)cmptr
{
    SIAToolsVLog(@">>cmptr=%@", cmptr);
    id maxObject = nil;
    for (id obj in self) {
        if (maxObject == nil) {
            maxObject = obj;
        }
        else if (cmptr(maxObject, obj) == NSOrderedAscending) {
            maxObject = obj;
        }
    }
    SIAToolsVLog(@"<<%@", maxObject);
    return maxObject;
}

- (id)minObjectUsingComparator:(NSComparator)cmptr
{
    SIAToolsVLog(@">>cmptr=%@", cmptr);
    id minObject = nil;
    for (id obj in self) {
        if (minObject == nil) {
            minObject = obj;
        }
        else if (cmptr(minObject, obj) == NSOrderedDescending) {
            minObject = obj;
        }
    }
    SIAToolsVLog(@"<<%@", minObject);
    return minObject;
}

- (id)inject:(id (^)(id result, id obj))injection
{
    return [self inject:injection initialValue:nil];
}

- (id)inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue
{
    id result = initialValue;
    for (id obj in self) {
        result = injection(result, obj);
    }
    return result;
}

@end
