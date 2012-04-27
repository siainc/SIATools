//
//  SIALogger.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIALogger.h"
#import <pthread.h>
#import "NSArray+SIATools.h"

@interface SIALogger ()
@property (nonatomic, strong) NSFileHandle *fileHandle;
- (void)output:(NSString *)format arguments:(va_list)list;
@end

@implementation SIALogger

+ (SIALogger *)sharedLogger
{
    static dispatch_once_t onceToken;
    static SIALogger *_shareadLog;
    dispatch_once(&onceToken, ^{
        _shareadLog = [[SIALogger alloc] init];
        _shareadLog.outputLevel = SIALoggerLevelVerbose;
    });
    return _shareadLog;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enabledConsole = YES;
        _enabledLogFile = NO;
        _outputLevel = SIALoggerLevelVerbose;
    }
    return self;
}

- (void)dealloc
{
    [_fileHandle closeFile];
}

+ (NSDateFormatter *)dateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *_dateFormatter;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:dd.sss";
        _dateFormatter.locale = [NSLocale currentLocale];
    });
    return _dateFormatter;
}

- (void)output:(NSString *)format arguments:(va_list)list
{
    if (self.enabledConsole) {
        NSLogv(format, list);
    }
    if (self.enabledLogFile && self.fileHandle) {
        NSMutableString *string = [NSMutableString stringWithString:[[SIALogger dateFormatter] stringFromDate:[NSDate date]]];
        NSProcessInfo *info = [NSProcessInfo processInfo];
        [string appendFormat:@" %@[%d:%x] ", info.processName, info.processIdentifier, pthread_mach_thread_np(pthread_self())];
        [string appendString:[[NSString alloc] initWithFormat:format arguments:list]];
        [string appendString:@"\n"];
        NSData *data =
        [[NSData alloc] initWithBytesNoCopy:(void *)string.UTF8String length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] freeWhenDone:
         NO];
        [self.fileHandle writeData:data];
        [self.fileHandle synchronizeFile];
    }
}

- (void)setLogFileURL:(NSURL *)logFileURL
{
    [self.fileHandle closeFile];
    _logFileURL = logFileURL;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFileURL.path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logFileURL.path.stringByDeletingLastPathComponent withIntermediateDirectories:YES
                                                   attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:logFileURL.path contents:[NSData data] attributes:nil];
    }
    NSError *error = nil;
    self.fileHandle = [NSFileHandle fileHandleForUpdatingURL:logFileURL error:&error];
    [self.fileHandle seekToEndOfFile];
}

+ (SIALogger *)loggerWithTag:(NSString *)tag
{
    if (tag.length == 0) {
        return [self sharedLogger];
    }
    @synchronized(self) {
        NSMutableDictionary *pool = [self loggerPool];
        SIALogger *logger = pool[tag];
        if (logger == nil) {
            logger = [[SIALogger alloc] initWithTag:tag];
            pool[tag] = logger;
        }
        return logger;
    }
}

+ (NSMutableDictionary *)loggerPool
{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *_loggerPool;
    dispatch_once(&onceToken, ^{
        _loggerPool = [NSMutableDictionary dictionaryWithCapacity:0];
    });
    return _loggerPool;
}

- (instancetype)initWithTag:(NSString *)tag
{
    self = [super init];
    if (self) {
        _enabledConsole = YES;
        _enabledLogFile = NO;
        _outputLevel = SIALoggerLevelVerbose;
        _tag = tag;
    }
    return self;
}

- (void)e:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self logWithLevel:SIALoggerLevelError format:format arguments:list];
    va_end(list);
}

- (void)w:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self logWithLevel:SIALoggerLevelWarning format:format arguments:list];
    va_end(list);
}

- (void)i:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self logWithLevel:SIALoggerLevelInformation format:format arguments:list];
    va_end(list);
}

- (void)d:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self logWithLevel:SIALoggerLevelDebug format:format arguments:list];
    va_end(list);
}

- (void)v:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self logWithLevel:SIALoggerLevelVerbose format:format arguments:list];
    va_end(list);
}

- (void)logWithLevel:(SIALoggerLevel)level format:(NSString *)format arguments:(va_list)list
{
    if (level <= self.outputLevel) {
        if (level <= self.outputLevel &&
            (SIALoggerLevelError <= level && level < SIALoggerLevelVerbose)) {
            if (self.enabledConsole) {
                NSLogv(format, list);
            }
            if (self.enabledLogFile && self.fileHandle) {
                NSMutableString *string = [NSMutableString stringWithString:[[SIALogger dateFormatter] stringFromDate:[NSDate date]]];
                NSProcessInfo *info = [NSProcessInfo processInfo];
                [string appendFormat:@" %@[%d:%x] ", info.processName, info.processIdentifier, pthread_mach_thread_np(pthread_self())];
                [string appendString:[[NSString alloc] initWithFormat:format arguments:list]];
                [string appendString:@"\n"];
                NSData *data =
                [[NSData alloc] initWithBytesNoCopy:(void *)string.UTF8String length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]
                                       freeWhenDone:NO];
                [self.fileHandle writeData:data];
                [self.fileHandle synchronizeFile];
            }
        }
    }
}

@end
