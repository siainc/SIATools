//
//  SIDescriptionBuilder.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/08/31.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIDescriptionBuilder.h"
#import <objc/runtime.h>

/**
 * descriptionメッソドをオーバーライドし、インスタンス変数情報を出力するためのヘルパークラス.
 */
@implementation SIDescriptionBuilder

/**
 * 共通で使用するためのDescriptionBuilderオブジェクトを返す.
 * @return DescriptionBuilderオブジェクト.
 */
+ (SIDescriptionBuilder *)defaultBuilder
{
    static dispatch_once_t onceToken;
    static SIDescriptionBuilder *_defaultBuilder;
    dispatch_once(&onceToken, ^{
        _defaultBuilder = [[SIDescriptionBuilder alloc] init];
    });
    return _defaultBuilder;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.idBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[*(__unsafe_unretained id *)p description];
        };
        self.classBlock = ^(id object, Ivar ivar, void *p) {
            return NSStringFromClass(*(Class *)p);
        };
        self.SELBlock = ^(id object, Ivar ivar, void *p) {
            return NSStringFromSelector(*(SEL *)p);
        };
        self.BOOLBlock = ^(id object, Ivar ivar, void *p) {
            return *(BOOL *)p ? @"YES" : @"NO";
        };
        self.uCharBlock = ^(id object, Ivar ivar, void *p) {
            unsigned char v = *(unsigned char *)p;
            return (NSString *)[NSString stringWithFormat:@"%c[%d]", v, v];
        };
        self.intBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%d", *(int *)p];
        };
        self.uIntBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%u", *(unsigned int *)p];
        };
        self.shortBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%hi", *(short *)p];
        };
        self.uShortBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%hu", *(unsigned short *)p];
        };
        self.longBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%ld", *(long *)p];
        };
        self.uLongBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%lu", *(unsigned long *)p];
        };
        self.longlongBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%qi", *(long long *)p];
        };
        self.uLonglongBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%qu", *(unsigned long long *)p];
        };
        self.floatBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%f", *(float *)p];
        };
        self.doubleBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%f", *(double *)p];
        };
        self.boolBlock = ^(id object, Ivar ivar, void *p) {
            return *(bool *)p ? @"true" : @"false";
        };
        self.stringBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%s", *(char **)p];
        };
        self.pointerBlock = ^(id object, Ivar ivar, void *p) {
            return (NSString *)[NSString stringWithFormat:@"%p", *(void **)p];
        };
        self.otherBlock = ^(id object, Ivar ivar, void *p) {
            return @"Unknown";
        };
        _idBlocks = [[NSMutableDictionary alloc] initWithCapacity:10];
        _structBlocks = [[NSMutableDictionary alloc] initWithCapacity:10];
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromPoint(NSPointFromCGPoint(*(CGPoint *)p));
        } forKey:@"CGPoint"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromRect(NSRectFromCGRect(*(CGRect *)p));
        } forKey:@"CGRect"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromSize(NSSizeFromCGSize(*(CGSize *)p));
        } forKey:@"CGSize"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromPoint(*(NSPoint *)p);
        } forKey:@"NSPoint"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromRect(*(NSRect *)p);
        } forKey:@"NSRect"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromSize(*(NSSize *)p);
        } forKey:@"NSSize"];
#else
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromCGPoint(*(CGPoint *)p);
        } forKey:@"CGPoint"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromCGRect(*(CGRect *)p);
        } forKey:@"CGRect"];
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromCGSize(*(CGSize *)p);
        } forKey:@"CGSize"];
#endif
        [_structBlocks setValue:^(id object, Ivar ivar, void *p) {
            return NSStringFromRange(*(NSRange *)p);
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

- (NSString *)buildDescription:(id)object customFormatter:(NSString *(^)(void *p))customFormatter
{
    Class cls = [object class];
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    NSMutableArray *elements = [NSMutableArray arrayWithCapacity:outCount];
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
		const char *name = ivar_getName(ivar);
		const char *type = ivar_getTypeEncoding(ivar);
        
        ptrdiff_t offset = ivar_getOffset(ivar);
        void *vp = (__bridge void *)object;
        UInt8 *uint8p = (UInt8 *)vp;
        void *p = uint8p + offset;
        
        NSString *variableName = [NSString stringWithUTF8String:name];
        NSString *stringValue = nil;
        NSString *(^stringFromPointerBlock)(id object, Ivar ivar, void *p) = nil;
        
        switch (*type) {
            case '@': {
                NSString *typeString = [NSString stringWithUTF8String:type];
                NSString *className = [typeString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
                NSString *(^block)(id object, Ivar ivar, void *p) = [_idBlocks valueForKey:className];
                if (block) {
                    stringFromPointerBlock = block;
                }
                else {
                    stringFromPointerBlock = _idBlock;
                }
                break;
            }
            case '#':
                stringFromPointerBlock = _classBlock;
                break;
            case ':':
                stringFromPointerBlock = _SELBlock;
                break;
            case 'c':
                stringFromPointerBlock = _BOOLBlock;
                break;
            case 'C':
                stringFromPointerBlock = _uCharBlock;
                break;
            case 'i':
                stringFromPointerBlock = _intBlock;
                break;
            case 'I':
                stringFromPointerBlock = _uIntBlock;
                break;
            case 's':
                stringFromPointerBlock = _shortBlock;
                break;
            case 'S':
                stringFromPointerBlock = _uShortBlock;
                break;
            case 'l':
                stringFromPointerBlock = _longBlock;
                break;
            case 'L':
                stringFromPointerBlock = _uLongBlock;
                break;
            case 'q':
                stringFromPointerBlock = _longlongBlock;
                break;
            case 'Q':
                stringFromPointerBlock = _uLonglongBlock;
                break;
            case 'f':
                stringFromPointerBlock = _floatBlock;
                break;
            case 'd':
                stringFromPointerBlock = _doubleBlock;
                break;
            case 'B':
                stringFromPointerBlock = _boolBlock;
                break;
            case '*':
                stringFromPointerBlock = _stringBlock;
                break;
            case '^':
                stringFromPointerBlock = _pointerBlock;
                break;
            case '{': {
                NSString *typeString = [NSString stringWithUTF8String:type];
                NSString *structName = [typeString substringWithRange:NSMakeRange(1, [typeString rangeOfString:@"="].location - 1)];
                NSString *(^block)(id object, Ivar ivar, void *p) = [_structBlocks valueForKey:structName];
                if (block) {
                    stringFromPointerBlock = block;
                }
                break;
            }
            default:
                stringFromPointerBlock = _otherBlock;
                break;
        }

        if (customFormatter != nil) {
            stringValue = customFormatter(p);
        }
        if (stringValue == nil) {
            stringValue =  stringFromPointerBlock ? stringFromPointerBlock(object, ivar, p) : @"";
        }
        [elements addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          variableName, @"name", stringValue, @"string", nil]];
    }
    
    NSString *description = _formatBlock(object, elements);
    
    if (outCount > 0) { free(ivars); }
    
    return description;
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

@end
