//
//  SIAObserverAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/31.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAObserverAction.h"

#import <objc/runtime.h>
#import "SIAToolsLogger.h"
#import "NSArray+SIATools.h"
#import "NSObject+SIATools.h"

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
        _queue   = queue;
        _block   = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSOperationQueue *queue = self.queue;
    if (queue == nil) {
        queue = [NSOperationQueue currentQueue];
    }
    
    [queue addOperationWithBlock:^{
        _block(change);
    }];
}

@end

@implementation NSObject (NSObjectSIAObserverActionExtionsions)

- (NSMutableArray *)observerActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = [self associatedObjectForKey:@"SIAObserverActionList"];
        if (actions == nil) {
            actions = @[].mutableCopy;
            [self setAssociatedObject:actions forKey:@"SIAObserverActionList"];
        }
    }
    return actions;
}

- (SIAObserverAction *)addActionForKeyPath:(NSString *)keyPath
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
    [self.observerActions addObject:action];
    return action;
}

- (void)removeAction:(SIAObserverAction *)action forKeyPath:(NSString *)keyPath context:(void *)context
{
    [self removeObserver:action forKeyPath:keyPath context:context];
    [self.observerActions removeObject:action];
}

@end