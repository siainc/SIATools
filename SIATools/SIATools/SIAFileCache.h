//
//  SIAFileCache.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/09/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SIAFileCacheSetNotification;
extern NSString *SIAFileCacheSetKeyKey;
extern NSString *SIAFileCacheSetPathKey;
extern NSString *SIAFileCacheSetDataKey;

@interface SIAFileCache :   NSObject

@property (nonatomic, copy) NSString     *name;
@property (nonatomic, readonly) NSString *cachesPath;

+ (SIAFileCache *)sharedCache;
- (instancetype)initWithName:(NSString *)name;
- (NSString *)cachePathForKey:(NSString *)key;
- (NSData *)cacheDataForKey:(NSString *)key;
- (id)cacheForKey:(NSString *)key receiver:(void (^)(NSString *path, NSData *data))receiver;
- (void)saveData:(NSData *)data forKey:(NSString *)key;
- (void)moveFile:(NSString *)path forKey:(NSString *)key;
- (void)touchCacheForKey:(NSString *)key;
- (void)cleanFileOlderThan:(NSDate *)date;
- (void)removeObserver:(id)observer;

@end
