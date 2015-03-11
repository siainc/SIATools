//
//  SIABlockOperation.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIABlockOperation.h"

@interface SIABlockOperation ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation SIABlockOperation

+ (instancetype)blockOperationWithBlock:(void (^)(void))block
{
    SIABlockOperation *operation = [[SIABlockOperation alloc] init];
    [operation.blocks addObject:[block copy]];
    return operation;
}

- (id)init
{
    self = [super init];
    if (self) {
        _blocks = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)addExecutionBlock:(void (^)(void))block
{
    [self.blocks addObject:block];
}

- (NSArray *)executionBlocks
{
    return [NSArray arrayWithArray:self.blocks];
}

- (void)start
{
    if ([self isFinished] || [self isCancelled]) {
        return;
    }
    if (![self isReady] || [self isExecuting]) {
        @throw NSGenericException;
    }
    
    [self setupExecuting];
    
    [self.blocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        void (^executionBlock)() = obj;
        executionBlock();
        if (self.isCancelled || self.isFinished) {
            *stop = YES;
        }
    }];
}

- (void)main
{
}

@end
