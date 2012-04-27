//
//  NSObject+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/27.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SIATools)

@property (nonatomic, readonly) id sia_notNullObject;

+ (instancetype)sia_loadInstanceFromNib;
+ (instancetype)sia_loadInstanceFromNibWithNibName:(NSString *)nibName;

- (void)sia_enumerateInstanceVariableUsingBlock:(void (^)(NSString *name, NSString *type, void *address, BOOL *stop))block;
- (void)sia_enumerateInstanceVariableForClass:(Class)objectClass
                                   usingBlock:(void (^)(NSString *name, NSString *type, void *address, BOOL *stop))block;

- (id)sia_associatedObjectForKey:(const void *)key;
- (void)sia_setAssociatedObject:(id)object forKey:(const void *)key;

- (void)sia_changeValueForKey:(NSString *)key changeBlock:(void (^)())changeBlock;
- (void)sia_change:(NSKeyValueChange)changeKind
   valuesAtIndexes:(NSIndexSet *)indexes
            forKey:(NSString *)key
       changeBlock:(void (^)())changeBlock;
- (void)sia_changeValueForKey:(NSString *)key
              withSetMutation:(NSKeyValueSetMutationKind)mutationKind
                 usingObjects:(NSSet *)objects
                  changeBlock:(void (^)())changeBlock;

@end
