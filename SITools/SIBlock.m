//
//  SIBlock.m
//  SITools
//
//  Created by Kurosaki Ryota on 12/05/01.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import "SIBlock.h"

void SIRunBlockOnMainThread(void(^block)())
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:block];
}

void SIRunBlockOnMainThreadAfterDelay(void(^block)(), NSTimeInterval delay)
{
    [[NSOperationQueue mainQueue] performSelector:@selector(addOperationWithBlock:) withObject:[block copy] afterDelay:delay];
}

void SIRunBlockInBackground(void(^block)())
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:block];
}

void SIRunBlockInBackgroundAfterDelay(void(^block)(), NSTimeInterval delay)
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue performSelector:@selector(addOperationWithBlock:) withObject:[block copy] afterDelay:delay];
}
