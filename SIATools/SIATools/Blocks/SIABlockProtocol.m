//
//  SIABlockProtocol.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/13.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIABlockProtocol.h"

#import <objc/runtime.h>
#import "NSObject+SIATools.h"
#import "SIAID.h"
#import "SIAToolsLogger.h"

@implementation SIABlockProtocol

+ (SIABlockProtocol *)createSubclassInstanceForProtocol:(Protocol *)protocol
{
    SIAToolsDLog(@">>protocol=%@", protocol);
    Class subclass = [self registerSubclass];
    if (protocol != NULL) {
        SIAToolsDLog(@"プロトコルを追加する:%@", NSStringFromProtocol(protocol));
        class_addProtocol(subclass, protocol);
    }
    id object = [[subclass alloc] init];
    SIAToolsDLog(@"<<%@", object);
    return object;
}

#pragma mark - add class methods

+ (void)addMethodWithSelector:(SEL)selector block:(id)block
{
    SIAToolsVLog(@">>selector=%@, block=%@", NSStringFromSelector(selector), block);
    [self addMethodWithSelector:selector protocol:nil block:block];
    SIAToolsVLog(@"<<");
}

+ (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block
{
    SIAToolsDLog(@">>selector=%@, protocol=%@, block=%@", NSStringFromSelector(selector), protocol, block);
    unsigned int count = 0;
    struct objc_method_description method_description;
    SEL          name  = NULL;
    if (protocol) {
        SIAToolsDLog(@"protocolが指定されているのでprotocolからmethod_descriptionを取得する");
        method_description = protocol_getMethodDescription(protocol, selector, YES, NO);
        if (method_description.name == NULL) {
            method_description = protocol_getMethodDescription(protocol, selector, NO, NO);
        }
        name = method_description.name;
    }
    else {
        SIAToolsDLog(@"protocolが指定されていないため自分が実装しているprotocolからmethod_descriptionを取得する");
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
        SIAToolsDLog(@"selectorに対応するmethod_descriptinがあったのでメソッドを追加する");
        [self addMethodWithSelector:selector types:method_description.types block:block];
    }
    SIAToolsDLog(@"<<");
}

#pragma mark - add instance methods

- (void)addMethodWithSelector:(SEL)selector block:(id)block
{
    SIAToolsVLog(@">>selector=%@, block=%@", NSStringFromSelector(selector), block);
    [self addMethodWithSelector:selector protocol:nil block:block];
    SIAToolsVLog(@"<<");
}

- (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block
{
    SIAToolsDLog(@">>selector=%@, protocol=%@, block=%@", NSStringFromSelector(selector), protocol, block);
    unsigned int count = 0;
    struct objc_method_description method_description;
    SEL          name  = NULL;
    if (protocol) {
        SIAToolsDLog(@"protocolが指定されているのでprotocolからmethod_descriptionを取得する");
        method_description = protocol_getMethodDescription(protocol, selector, YES, YES);
        if (method_description.name == NULL) {
            method_description = protocol_getMethodDescription(protocol, selector, NO, YES);
        }
        name = method_description.name;
    }
    else {
        SIAToolsDLog(@"protocolが指定されていないため自分が実装しているprotocolからmethod_descriptionを取得する");
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
        SIAToolsDLog(@"selectorに対応するmethod_descriptinがあったのでメソッドを追加する");
        [self addMethodWithSelector:selector types:method_description.types block:block];
    }
    SIAToolsDLog(@"<<");
}

@end

@implementation NSObject (NSObjectSIABlockProtocolExtensions)

- (SIABlockProtocol *)blockProtocolForProtocol:(Protocol *)protocol
{
    SIAToolsVLog(@">>protocol=%@", protocol);
    if (protocol == nil) {
        SIAToolsVLog(@"<<%@", nil);
        return nil;
    }
    SIABlockProtocol *blockObject = nil;
    NSString         *key         = [@"SIABlockProtocolFor" stringByAppendingString : NSStringFromProtocol(protocol)];
    @synchronized(self) {
        blockObject = [self associatedObjectForKey:key];
        if (blockObject == nil) {
            SIAToolsDLog(@"%@に対応するSIAExpandableObjectがないため生成する", NSStringFromProtocol(protocol));
            blockObject = [SIABlockProtocol createSubclassInstanceForProtocol:protocol];
            [self setAssociatedObject:blockObject forKey:key];
        }
    }
    SIAToolsVLog(@"<<%@", blockObject);
    return blockObject;
}

- (SIABlockProtocol *)blockDelegate
{
    SIAToolsVLog(@">>");
    Class class = self.class;
    while (class != nil) {
        NSString *protocolName = [NSStringFromClass(class) stringByAppendingString:@"Delegate"];
        Protocol *protocol     = NSProtocolFromString(protocolName);
        if (protocol != nil) {
            SIABlockProtocol *object = [self blockProtocolForProtocol:protocol];
            SIAToolsVLog(@"<<%@", object);
            return object;
        }
        class = class.superclass;
    }
    SIAToolsVLog(@"<<%@", nil);
    return nil;
}

- (SIABlockProtocol *)blockDataSource
{
    SIAToolsVLog(@">>");
    Class class = self.class;
    while (class != nil) {
        NSString *protocolName = [NSStringFromClass(class) stringByAppendingString:@"DataSource"];
        Protocol *protocol     = NSProtocolFromString(protocolName);
        if (protocol != nil) {
            SIABlockProtocol *object = [self blockProtocolForProtocol:protocol];
            SIAToolsVLog(@"<<%@", object);
            return object;
        }
        class = class.superclass;
    }
    SIAToolsVLog(@"<<%@", nil);
    return nil;
}

- (void)implementProtocol:(Protocol *)protocol
           setterSelector:(SEL)setterSelector
               usingBlock:(void (^)(SIABlockProtocol *protocol))block
{
    SIABlockProtocol *blockProtocol = [self blockProtocolForProtocol:protocol];
    if (block) {
        block(blockProtocol);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:setterSelector withObject:blockProtocol];
#pragma clang diagnostic pop
}

@end
