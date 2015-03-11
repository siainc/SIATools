//
//  SIADescriptionBuilder.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/08/31.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIADescriptionBuilder.h"

#import <objc/runtime.h>
#import "NSObject+SIATools.h"

/**
 * descriptionメッソドをオーバーライドし、インスタンス変数情報を出力するためのヘルパークラス.
 */
@implementation SIADescriptionBuilder

/**
 * 共通で使用するためのDescriptionBuilderオブジェクトを返す.
 * @return DescriptionBuilderオブジェクト.
 */
+ (SIADescriptionBuilder *)defaultBuilder
{
    static dispatch_once_t onceToken;
    static SIADescriptionBuilder *_defaultBuilder;
    dispatch_once(&onceToken, ^{
        _defaultBuilder = [[SIADescriptionBuilder alloc] init];
    });
    return _defaultBuilder;
}

- (id)init
{
    self = [super init];
    if (self) {
        _idBlocks = [[NSMutableDictionary alloc] initWithCapacity:10];
        _structBlocks = [[NSMutableDictionary alloc] initWithCapacity:10];
        
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromPoint(NSPointFromCGPoint(*(CGPoint *)address));
        } forKey:@"CGPoint"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromRect(NSRectFromCGRect(*(CGRect *)address));
        } forKey:@"CGRect"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromSize(NSSizeFromCGSize(*(CGSize *)address));
        } forKey:@"CGSize"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromPoint(*(NSPoint *)address);
        } forKey:@"NSPoint"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromRect(*(NSRect *)address);
        } forKey:@"NSRect"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromSize(*(NSSize *)address);
        } forKey:@"NSSize"];
#else
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromCGPoint(*(CGPoint *)address);
        } forKey:@"CGPoint"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromCGRect(*(CGRect *)address);
        } forKey:@"CGRect"];
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromCGSize(*(CGSize *)address);
        } forKey:@"CGSize"];
#endif
        [_structBlocks setValue:^(id object, NSString *type, void *address) {
            return NSStringFromRange(*(NSRange *)address);
        } forKey:@"NSRange"];
        
        _formatBlock = [^(id object, NSArray *elements) {
            NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ <%p> {", NSStringFromClass([object class]), object];
            for (int i = 0; i < [elements count]; i++) {
                NSDictionary *d = [elements objectAtIndex:i];
                NSString *format = (i != 0) ? @"; %@=%@" : @"%@=%@";
                [description appendFormat:format, [d valueForKey:@"name"], [d valueForKey:@"string"]];;
            }
            [description appendString:@"}"];
            return description;
        } copy];
    }
    return self;
}

/**
 * インスタンス変数の情報を集めて文字列を作成する.
 * @param object 対象のインスタンス.
 * @return インスタンス変数情報の文字列.
 */
- (NSString *)buildDescription:(id)object
{
    return [self buildDescription:object customFormatter:nil];
}

- (NSString *)buildDescription:(id)object customFormatter:(NSString * (^)(NSString *name, NSString *type, void *address))customFormatter
{
    NSMutableArray *elements = [NSMutableArray arrayWithCapacity:0];
    
    [object sia_enumerateInstanceVariableUsingBlock:^(NSString *name, NSString *type, void *address, BOOL *stop) {
        NSString *stringValue = nil;
        if (customFormatter != nil) {
            stringValue = customFormatter(name, type, address);
        }
        if (stringValue == nil) {
            switch (*(type.UTF8String)) {
                case '@': {
                    NSString *className = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
                    NSString * (^block)(id object, NSString *type, void *address) = [_idBlocks valueForKey:className];
                    if (block) {
                        stringValue = block(object, type, address);
                    }
                    else {
                        stringValue = [*(__unsafe_unretained id *)address description];
                    }
                    break;
                }
                case '#':
                    stringValue = NSStringFromClass(*(Class *)address);
                    break;
                case ':':
                    stringValue = NSStringFromSelector(*(SEL *)address);
                    break;
                case 'c':
                    stringValue = *(BOOL *)address ? @"YES" : @"NO";
                    break;
                case 'C':
                    stringValue = [NSString stringWithFormat:@"%c[%d]", *(unsigned char *)address, *(unsigned char *)address];
                    break;
                case 'i':
                    stringValue = [NSString stringWithFormat:@"%d", *(int *)address];
                    break;
                case 'I':
                    stringValue = [NSString stringWithFormat:@"%u", *(unsigned int *)address];
                    break;
                case 's':
                    stringValue = [NSString stringWithFormat:@"%hi", *(short *)address];
                    break;
                case 'S':
                    stringValue = [NSString stringWithFormat:@"%hu", *(unsigned short *)address];
                    break;
                case 'l':
                    stringValue = [NSString stringWithFormat:@"%ld", *(long *)address];
                    break;
                case 'L':
                    stringValue = [NSString stringWithFormat:@"%lu", *(unsigned long *)address];
                    break;
                case 'q':
                    stringValue = [NSString stringWithFormat:@"%qi", *(long long *)address];
                    break;
                case 'Q':
                    stringValue = [NSString stringWithFormat:@"%qu", *(unsigned long long *)address];
                    break;
                case 'f':
                    stringValue = [NSString stringWithFormat:@"%f", *(float *)address];
                    break;
                case 'd':
                    stringValue = [NSString stringWithFormat:@"%f", *(double *)address];
                    break;
                case 'B':
                    stringValue = *(bool *)address ? @"true" : @"false";
                    break;
                case '*':
                    stringValue = [NSString stringWithFormat:@"%s", *(char **)address];
                    break;
                case '^':
                    stringValue = [NSString stringWithFormat:@"%p", *(void **)address];
                    break;
                case '{': {
                    NSString *structName = [type substringWithRange:NSMakeRange(1, [type rangeOfString:@"="].location - 1)];
                    NSString * (^block)(id object, NSString *type, void *address) = [_structBlocks valueForKey:structName];
                    if (block) {
                        stringValue = block(object, type, address);
                    }
                    break;
                }
                default:
                    stringValue = @"Unknown";
                    break;
            }
        }
        
        [elements addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          name, @"name", stringValue, @"string", nil]];
    }];
    
    return self.formatBlock(object, elements);
}

@end
