//
//  SIALogger.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, SIALoggerLevel) {
    SIALoggerLevelNone        = 1,
    SIALoggerLevelError       = 5,
    SIALoggerLevelWarning     = 6,
    SIALoggerLevelInformation = 7,
    SIALoggerLevelDebug       = 8,
    SIALoggerLevelVerbose     = 9
};

#if SIALOGGER_LEVEL >= 5
#define ELog(tag, fmt, ...) [[SIALogger loggerWithTag:tag] e : @"|E|%@|%4d|%s " fmt, tag, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__]
#else
#define ELog(...) do { } while (0)
#endif

#if SIALOGGER_LEVEL >= 6
#define WLog(tag, fmt, ...) [[SIALogger loggerWithTag:tag] w : @"|W|%@|%4d|%s " fmt, tag, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__]
#else
#define WLog(...) do { } while (0)
#endif

#if SIALOGGER_LEVEL >= 7
#define ILog(tag, fmt, ...) [[SIALogger loggerWithTag:tag] i : @"|I|%@|%4d|%s " fmt, tag, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__]
#else
#define ILog(...) do { } while (0)
#endif

#if SIALOGGER_LEVEL >= 8
#define DLog(tag, fmt, ...) [[SIALogger loggerWithTag:tag] d : @"|D|%@|%4d|%s " fmt, tag, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#endif

#if SIALOGGER_LEVEL >= 9
#define VLog(tag, fmt, ...) [[SIALogger loggerWithTag:tag] v : @"|V|%@|%4d|%s " fmt, tag, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__]
#else
#define VLog(...) do { } while (0)
#endif

@interface SIALogger : NSObject

@property (nonatomic, assign) SIALoggerLevel outputLevel;
@property (nonatomic, assign) BOOL enabledConsole;
@property (nonatomic, assign) BOOL enabledLogFile;
@property (nonatomic, strong) NSURL *logFileURL;

+ (SIALogger *)sharedLogger;
+ (SIALogger *)loggerWithTag:(NSString *)tag;
- (instancetype)initWithTag:(NSString *)tag;
@property (nonatomic, copy) NSString *tag;
- (void)e:(NSString *)format, ...;
- (void)w:(NSString *)format, ...;
- (void)i:(NSString *)format, ...;
- (void)d:(NSString *)format, ...;
- (void)v:(NSString *)format, ...;

@end
