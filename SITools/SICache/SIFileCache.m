//
//  SIFileCache.m
//  SICache
//
//  Created by KUROSAKI Ryota on 2012/09/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIFileCache.h"
#import "SIHash.h"

NSString *SIFileCacheSetNotification = @"SIFileCacheSetNotification";
NSString *SIFileCacheSetKeyKey = @"SIFileCacheSetKeyKey";
NSString *SIFileCacheSetPathKey = @"SIFileCacheSetPathKey";
NSString *SIFileCacheSetDataKey = @"SIFileCacheSetDataKey";

@interface SIFileCache ()
@property(nonatomic,copy) NSString *cacheRootPath;
@end

@implementation SIFileCache
@dynamic cachesPath;

+ (SIFileCache*)sharedCache
{
    static dispatch_once_t onceToken;
    static SIFileCache *_sharedCache;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[SIFileCache alloc] initWithName:@"SIFileCacheShared"];
    });
    return _sharedCache;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _cacheRootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return self;
}

- (NSString *)cachesPath
{
    NSString *cachesPath = [self.cacheRootPath stringByAppendingPathComponent:self.name];
    return cachesPath;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    NSString *filePath = [self filePathForKey:key];
    NSString *cachePath = nil;
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        cachePath = filePath;
    }
    return cachePath;
}

- (NSData *)cacheDataForKey:(NSString *)key
{
    NSString *cachePath = [self cachePathForKey:key];
    NSData *cacheData = nil;
    if (cachePath) {
        cacheData = [NSData dataWithContentsOfFile:cachePath];
    }
    return cacheData;
}

- (id)cacheForKey:(NSString *)key receiver:(void (^)(NSString *path, NSData *data))receiver
{
    NSString *cachePath = [self cachePathForKey:key];
    __weak id observer = nil;
    if (cachePath) {
        receiver(cachePath, nil);
    }
    else {
        observer = [NSNotificationCenter.defaultCenter addObserverForName:SIFileCacheSetNotification object:self queue:nil usingBlock:^(NSNotification *note) {
            if ([key isEqualToString:[note.userInfo valueForKey:SIFileCacheSetKeyKey]]) {
                receiver([note.userInfo valueForKey:SIFileCacheSetPathKey], [note.userInfo valueForKey:SIFileCacheSetDataKey]);
                [self removeObserver:observer];
            }
        }];
    }
    return observer;
}

- (void)removeObserver:(id)observer
{
    [NSNotificationCenter.defaultCenter removeObserver:observer];
}

- (void)saveData:(NSData *)data forKey:(NSString *)key
{
    NSString *toPath = [self filePathForKey:key];
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath.stringByDeletingLastPathComponent
                              withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:[self filePathForKey:key] atomically:YES];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              key, SIFileCacheSetKeyKey,
                              toPath, SIFileCacheSetPathKey,
                              data, SIFileCacheSetDataKey, nil];
    [NSNotificationCenter.defaultCenter postNotificationName:SIFileCacheSetNotification object:self userInfo:userInfo];
}

- (void)moveFile:(NSString *)path forKey:(NSString *)key
{
    NSError *error = nil;
    NSString *toPath = [self filePathForKey:key];
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath.stringByDeletingLastPathComponent
                              withIntermediateDirectories:YES attributes:nil error:&error];
    error = nil;
    [NSFileManager.defaultManager moveItemAtPath:path toPath:[self filePathForKey:key] error:&error];

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              key, SIFileCacheSetKeyKey,
                              toPath, SIFileCacheSetPathKey, nil];
    [NSNotificationCenter.defaultCenter postNotificationName:SIFileCacheSetNotification object:self userInfo:userInfo];
}

- (NSString *)filePathForKey:(NSString *)key
{
    NSString *md5 = key.md5Hash;
    NSString *imagePath = self.cachesPath;
    imagePath = [imagePath stringByAppendingPathComponent:[md5 substringToIndex:2]];
    imagePath = [imagePath stringByAppendingPathComponent:[md5 substringFromIndex:2]];
    return imagePath;
}

- (void)touchCacheForKey:(NSString *)key
{
    NSString *cachePath = [self cachePathForKey:key];
    if (cachePath) {
        [self touchFilePath:cachePath];
    }
}

- (void)touchFilePath:(NSString *)path
{
    NSDictionary *attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] mutableCopy];
    [attributes setValue:[NSDate date] forKey:NSFileModificationDate];
    [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:path error:nil];
}

- (void)cleanFileOlderThan:(NSDate*)date
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directoryPath = self.cachesPath;
    for (NSString *path in [fm enumeratorAtPath:directoryPath]) {
        NSString *imagePath = [directoryPath stringByAppendingPathComponent:path];
        BOOL isDirectory = NO;
        [fm fileExistsAtPath:imagePath isDirectory:&isDirectory];
        if (!isDirectory) {
            NSDictionary *attributes = [fm attributesOfItemAtPath:imagePath error:nil];
            if (date == [date laterDate:[attributes fileModificationDate]]) {
                [fm removeItemAtPath:imagePath error:nil];
            }
        }
    }
}

@end
