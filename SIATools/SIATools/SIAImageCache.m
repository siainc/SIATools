//
//  SIAImageCache.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/05/31.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAImageCache.h"
#import "SIAHash.h"
#import "SIAConnectionOperation.h"
#import "SIAToolsLogger.h"

@implementation SIAImageCache

+ (SIAImageCache *)sharedCache
{
    SIAToolsVLog(@">>");
    static dispatch_once_t onceToken;
    static SIAImageCache   *_sharedCache;
    dispatch_once(&onceToken, ^{
        SIAToolsDLog(@"_sharedCacheの初期化");
        _sharedCache = [[SIAImageCache alloc] initWithName:@"SIAImageCacheShared"];
    });
    SIAToolsVLog(@"<<%@", _sharedCache);
    return _sharedCache;
}

- (id)cacheImageForURL:(NSURL *)URL receiver:(void (^)(NSString *path))receiver
{
    SIAToolsDLog(@">>URL=%@, receiver=%@", URL, receiver);
    __weak id observer = [self cacheImageForKey:URL.absoluteString receiver:receiver];
    if (observer) {
        SIAToolsDLog(@"cacheImageが見つからなかったので、通信して取得する");
        SIAConnectionOperation *operation = [[SIAConnectionOperation alloc] initWithURL:URL];
        operation.storeToDisk = YES;
        operation.completion  = ^(SIAConnectionOperation *operation) {
            if (operation.errorOccurd) {
            }
            else {
                [self moveFile:operation.downloadedFilePath forKey:URL.absoluteString];
            }
        };
        [[NSOperationQueue mainQueue] addOperation:operation];
    }
    SIAToolsDLog(@"<<%@", observer);
    return observer;
}

- (id)cacheImageForKey:(NSString *)key receiver:(void (^)(NSString *path))receiver
{
    SIAToolsDLog(@">>key=%@, receiver=%@", key, receiver);
    NSString  *cachePath = [self cachePathForKey:key];
    __weak id observer   = nil;
    if (cachePath) {
        SIAToolsDLog(@"キャッシュ発見");
        receiver(cachePath);
    }
    else {
        SIAToolsDLog(@"キャッシュが見つからなかった");
        observer = [NSNotificationCenter.defaultCenter addObserverForName:SIAFileCacheSetNotification object:self queue:nil usingBlock:^(
                                                                                                                                         NSNotification *note) {
            if ([key isEqualToString:[note.userInfo valueForKey:SIAFileCacheSetKeyKey]]) {
                receiver([note.userInfo valueForKey:SIAFileCacheSetPathKey]);
                [NSNotificationCenter.defaultCenter removeObserver:observer];
            }
        }];
    }
    SIAToolsDLog(@"<<%@", observer);
    return observer;
}

@end
