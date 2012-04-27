//
//  NSEnumerator+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import "NSEnumerator+SIATools.h"

@implementation NSEnumerator (SIATools)

- (void)sia_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            block(obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
}

- (BOOL)sia_isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    BOOL isYesAll = YES;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
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
    }
    return isYesAll;
}

- (BOOL)sia_isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    BOOL isYesAny = NO;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            isYesAny = predicate(obj, idx, &stop);
            if (isYesAny) {
                break;
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return isYesAny;
}

- (NSArray *)sia_mappedArray:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSMutableArray *array = [NSMutableArray array];
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            id object = block(obj, idx, &stop);
            if (object) {
                [array addObject:object];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_objectOfObjectPassingTest:predicate ifNone:nil];
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self sia_objectOfObjectPassingTest:predicate ifNoneBlock:^id {
        return ifNone;
    }];
}

- (id)sia_objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock
{
    __block id object = nil;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
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
    }
    if (object == nil) {
        object = ifNoneBlock();
    }
    return object;
}

- (NSArray *)sia_arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = [NSMutableArray array];
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            BOOL pass = predicate(obj, idx, &stop);
            if (pass) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (NSArray *)sia_arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = [NSMutableArray array];
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            BOOL pass = predicate(obj, idx, &stop);
            if (!pass) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (id)sia_maxObjectUsingComparator:(NSComparator)cmptr
{
    id maxObject = nil;
    for (id obj in self) {
        @autoreleasepool {
            if (maxObject == nil) {
                maxObject = obj;
            }
            else if (cmptr(maxObject, obj) == NSOrderedAscending) {
                maxObject = obj;
            }
        }
    }
    return maxObject;
}

- (id)sia_minObjectUsingComparator:(NSComparator)cmptr
{
    id minObject = nil;
    for (id obj in self) {
        @autoreleasepool {
            if (minObject == nil) {
                minObject = obj;
            }
            else if (cmptr(minObject, obj) == NSOrderedDescending) {
                minObject = obj;
            }
        }
    }
    return minObject;
}

- (id)sia_inject:(id (^)(id result, id obj))injection
{
    return [self sia_inject:injection initialValue:nil];
}

- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initialValue
{
    id result = initialValue;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj);
        }
    }
    return result;
}

@end

@implementation NSEnumerator (SIAToolsRubyLike)

- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self sia_enumerateObjectsUsingBlock:block];
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

@interface SIAEnumerator ()
@property (nonatomic, copy) id (^traceBlock)(NSInteger index, id previousObject);
@property (nonatomic, strong) id currentObject;
@end

@implementation SIAEnumerator

+ (SIAEnumerator *)enumeratorWithTraceBlock:(id (^)(NSInteger index, id previousObject))traceBlock
{
    SIAEnumerator *enumerator = [[SIAEnumerator alloc] init];
    enumerator.traceBlock = traceBlock;
    return enumerator;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    if (state->state == 0) {
        state->mutationsPtr = (unsigned long *)(__bridge void *)self;
    }
    else if (self.currentObject == nil) {
        return 0;
    }
    
    state->itemsPtr = buffer;
    
    NSInteger containedCount = 0;
    for (int i = 0; i < len; i++) {
        @autoreleasepool {
            self.currentObject = self.traceBlock(state->state, self.currentObject);
            if (self.currentObject != nil) {
                state->itemsPtr[i] = self.currentObject;
                containedCount++;
                state->state++;
            }
            else {
                break;
            }
        }
    }
    
    return containedCount;
}

@end
