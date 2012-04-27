//
//  SIAWeakReference.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/20.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAWeakReference.h"

@implementation SIAWeakReference

+ (SIAWeakReference *)referenceWithObject:(id __weak)object
{
    return [[SIAWeakReference alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id __weak)object
{
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

@end
