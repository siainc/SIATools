//
//  SILog.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SILogFormat(fmt, ...) [NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#if SILOG_LEVEL >= 5
#define ELog(fmt, ...) [[SILog sharedLog] e:[NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]
#else
#define ELog(...)
#endif

#if SILOG_LEVEL >= 6
#define WLog(fmt, ...) [[SILog sharedLog] w:[NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]
#else
#define WLog(...)
#endif

#if SILOG_LEVEL >= 7
#define ILog(fmt, ...) [[SILog sharedLog] i:[NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]
#else
#define ILog(...)
#endif

#if SILOG_LEVEL >= 8
#define DLog(fmt, ...) [[SILog sharedLog] d:[NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]
#else
#define DLog(...)
#endif

#if SILOG_LEVEL >= 9
#define VLog(fmt, ...) [[SILog sharedLog] v:[NSString stringWithFormat:(@" %s[%3d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]
#else
#define VLog(...)
#endif

typedef enum SILogLevel {
    SILogLevelNone = 1,
    SILogLevelError = 5,
    SILogLevelWarning = 6,
    SILogLevelInformation = 7,
    SILogLevelDebug = 8,
    SILogLevelVerbose = 9
} SILogLevel;

@interface SILog : NSObject

@property(nonatomic,assign) SILogLevel outputLevel;
@property(nonatomic,assign) BOOL enabledConsole;
@property(nonatomic,assign) BOOL enabledLogFile;
@property(nonatomic,strong) NSURL *logFileURL;

+ (SILog *)sharedLog;
- (void)e:(NSString *)format, ...;
- (void)w:(NSString *)format, ...;
- (void)i:(NSString *)format, ...;
- (void)d:(NSString *)format, ...;
- (void)v:(NSString *)format, ...;

@end
