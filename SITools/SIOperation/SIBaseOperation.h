//
//  SIBaseOperation.h
//  SIOperation
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIBaseOperation : NSOperation

@property(nonatomic,assign,getter=isConcurrent) BOOL concurrent;
@property(nonatomic,assign,getter=isReady) BOOL ready;
@property(nonatomic,assign,getter=isExecuting) BOOL executing;
@property(nonatomic,assign,getter=isFinished) BOOL finished;
@property(nonatomic,assign,getter=isCancelled) BOOL cancelled;

- (void)setupExecuting;
- (void)setupFinished;
- (void)setupCancelled;

@end
