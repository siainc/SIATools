//
//  SIABlockProtocol.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/13.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIABlockProtocol.h"

#import <objc/runtime.h>
#import "NSObject+SIATools.h"
#import "SIAID.h"

@implementation SIABlockProtocol

+ (SIABlockProtocol *)createSubclassInstanceForProtocol:(Protocol *)protocol
{
    Class subclass = [self registerSubclass];
    if (protocol != NULL) {
        class_addProtocol(subclass, protocol);
    }
    id object = [[subclass alloc] init];
    return object;
}

#pragma mark - add class methods

+ (void)addMethodWithSelector:(SEL)selector block:(id)block
{
    [self addMethodWithSelector:selector protocol:nil block:block];
}

+ (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block
{
    unsigned int count = 0;
    struct objc_method_description method_description;
    SEL name = NULL;
    if (protocol) {
        // protocol指定時はそのprotocolからmethod_descriptionを取得する
        method_description = protocol_getMethodDescription(protocol, selector, YES, NO);
        if (method_description.name == NULL) {
            method_description = protocol_getMethodDescription(protocol, selector, NO, NO);
        }
        name = method_description.name;
    }
    else {
        // protocol未指定時は実装しているprotocolからmethod_descriptionを取得する
        Protocol __unsafe_unretained **protocol_list = class_copyProtocolList(self, &count);
        for (int i = 0; i < count; i++) {
            method_description = protocol_getMethodDescription(protocol_list[i], selector, YES, NO);
            if (method_description.name == NULL) {
                method_description = protocol_getMethodDescription(protocol_list[i], selector, NO, NO);
            }
            if (method_description.name != NULL) {
                name = method_description.name;
                break;
            }
        }
        free(protocol_list);
    }
    if (name != NULL) {
        // selectorに対応するmethod_descriptionがある場合はメソッドを追加する
        [self addMethodWithSelector:selector types:method_description.types block:block];
    }
}

#pragma mark - add instance methods

- (void)addMethodWithSelector:(SEL)selector block:(id)block
{
    [self addMethodWithSelector:selector protocol:nil block:block];
}

- (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block
{
    unsigned int count = 0;
    struct objc_method_description method_description;
    SEL name = NULL;
    if (protocol) {
        // protocol指定時はそのprotocolからmethod_descriptionを取得する
        method_description = protocol_getMethodDescription(protocol, selector, YES, YES);
        if (method_description.name == NULL) {
            method_description = protocol_getMethodDescription(protocol, selector, NO, YES);
        }
        name = method_description.name;
    }
    else {
        // protocol未指定時は実装しているprotocolからmethod_descriptionを取得する
        Protocol __unsafe_unretained **protocol_list = class_copyProtocolList(self.class, &count);
        for (int i = 0; i < count; i++) {
            method_description = protocol_getMethodDescription(protocol_list[i], selector, YES, YES);
            if (method_description.name == NULL) {
                method_description = protocol_getMethodDescription(protocol_list[i], selector, NO, YES);
            }
            if (method_description.name != NULL) {
                name = method_description.name;
                break;
            }
        }
        free(protocol_list);
    }
    
    if (name != NULL) {
        // selectorに対応するmethod_descriptionがある場合はメソッドを追加する
        [self addMethodWithSelector:selector types:method_description.types block:block];
    }
}

@end

@implementation NSObject (NSObjectSIABlockProtocolExtensions)

- (SIABlockProtocol *)sia_blockProtocolForProtocol:(Protocol *)protocol
{
    if (protocol == nil) {
        return nil;
    }
    SIABlockProtocol *blockObject = nil;
    @synchronized(self) {
        blockObject = [self sia_associatedObjectForKey:(const void *)protocol];
        if (blockObject == nil) {
            blockObject = [SIABlockProtocol createSubclassInstanceForProtocol:protocol];
            [self sia_setAssociatedObject:blockObject forKey:(const void *)protocol];
        }
    }
    return blockObject;
}

- (SIABlockProtocol *)sia_blockDelegate
{
    Protocol *protocol = [self sia_searchProtocolWithSuffix:@"Delegate"];
    if (protocol != nil) {
        return [self sia_blockProtocolForProtocol:protocol];
    }
    return nil;
}

- (SIABlockProtocol *)sia_blockDataSource
{
    Protocol *protocol = [self sia_searchProtocolWithSuffix:@"DataSource"];
    if (protocol != nil) {
        return [self sia_blockProtocolForProtocol:protocol];
    }
    return nil;
}

- (Protocol *)sia_searchProtocolWithSuffix:(NSString *)suffix
{
    Class class = self.class;
    while (class != nil) {
        NSString *protocolName = [NSStringFromClass(class) stringByAppendingString:suffix];
        Protocol *protocol = NSProtocolFromString(protocolName);
        if (protocol != nil) {
            return protocol;
        }
        class = class.superclass;
    }
    return nil;
}

- (void)sia_implementProtocol:(Protocol *)protocol
               setterSelector:(SEL)setterSelector
                   usingBlock:(void (^)(SIABlockProtocol *protocol))block
{
    SIABlockProtocol *blockProtocol = [self sia_blockProtocolForProtocol:protocol];
    if (block) {
        block(blockProtocol);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:setterSelector withObject:blockProtocol];
#pragma clang diagnostic pop
}

@end
