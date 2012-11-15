//
//  SIImageCache.h
//  SICache
//
//  Created by KUROSAKI Ryota on 2012/05/31.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIFileCache.h"

@interface SIImageCache : SIFileCache

+ (SIImageCache*)sharedCache;
- (id)cacheImageForURL:(NSURL *)URL receiver:(void (^)(NSString *path))receiver;
- (id)cacheImageForKey:(NSString *)key receiver:(void (^)(NSString *path))receiver;

@end
