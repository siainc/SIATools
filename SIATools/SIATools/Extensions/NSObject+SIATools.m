//
//  NSObject+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/27.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSObject+SIATools.h"

#import <objc/runtime.h>

@implementation NSObject (SIATools)
@dynamic notNullObject;

- (id)notNullObject
{
    if ([self isEqual:[NSNull null]]) {
        return nil;
    }
    return self;
}

- (void)runBlock:(void (^)())block
{
    block();
}

- (void)runBlockOnMainThread:(void (^)())block waitUntilDone:(BOOL)wait
{
    [self performSelectorOnMainThread:@selector(runBlock:) withObject:[block copy] waitUntilDone:wait];
}

- (void)runBlock:(void (^)())block afterDelay:(NSTimeInterval)timeInterval
{
    [self performSelector:@selector(runBlock:) withObject:[block copy] afterDelay:timeInterval];
}

- (void)runBlockInBackground:(void (^)())block
{
    [self performSelectorInBackground:@selector(runBlock:) withObject:[block copy]];
}

+ (instancetype)loadInstanceFromNib
{
    return [self loadInstanceFromNibWithNibName:NSStringFromClass(self)];
}

+ (instancetype)loadInstanceFromNibWithNibName:(NSString *)nibName
{
    NSURL *URL = [[NSBundle mainBundle] URLForResource:nibName withExtension:@"nib"];
    if (URL != nil) {
        return [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].lastObject;
    }
    return nil;
}

- (void)enumerateInstanceVariableUsingBlock:(void (^)(NSString *name, NSString *type, void *address, BOOL *stop))block
{
    [self enumerateInstanceVariableForClass:self.class usingBlock:block];
}

- (void)enumerateInstanceVariableForClass:(Class)objectClass usingBlock:(void (^)(NSString *name, NSString *type, void *address, BOOL *stop))block
{
    unsigned int outCount = 0;
    Ivar         *ivars   = class_copyIvarList(objectClass, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Ivar       ivar   = ivars[i];
        const char *name  = ivar_getName(ivar);
        const char *type  = ivar_getTypeEncoding(ivar);
        ptrdiff_t  offset = ivar_getOffset(ivar);
        void       *p     = (UInt8 *)(__bridge void *)self + offset;
        BOOL       stop   = NO;
        
        if (block) {
            block([NSString stringWithFormat:@"%s", name],
                  [NSString stringWithFormat:@"%s", type],
                  p,
                  &stop);
        }
        if (stop) {
            break;
        }
    }
    
    if (outCount > 0) { free(ivars); }
}

- (id)associatedObjectForKey:(NSString *)key
{
    return objc_getAssociatedObject(self, (const void *)key.hash);
}

- (void)setAssociatedObject:(id)object forKey:(NSString *)key
{
    objc_setAssociatedObject(self, (const void *)key.hash, object, OBJC_ASSOCIATION_RETAIN);
}

- (void)changeValueForKey:(NSString *)key changeBlock:(void (^)())changeBlock
{
    [self willChangeValueForKey:key];
    changeBlock();
    [self didChangeValueForKey:key];
}

- (void)change:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key changeBlock:(void (^)())changeBlock
{
    [self willChange:changeKind valuesAtIndexes:indexes forKey:key];
    changeBlock();
    [self didChange:changeKind valuesAtIndexes:indexes forKey:key];
}

- (void)changeValueForKey:(NSString *)key
          withSetMutation:(NSKeyValueSetMutationKind)mutationKind
             usingObjects:(NSSet *)objects
              changeBlock:(void (^)())changeBlock
{
    [self willChangeValueForKey:key withSetMutation:mutationKind usingObjects:objects];
    changeBlock();
    [self didChangeValueForKey:key withSetMutation:mutationKind usingObjects:objects];
}

@end
