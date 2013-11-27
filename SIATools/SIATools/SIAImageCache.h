//
//  SIAImageCache.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/05/31.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAFileCache.h"

@interface SIAImageCache :   SIAFileCache

+ (SIAImageCache *)sharedCache;
- (id)cacheImageForURL:(NSURL *)URL receiver:(void (^)(NSString *path))receiver;
- (id)cacheImageForKey:(NSString *)key receiver:(void (^)(NSString *path))receiver;

@end
