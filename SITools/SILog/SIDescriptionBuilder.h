//
//  SIDescriptionBuilder.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/08/31.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#ifndef SITools_SIDescriptionBuilder_h
#define SITools_SIDescriptionBuilder_h

@interface SIDescriptionBuilder : NSObject

@property(nonatomic,copy) NSString *(^idBlock)(id object, Ivar ivar, void *p); ///< id を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^classBlock)(id object, Ivar ivar, void *p); ///< Class を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^SELBlock)(id object, Ivar ivar, void *p); ///< SEL を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^BOOLBlock)(id object, Ivar ivar, void *p); ///< BOOL を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^uCharBlock)(id object, Ivar ivar, void *p); ///< unsigend char を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^intBlock)(id object, Ivar ivar, void *p); ///< int を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^uIntBlock)(id object, Ivar ivar, void *p); ///< unsigend int を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^shortBlock)(id object, Ivar ivar, void *p); ///< short を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^uShortBlock)(id object, Ivar ivar, void *p); ///< unsigend short を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^longBlock)(id object, Ivar ivar, void *p); ///< long を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^uLongBlock)(id object, Ivar ivar, void *p); ///< unsigend long を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^longlongBlock)(id object, Ivar ivar, void *p); ///< long long を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^uLonglongBlock)(id object, Ivar ivar, void *p); ///< unsigend long long を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^floatBlock)(id object, Ivar ivar, void *p); ///< float を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^doubleBlock)(id object, Ivar ivar, void *p); ///< double を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^boolBlock)(id object, Ivar ivar, void *p); ///< bool を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^stringBlock)(id object, Ivar ivar, void *p); ///< char*(c言語文字列) を文字列化するためのblock.
@property(nonatomic,copy) NSString *(^pointerBlock)(id object, Ivar ivar, void *p); ///< ポインタを文字列化するためのblock.
@property(nonatomic,copy) NSString *(^otherBlock)(id object, Ivar ivar, void *p); ///< 型情報不明なデータを文字列化するためのblock.
@property(nonatomic,readonly) NSMutableDictionary *idBlocks;     ///< 構造体を文字列化するためのblockの辞書. 構造体名をkey、対応するblockをvalueとするデータを格納する.
@property(nonatomic,readonly) NSMutableDictionary *structBlocks; ///< 構造体を文字列化するためのblockの辞書. 構造体名をkey、対応するblockをvalueとするデータを格納する.
@property(nonatomic,copy) NSString *(^formatBlock)(id object, NSArray *elements);  ///< インスタンス変数情報の配列を文字列化するためのblock.

+ (SIDescriptionBuilder *)defaultBuilder;
- (NSString *)buildDescription:(id)object;
- (NSString *)buildDescription:(id)object customFormatter:(NSString *(^)(void *p))customFormatter;

@end

#endif
