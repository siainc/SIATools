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

#import "SIAToolsLogger.h"

@interface SIABlockOperation ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation SIABlockOperation

+ (instancetype)blockOperationWithBlock:(void (^)(void))block
{
    SIAToolsDLog(@">>block=%@", block);
    SIABlockOperation *operation = [[SIABlockOperation alloc] init];
    [operation.blocks addObject:[block copy]];
    SIAToolsDLog(@"<<%@", operation);
    return operation;
}

- (id)init
{
    SIAToolsDLog(@">>");
    self = [super init];
    if (self) {
        _blocks = [NSMutableArray arrayWithCapacity:1];
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

- (void)addExecutionBlock:(void (^)(void))block
{
    SIAToolsDLog(@">>block=%@", block);
    [self.blocks addObject:block];
    SIAToolsDLog(@"<<");
}

- (NSArray *)executionBlocks
{
    return [NSArray arrayWithArray:self.blocks];
}

- (void)start
{
    SIAToolsDLog(@">>");
    if ([self isFinished] || [self isCancelled]) {
        SIAToolsDLog(@"<<");
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
    SIAToolsDLog(@"<<");
}

- (void)main
{
}

@end
