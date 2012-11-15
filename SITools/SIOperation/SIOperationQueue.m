//
//  SIOperationQueue.m
//  SIQueue
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIOperationQueue.h"
#import "SIBaseOperation.h"

typedef enum SIOperationQueuePoolCondition {
    SIOperationQueuePoolConditionEmpty = 0,
    SIOperationQueuePoolConditionContain = 1
} SIOperationQueuePoolCondition;

@interface SIOperationQueue ()
@property(nonatomic,strong) NSMutableArray *operationPool;
@property(nonatomic,strong) NSConditionLock *poolLock;
@end

@implementation SIOperationQueue

- (id)init
{
    self = [super init];
    if (self) {
        _operationPool = [NSMutableArray arrayWithCapacity:10];
        _poolLock = [[NSConditionLock alloc] initWithCondition:SIOperationQueuePoolConditionEmpty];
        [self addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)innteruptOperation:(NSOperation *)operation
{
    [self attachOperation:operation];
    [self.poolLock lock];
    [self.operationPool insertObject:operation atIndex:0];
    [self.poolLock unlockWithCondition:SIOperationQueuePoolConditionContain];
    
    if (self.operationCount > 0) {
        for (NSOperation<SIOperationQueueRetryProtocol> *op in self.operations) {
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
    [self.poolLock unlockWithCondition:SIOperationQueuePoolConditionContain];
    [self startOperationIfNeeded];
}

- (void)addOperationAtLast:(NSOperation *)operation
{
    [self attachOperation:operation];
    [self.poolLock lock];
    [self.operationPool addObject:operation];
    [self.poolLock unlockWithCondition:SIOperationQueuePoolConditionContain];
    [self startOperationIfNeeded];
}

- (void)cancelAllOperations
{
    if ([self.poolLock tryLockWhenCondition:SIOperationQueuePoolConditionContain]) {
        for (NSOperation *o in self.operationPool) {
            [self detattachOperation:o];
            if (!o.isCancelled) {
                [o cancel];
            }
        }
        [self.operationPool removeAllObjects];
        [self.poolLock unlockWithCondition:SIOperationQueuePoolConditionEmpty];
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
    if ([self.poolLock tryLockWhenCondition:SIOperationQueuePoolConditionContain]) {
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
        SIOperationQueuePoolCondition condition = (self.operationPool.count == 0) ? SIOperationQueuePoolConditionEmpty : SIOperationQueuePoolConditionContain;
        [self.poolLock unlockWithCondition:condition];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"finished"]) {
        NSNumber *n = [change valueForKey:NSKeyValueChangeNewKey];
        if (n.boolValue) {
            NSOperation<SIOperationQueueRetryProtocol> *operation = object;
            [self detattachOperation:operation];
            [self.poolLock lock];
            [self.operationPool removeObject:operation];
            SIOperationQueuePoolCondition condition = (self.operationPool.count == 0) ? SIOperationQueuePoolConditionEmpty : SIOperationQueuePoolConditionContain;
            [self.poolLock unlockWithCondition:condition];
            if (operation.isCancelled) {
                if ([operation respondsToSelector:@selector(retryOperation)]) {
                    NSOperation *retryOperation = [operation performSelector:@selector(retryOperation)];
                    if (retryOperation) {
                        [self attachOperation:retryOperation];
                        [self.poolLock lock];
                        [self.operationPool addObject:retryOperation];
                        [self.poolLock unlockWithCondition:SIOperationQueuePoolConditionContain];
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
