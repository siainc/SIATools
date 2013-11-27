//
//  SIAFileCache.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/09/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAFileCache.h"
#import "SIAHash.h"
#import "NSData+SIATools.h"
#import "SIAToolsLogger.h"

NSString *SIAFileCacheSetNotification = @"SIAFileCacheSetNotification";
NSString *SIAFileCacheSetKeyKey       = @"SIAFileCacheSetKeyKey";
NSString *SIAFileCacheSetPathKey      = @"SIAFileCacheSetPathKey";
NSString *SIAFileCacheSetDataKey      = @"SIAFileCacheSetDataKey";

@interface SIAFileCache ()
@property (nonatomic, copy) NSString *cacheRootPath;
@end

@implementation SIAFileCache
@dynamic cachesPath;

+ (SIAFileCache *)sharedCache
{
    static dispatch_once_t onceToken;
    static SIAFileCache    *_sharedCache;
    dispatch_once(&onceToken, ^{
        SIAToolsDLog(@"sharedCacheの初期化");
        _sharedCache = [[SIAFileCache alloc] initWithName:@"SIAFileCacheShared"];
    });
    return _sharedCache;
}

- (instancetype)initWithName:(NSString *)name
{
    SIAToolsDLog(@">>name=%@", name);
    self = [super init];
    if (self) {
        _name          = name;
        _cacheRootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    SIAToolsDLog(@"<<%@", self);
    return self;
}

- (NSString *)cachesPath
{
    SIAToolsVLog(@">>");
    NSString *cachesPath = [self.cacheRootPath stringByAppendingPathComponent:self.name];
    SIAToolsVLog(@"<<%@", cachesPath);
    return cachesPath;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    SIAToolsVLog(@">>key=%@", key);
    NSString *filePath  = [self filePathForKey:key];
    NSString *cachePath = nil;
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        cachePath = filePath;
    }
    SIAToolsVLog(@"<<%@", cachePath);
    return cachePath;
}

- (NSData *)cacheDataForKey:(NSString *)key
{
    SIAToolsVLog(@">>key=%@", key);
    NSString *cachePath = [self cachePathForKey:key];
    NSData   *cacheData = nil;
    if (cachePath) {
        cacheData = [NSData dataWithContentsOfFile:cachePath];
    }
    SIAToolsVLog(@"<<%@", [cacheData lightDescription]);
    return cacheData;
}

- (id)cacheForKey:(NSString *)key receiver:(void (^)(NSString *path, NSData *data))receiver
{
    SIAToolsDLog(@">>key=%@, receiver=%@", key, receiver);
    NSString  *cachePath = [self cachePathForKey:key];
    __weak id observer   = nil;
    if (cachePath) {
        SIAToolsDLog(@"キャッシュ発見");
        receiver(cachePath, nil);
    }
    else {
        SIAToolsDLog(@"キャッシュが見つからないのでNotificationの登録を実施");
        observer = [NSNotificationCenter.defaultCenter addObserverForName:SIAFileCacheSetNotification object:self queue:nil usingBlock:^(
                                                                                                                                         NSNotification *note) {
            if ([key isEqualToString:[note.userInfo valueForKey:SIAFileCacheSetKeyKey]]) {
                receiver([note.userInfo valueForKey:SIAFileCacheSetPathKey], [note.userInfo valueForKey:SIAFileCacheSetDataKey]);
                [self removeObserver:observer];
            }
        }];
    }
    SIAToolsDLog(@"<<%@", observer);
    return observer;
}

- (void)removeObserver:(id)observer
{
    SIAToolsDLog(@">>observer=%@", observer);
    [NSNotificationCenter.defaultCenter removeObserver:observer];
    SIAToolsDLog(@"<<");
}

- (void)saveData:(NSData *)data forKey:(NSString *)key
{
    SIAToolsDLog(@">>data=%@, key=%@", [data lightDescription], key);
    NSString *toPath = [self filePathForKey:key];
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath.stringByDeletingLastPathComponent
                              withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:[self filePathForKey:key] atomically:YES];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              key, SIAFileCacheSetKeyKey,
                              toPath, SIAFileCacheSetPathKey,
                              data, SIAFileCacheSetDataKey, nil];
    [NSNotificationCenter.defaultCenter postNotificationName:SIAFileCacheSetNotification object:self userInfo:userInfo];
    SIAToolsDLog(@"<<");
}

- (void)moveFile:(NSString *)path forKey:(NSString *)key
{
    SIAToolsDLog(@">>path=%@, key=%@", path, key);
    NSError  *error  = nil;
    NSString *toPath = [self filePathForKey:key];
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath.stringByDeletingLastPathComponent
                              withIntermediateDirectories:YES attributes:nil error:&error];
    error = nil;
    [NSFileManager.defaultManager moveItemAtPath:path toPath:[self filePathForKey:key] error:&error];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              key, SIAFileCacheSetKeyKey,
                              toPath, SIAFileCacheSetPathKey, nil];
    [NSNotificationCenter.defaultCenter postNotificationName:SIAFileCacheSetNotification object:self userInfo:userInfo];
    SIAToolsDLog(@"<<");
}

- (NSString *)filePathForKey:(NSString *)key
{
    SIAToolsDLog(@">>key=%@", key);
    NSString *md5       = key.md5Hash;
    NSString *imagePath = self.cachesPath;
    imagePath = [imagePath stringByAppendingPathComponent:[md5 substringToIndex:2]];
    imagePath = [imagePath stringByAppendingPathComponent:[md5 substringFromIndex:2]];
    SIAToolsDLog(@"<<%@", imagePath);
    return imagePath;
}

- (void)touchCacheForKey:(NSString *)key
{
    SIAToolsDLog(@">>key=%@", key);
    NSString *cachePath = [self cachePathForKey:key];
    if (cachePath) {
        [self touchFilePath:cachePath];
    }
    SIAToolsDLog(@"<<");
}

- (void)touchFilePath:(NSString *)path
{
    SIAToolsDLog(@">>path=%@", path);
    NSDictionary *attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] mutableCopy];
    [attributes setValue:[NSDate date] forKey:NSFileModificationDate];
    [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:path error:nil];
    SIAToolsDLog(@"<<");
}

- (void)cleanFileOlderThan:(NSDate *)date
{
    SIAToolsDLog(@">>date=%@", date);
    NSFileManager *fm            = [NSFileManager defaultManager];
    NSString      *directoryPath = self.cachesPath;
    NSInteger     removeCount    = 0;
    for (NSString *path in[fm enumeratorAtPath : directoryPath]) {
        NSString *imagePath  = [directoryPath stringByAppendingPathComponent:path];
        BOOL     isDirectory = NO;
        [fm fileExistsAtPath:imagePath isDirectory:&isDirectory];
        if (!isDirectory) {
            NSDictionary *attributes = [fm attributesOfItemAtPath:imagePath error:nil];
            if (date == [date laterDate:[attributes fileModificationDate]]) {
                [fm removeItemAtPath:imagePath error:nil];
                removeCount++;
            }
        }
    }
    SIAToolsDLog(@"%d個のファイルを削除", removeCount);
    SIAToolsDLog(@"<<");
}

@end
