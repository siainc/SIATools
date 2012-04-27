//
//  SIAObserverAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/31.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAObserverAction.h"

#import <objc/runtime.h>
#import "NSObject+SIATools.h"

#define SIAObserverActionListKey "SIAObserverActionListKey"

@implementation SIAObserverAction

- (id)initWithKeyPath:(NSString *)keyPath
              options:(NSKeyValueObservingOptions)options
              context:(void *)context
                queue:(NSOperationQueue *)queue
           usingBlock:(void (^)(NSDictionary *change))block
{
    self = [super init];
    if (self) {
        _keyPath = keyPath;
        _options = options;
        _context = context;
        _queue = queue;
        _block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (self.queue && self.queue != [NSOperationQueue currentQueue]) {
        [self.queue addOperationWithBlock:^{
            _block(change);
        }];
    }
    else {
        _block(change);
    }
}

@end

@implementation NSObject (NSObjectSIAObserverActionExtionsions)

- (NSMutableArray *)sia_observerActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self sia_associatedObjectForKey:SIAObserverActionListKey];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self sia_setAssociatedObject:actions forKey:SIAObserverActionListKey];
        }
    }
    return actions;
}

- (SIAObserverAction *)sia_addActionForKeyPath:(NSString *)keyPath
                                       options:(NSKeyValueObservingOptions)options
                                       context:(void *)context
                                         queue:(NSOperationQueue *)queue
                                    usingBlock:(void (^)(NSDictionary *change))block
{
    SIAObserverAction *action = [[SIAObserverAction alloc] initWithKeyPath:keyPath
                                                                   options:options
                                                                   context:context
                                                                     queue:queue
                                                                usingBlock:block];
    [self addObserver:action forKeyPath:keyPath options:options context:context];
    [[self sia_observerActions] addObject:action];
    return action;
}

- (void)sia_removeAction:(SIAObserverAction *)action
              forKeyPath:(NSString *)keyPath
                 context:(void *)context
{
    [self removeObserver:action forKeyPath:keyPath context:context];
    [[self sia_observerActions] removeObject:action];
}

@end