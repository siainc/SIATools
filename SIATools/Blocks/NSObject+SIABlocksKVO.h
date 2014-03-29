//
//  NSObject+SIABlocksKVO.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/31.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIAObserverAction;

@interface NSObject (SIABlocksKVO)

- (SIAObserverAction *)sia_addActionForKeyPath:(NSString *)keyPath
                                       options:(NSKeyValueObservingOptions)options
                                         queue:(NSOperationQueue *)queue
                                    usingBlock:(void(^) (NSDictionary * change))block;
- (void)sia_removeAction:(SIAObserverAction *)action
              forKeyPath:(NSString *)keyPath;

@end