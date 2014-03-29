//
//  SIABlockProtocol.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/13.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import "SIAExpandableObject.h"

@interface SIABlockProtocol : SIAExpandableObject

+ (instancetype)createSubclassInstanceForProtocol:(Protocol *)protocol;

+ (void)addMethodWithSelector:(SEL)selector block:(id)block;
+ (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block;

- (void)addMethodWithSelector:(SEL)selector block:(id)block;
- (void)addMethodWithSelector:(SEL)selector protocol:(Protocol *)protocol block:(id)block;

@end

@interface NSObject (SIABlocksProtocol)

- (SIABlockProtocol *)sia_blockProtocolForProtocol:(Protocol *)protocol;
- (SIABlockProtocol *)sia_blockDelegate;
- (SIABlockProtocol *)sia_blockDataSource;

- (void)sia_implementProtocol:(Protocol *)protocol
               setterSelector:(SEL)setterSelector
                   usingBlock:(void(^) (SIABlockProtocol * protocol))block;

@end
