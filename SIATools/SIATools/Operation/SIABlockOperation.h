//
//  SIABlockOperation.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "SIABaseOperation.h"

@interface SIABlockOperation :   SIABaseOperation

+ (instancetype)blockOperationWithBlock:(void (^)(void))block;
- (void)addExecutionBlock:(void (^)(void))block;
- (NSArray *)executionBlocks;

@end
