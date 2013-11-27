//
//  SIAOperationQueue.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAOperationQueue :   NSOperationQueue

- (void)innteruptOperation:(NSOperation *)operation;
- (void)insertOperationAtFirst:(NSOperation *)operation;
- (void)addOperationAtLast:(NSOperation *)operation;

@end

@protocol SIAOperationQueueRetryProtocol <NSObject>
- (void)interrupt;
- (NSOperation *)retryOperation;
@end