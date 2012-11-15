//
//  NSArray+SITools.h
//
//  Created by KUROSAKI Ryota on 11/09/13.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SITools)

@property(nonatomic,readonly) id firstObject;
- (BOOL)isYesAll:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)isYesAny:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayByMap:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)objectOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (NSArray *)arrayOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayOfObjectRejectTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)maxObjectUsingComparator:(NSComparator)cmptr;
- (id)minObjectUsingComparator:(NSComparator)cmptr;
- (id)objectAtIndex:(NSUInteger)index ifNil:(id)ifNil;

@end
