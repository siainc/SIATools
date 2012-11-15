//
//  SIFileCache.h
//  SICache
//
//  Created by KUROSAKI Ryota on 2012/09/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SIFileCacheSetNotification;
extern NSString *SIFileCacheSetKeyKey;
extern NSString *SIFileCacheSetPathKey;
extern NSString *SIFileCacheSetDataKey;

@interface SIFileCache : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,readonly) NSString *cachesPath;

+ (SIFileCache *)sharedCache;
- (id)initWithName:(NSString *)name;
- (NSString *)cachePathForKey:(NSString *)key;
- (NSData *)cacheDataForKey:(NSString *)key;
- (id)cacheForKey:(NSString *)key receiver:(void (^)(NSString *path, NSData *data))receiver;
- (void)saveData:(NSData *)data forKey:(NSString *)key;
- (void)moveFile:(NSString *)path forKey:(NSString *)key;
- (void)touchCacheForKey:(NSString *)key;
- (void)cleanFileOlderThan:(NSDate*)date;
- (void)removeObserver:(id)observer;

@end
