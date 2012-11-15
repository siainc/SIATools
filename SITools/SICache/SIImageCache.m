//
//  SIImageCache.m
//  SICache
//
//  Created by KUROSAKI Ryota on 2012/05/31.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIImageCache.h"
#import "SIHash.h"
#import "SIConnectionOperation.h"

@implementation SIImageCache

+ (SIImageCache*)sharedCache
{
    static dispatch_once_t onceToken;
    static SIImageCache *_sharedCache;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[SIImageCache alloc] initWithName:@"SIImageCacheShared"];
    });
    return _sharedCache;
}

- (id)cacheImageForURL:(NSURL *)URL receiver:(void (^)(NSString *path))receiver
{
    __weak id observer = [self cacheImageForKey:URL.absoluteString receiver:receiver];
    if (observer) {
        SIConnectionOperation *operation = [[SIConnectionOperation alloc] initWithURL:URL];
        operation.storeToDisk = YES;
        operation.completionConnection = ^(SIConnectionOperation *operation) {
            if (operation.errorOccurd) {
                
            }
            else {
                [self moveFile:operation.downloadedFilePath forKey:URL.absoluteString];
            }
        };
        [NSOperationQueue.mainQueue addOperation:operation];
    }
    return observer;
}

- (id)cacheImageForKey:(NSString *)key receiver:(void (^)(NSString *path))receiver
{
    NSString *cachePath = [self cachePathForKey:key];
    __weak id observer = nil;
    if (cachePath) {
        receiver(cachePath);
    }
    else {
        observer = [NSNotificationCenter.defaultCenter addObserverForName:SIFileCacheSetNotification object:self queue:nil usingBlock:^(NSNotification *note) {
            if ([key isEqualToString:[note.userInfo valueForKey:SIFileCacheSetKeyKey]]) {
                receiver([note.userInfo valueForKey:SIFileCacheSetPathKey]);
                [NSNotificationCenter.defaultCenter removeObserver:observer];
            }
        }];
    }
    return observer;
}

@end
