//
//  SIADescriptionBuilder.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/08/31.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIADescriptionBuilder : NSObject

@property (nonatomic, readonly) NSMutableDictionary *idBlocks; ///< オブジェクトを文字列化するためのblockの辞書. 構造体名をkey、対応するblockをvalueとするデータを格納する.
@property (nonatomic, readonly) NSMutableDictionary *structBlocks; ///< 構造体を文字列化するためのblockの辞書. 構造体名をkey、対応するblockをvalueとするデータを格納する.
@property (nonatomic, copy) NSString *(^formatBlock)(id object, NSArray *elements); ///< インスタンス変数情報の配列を文字列化するためのblock.

+ (SIADescriptionBuilder *)defaultBuilder;
- (NSString *)buildDescription:(id)object;
- (NSString *)buildDescription:(id)object customFormatter:(NSString * (^)(NSString *name, NSString *type, void *address))customFormatter;

@end
