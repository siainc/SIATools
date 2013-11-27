//
//  SIAObserverAction.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/31.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAObserverAction :   NSObject

@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
@property (nonatomic, assign, readonly) void                       *context;
@property (nonatomic, weak, readonly) NSOperationQueue             *queue;
@property (nonatomic, copy, readonly) void (^block)(NSDictionary *change);

- (id)initWithKeyPath:(NSString *)keyPath
              options:(NSKeyValueObservingOptions)options
              context:(void *)context
                queue:(NSOperationQueue *)queue
           usingBlock:(void(^) (NSDictionary * change))block;

@end

@interface NSObject (NSObjectSIAObserverActionExtionsions)

- (SIAObserverAction *)addActionForKeyPath:(NSString *)keyPath
                                   options:(NSKeyValueObservingOptions)options
                                   context:(void *)context
                                     queue:(NSOperationQueue *)queue
                                usingBlock:(void(^) (NSDictionary * change))block;
- (void)removeAction:(SIAObserverAction *)action forKeyPath:(NSString *)keyPath context:(void *)context;

@end