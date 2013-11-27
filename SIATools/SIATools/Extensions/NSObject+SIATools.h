//
//  NSObject+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/27.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SIATools)

@property (nonatomic, readonly) id notNullObject;

+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithNibName:(NSString *)nibName;

- (void)enumerateInstanceVariableUsingBlock:(void (^)(NSString *name, NSString *type, void *address, BOOL *stop))block;
- (void)enumerateInstanceVariableForClass:(Class)objectClass usingBlock:(void (^)(NSString *name, NSString *type, void *address,
                                                                                  BOOL *stop))block;
- (id)associatedObjectForKey:(NSString *)key;
- (void)setAssociatedObject:(id)object forKey:(NSString *)key;

- (void)changeValueForKey:(NSString *)key changeBlock:(void (^)())changeBlock;
- (void)change:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key changeBlock:(void (^)())changeBlock;
- (void)changeValueForKey:(NSString *)key
          withSetMutation:(NSKeyValueSetMutationKind)mutationKind
             usingObjects:(NSSet *)objects
              changeBlock:(void (^)())changeBlock;

@end
