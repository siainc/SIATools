//
//  NSCoder+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/11.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "NSCoder+SIATools.h"

#import <objc/runtime.h>
#import "NSObject+SIATools.h"

@implementation NSCoder (SIATools)

- (void)sia_encodeInstanceVariable:(id)object
{
    [self sia_encodeInstanceVariable:object forClass:[object class] customCoder:nil];
}

- (void)sia_encodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder
{
    [object sia_enumerateInstanceVariableForClass:objectClass usingBlock:^(NSString *name, NSString *type, void *address, BOOL *stop) {
        if (customCoder != nil && customCoder(address)) {
            return;
        }
        
        switch (*type.UTF8String) {
            case '@':
                [self encodeObject:*(__unsafe_unretained id *)address forKey:name];
                break;
            case '#':
                [self encodeObject:NSStringFromClass(*(Class *)address) forKey:name];
                break;
            case ':':
                [self encodeObject:NSStringFromSelector(*(SEL *)address) forKey:name];
                break;
            case 'c':
                [self encodeObject:@(*(BOOL *)address) forKey:name];
                break;
            case 'C':
                [self encodeObject:@(*(unsigned char *)address) forKey:name];
                break;
            case 'i':
                [self encodeObject:@(*(int *)address) forKey:name];
                break;
            case 'I':
                [self encodeObject:@(*(unsigned int *)address) forKey:name];
                break;
            case 's':
                [self encodeObject:@(*(short *)address) forKey:name];
                break;
            case 'S':
                [self encodeObject:@(*(unsigned short *)address) forKey:name];
                break;
            case 'l':
                [self encodeObject:@(*(long *)address) forKey:name];
                break;
            case 'L':
                [self encodeObject:@(*(unsigned long *)address) forKey:name];
                break;
            case 'q':
                [self encodeObject:@(*(long long *)address) forKey:name];
                break;
            case 'Q':
                [self encodeObject:@(*(unsigned long long *)address) forKey:name];
                break;
            case 'f':
                [self encodeObject:@(*(float *)address) forKey:name];
                break;
            case 'd':
                [self encodeObject:@(*(double *)address) forKey:name];
                break;
            case 'B':
                [self encodeObject:@(*(bool *)address) forKey:name];
                break;
            case '*':
                // TODO:
                // [self encodeBytes:(const uint8_t *)*(char **)address length:strlen(*(char **)address) forKey:name];
                break;
            case '^':
                // TODO:
                // [self encodeObject:@(*(void **)address) forKey:name];
                break;
            case '{': {
                NSString *structName = [type substringWithRange:NSMakeRange(1, [type rangeOfString:@"="].location - 1)];
                NSValue *value = nil;
                if ([structName isEqualToString:@"CGPoint"]) {
                    value = [NSValue valueWithCGPoint:*(CGPoint *)address];
                }
                else if ([structName isEqualToString:@"CGRect"]) {
                    value = [NSValue valueWithCGRect:*(CGRect *)address];
                }
                else if ([structName isEqualToString:@"CGSize"]) {
                    value = [NSValue valueWithCGSize:*(CGSize *)address];
                }
                if (value) {
                    [self encodeObject:value forKey:name];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (void)sia_decodeInstanceVariable:(id)object
{
    [self sia_decodeInstanceVariable:object forClass:[object class] customCoder:nil];
}

- (void)sia_decodeInstanceVariable:(id)object forClass:(Class)objectClass customCoder:(BOOL (^)(void *p))customCoder
{
    [object sia_enumerateInstanceVariableForClass:objectClass usingBlock:^(NSString *name, NSString *type, void *address, BOOL *stop) {
        if (customCoder != nil && customCoder(address)) {
            return;
        }
        
        switch (*type.UTF8String) {
            case '@': {
                Ivar ivar = class_getInstanceVariable([object class], name.UTF8String);
                object_setIvar(object, ivar, [self decodeObjectForKey:name]);
                break;
            }
            case '#': {
                Ivar ivar = class_getInstanceVariable([object class], name.UTF8String);
                NSString *className = [self decodeObjectForKey:name];
                if (className) {
                    object_setIvar(object, ivar, NSClassFromString(className));
                }
                break;
            }
            case ':': {
                NSString *selName = [self decodeObjectForKey:name];
                if (selName) {
                    *(SEL *)address = NSSelectorFromString(selName);
                }
                break;
            }
            case 'c':
                *(BOOL *)address = [[self decodeObjectForKey:name] boolValue];
                break;
            case 'C':
                *(unsigned char *)address = [[self decodeObjectForKey:name] unsignedCharValue];
                break;
            case 'i':
                *(int *)address = [[self decodeObjectForKey:name] intValue];
                break;
            case 'I':
                *(unsigned int *)address = [[self decodeObjectForKey:name] unsignedIntValue];
                break;
            case 's':
                *(short *)address = [[self decodeObjectForKey:name] shortValue];
                break;
            case 'S':
                *(unsigned short *)address = [[self decodeObjectForKey:name] unsignedShortValue];
                break;
            case 'l':
                *(long *)address = [[self decodeObjectForKey:name] longValue];
                break;
            case 'L':
                *(unsigned long *)address = [[self decodeObjectForKey:name] unsignedLongValue];
                break;
            case 'q':
                *(long long *)address = [[self decodeObjectForKey:name] longLongValue];
                break;
            case 'Q':
                *(unsigned long long *)address = [[self decodeObjectForKey:name] unsignedLongLongValue];
                break;
            case 'f':
                *(float *)address = [[self decodeObjectForKey:name] floatValue];
                break;
            case 'd':
                *(double *)address = [[self decodeObjectForKey:name] doubleValue];
                break;
            case 'B':
                *(bool *)address = [[self decodeObjectForKey:name] boolValue];
                break;
            case '*': {
                // TODO
                // NSUInteger len = 0;
                // void *bytes = [self decodeBytesWithReturnedLength:&len];
                // *(char **)p = malloc(len + 1);
                // memcpy(*(char **)p, bytes, len);
                // (*(char **)p)[len] = '\0';
                // break;
            }
            case '^':
                // TODO
                break;
            case '{': {
                NSString *structName = [type substringWithRange:NSMakeRange(1, [type rangeOfString:@"="].location - 1)];
                if ([structName isEqualToString:@"CGPoint"]) {
                    NSValue *value = [self decodeObjectForKey:name];
                    *(CGPoint *)address = [value CGPointValue];
                }
                else if ([structName isEqualToString:@"CGRect"]) {
                    NSValue *value = [self decodeObjectForKey:name];
                    *(CGRect *)address = [value CGRectValue];
                }
                else if ([structName isEqualToString:@"CGSize"]) {
                    NSValue *value = [self decodeObjectForKey:name];
                    *(CGSize *)address = [value CGSizeValue];
                }
                break;
            }
            default:
                break;
        }
    }];
}

@end
