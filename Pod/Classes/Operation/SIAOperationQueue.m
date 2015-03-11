//
//  SIAOperationQueue.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAOperationQueue.h"

#import "SIABaseOperation.h"

typedef enum SIAOperationQueuePoolCondition {
    SIAOperationQueuePoolConditionEmpty = 0,
    SIAOperationQueuePoolConditionContain = 1
} SIAOperationQueuePoolCondition;

@interface SIAOperationQueue ()
@property (nonatomic, strong) NSMutableArray *operationPool;
@property (nonatomic, strong) NSConditionLock *poolLock;
@end

@implementation SIAOperationQueue

- (id)init
{
    self = [super init];
    if (self) {
        _operationPool = [NSMutableArray arrayWithCapacity:10];
        _poolLock = [[NSConditionLock alloc] initWithCondition:SIAOperationQueuePoolConditionEmpty];
        [self addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)innteruptOperation:(NSOperation *)operation
{
    [self attachOperation:operation];
    [self.poolLock lock];
    [self.operationPool insertObject:operation atIndex:0];
    [self.poolLock unlockWithCondition:SIAOperationQueuePoolConditionContain];
    
    if (self.operationCount > 0) {
        for (NSOperation <SIAOperationQueueRetryProtocol> *op in self.operations) {
            if ([op respondsToSelector:@selector(interrupt)]) {
                [op interrupt];
            }
            else {
                [op cancel];
            }
        }
    }
    [self startOperationIfNeeded];
}

- (void)insertOperationAtFirst:(NSOperation *)operation
{
    [self attachOperation:operation];
    [self.poolLock lock];
    [self.operationPool insertObject:operation atIndex:0];
    [self.poolLock unlockWithCondition:SIAOperationQueuePoolConditionContain];
    [self startOperationIfNeeded];
}

- (void)addOperationAtLast:(NSOperation *)operation
{
    [self attachOperation:operation];
    [self.poolLock lock];
    [self.operationPool addObject:operation];
    [self.poolLock unlockWithCondition:SIAOperationQueuePoolConditionContain];
    [self startOperationIfNeeded];
}

- (void)cancelAllOperations
{
    if ([self.poolLock tryLockWhenCondition:SIAOperationQueuePoolConditionContain]) {
        for (NSOperation *o in self.operationPool) {
            [self detattachOperation:o];
            if (!o.isCancelled) {
                [o cancel];
            }
        }
        [self.operationPool removeAllObjects];
        [self.poolLock unlockWithCondition:SIAOperationQueuePoolConditionEmpty];
    }
    [super cancelAllOperations];
}

- (void)attachOperation:(NSOperation *)operation
{
    [operation addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)detattachOperation:(NSOperation *)operation
{
    [operation removeObserver:self forKeyPath:@"finished"];
}

- (void)startOperationIfNeeded
{
    if ([self.poolLock tryLockWhenCondition:SIAOperationQueuePoolConditionContain]) {
        NSOperation *o = [self.operationPool objectAtIndex:0];
        while (!o.isReady) {
            [self.operationPool removeObject:o];
            if (self.operationPool.count > 0) {
                o = [self.operationPool objectAtIndex:0];
            }
            else {
                o = nil;
                break;
            }
        }
        if (o != nil && self.operationCount == 0) {
            [self addOperation:o];
            [self.operationPool removeObject:o];
        }
        SIAOperationQueuePoolCondition condition = (self.operationPool.count == 0) ? SIAOperationQueuePoolConditionEmpty :
        SIAOperationQueuePoolConditionContain;
        [self.poolLock unlockWithCondition:condition];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"finished"]) {
        NSNumber *n = [change valueForKey:NSKeyValueChangeNewKey];
        if (n.boolValue) {
            NSOperation <SIAOperationQueueRetryProtocol> *operation = object;
            [self detattachOperation:operation];
            [self.poolLock lock];
            [self.operationPool removeObject:operation];
            SIAOperationQueuePoolCondition condition = (self.operationPool.count == 0) ? SIAOperationQueuePoolConditionEmpty :
            SIAOperationQueuePoolConditionContain;
            [self.poolLock unlockWithCondition:condition];
            if (operation.isCancelled) {
                if ([operation respondsToSelector:@selector(retryOperation)]) {
                    NSOperation *retryOperation = [operation performSelector:@selector(retryOperation)];
                    if (retryOperation) {
                        [self attachOperation:retryOperation];
                        [self.poolLock lock];
                        [self.operationPool addObject:retryOperation];
                        [self.poolLock unlockWithCondition:SIAOperationQueuePoolConditionContain];
                    }
                }
            }
            [self startOperationIfNeeded];
        }
    }
    else if ([keyPath isEqualToString:@"operationCount"]) {
        NSNumber *n = [change valueForKey:NSKeyValueChangeNewKey];
        if (n.integerValue == 0) {
            [self startOperationIfNeeded];
        }
    }
}

@end
