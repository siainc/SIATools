//
//  NSObject+SITools.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/04/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSObject+SITools.h"

@implementation NSObject (SITools)
@dynamic notNullObject;

- (id)notNullObject;
{
    if ([self isEqual:[NSNull null]]) {
        return nil;
    }
    return self;
}

- (void)runBlock:(void (^)())block
{
    block();
}

- (void)runBlockOnMainThread:(void (^)())block waitUntilDone:(BOOL)wait
{
    [self performSelectorOnMainThread:@selector(runBlock:) withObject:[block copy] waitUntilDone:wait];
}

- (void)runBlock:(void (^)())block afterDelay:(NSTimeInterval)timeInterval
{
    [self performSelector:@selector(runBlock:) withObject:[block copy] afterDelay:timeInterval];
}
     
- (void)runBlockInBackground:(void (^)())block
{
    [self performSelectorInBackground:@selector(runBlock:) withObject:[block copy]];
}

@end
