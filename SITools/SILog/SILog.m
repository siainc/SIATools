//
//  SILog.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SILog.h"
#import <pthread.h>

@interface SILog ()
@property(nonatomic,strong) NSArray *levelLabels;
@property(nonatomic,strong) NSFileHandle *fileHandle;
- (void)output:(NSString *)format arguments:(va_list)list;
@end

@implementation SILog

+ (SILog *)sharedLog
{
    static dispatch_once_t onceToken;
    static SILog *_shareadLog;
    dispatch_once(&onceToken, ^{
        _shareadLog = [[SILog alloc] init];
#ifdef DEBUG
        _shareadLog.outputLevel = SILogLevelDebug;
#else
        _shareadLog.outputLevel = SILogLevelWarning;
#endif
    });
    return _shareadLog;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enabledConsole = YES;
        _enabledLogFile = NO;
        _outputLevel = SILogLevelVerbose;
        _levelLabels = @[@"E", @"W", @"I", @"D", @"V"];
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
        NSMutableString *string = [NSMutableString stringWithString:[[SILog dateFormatter] stringFromDate:[NSDate date]]];
        NSProcessInfo *info = [NSProcessInfo processInfo];
        [string appendFormat:@" %@[%d:%x] ", info.processName, info.processIdentifier, pthread_mach_thread_np(pthread_self())];
        [string appendString:[[NSString alloc] initWithFormat:format arguments:list]];
        [string appendString:@"\n"];
        NSData *data = [[NSData alloc] initWithBytesNoCopy:(void *)string.UTF8String length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] freeWhenDone:NO];
        [self.fileHandle writeData:data];
        [self.fileHandle synchronizeFile];
    }
}

- (void)outputWithLevel:(SILogLevel)logLevel format:(NSString *)format arguments:(va_list)list
{
    if (logLevel <= self.outputLevel) {
        NSString *label = [self.levelLabels objectAtIndex:logLevel - SILogLevelError];
        NSString *message = [NSString stringWithFormat:@"[%@]%@", label, format];
        [self output:message arguments:list];
    }
}

- (void)e:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self outputWithLevel:SILogLevelError format:format arguments:list];
    va_end(list);
}

- (void)w:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self outputWithLevel:SILogLevelWarning format:format arguments:list];
    va_end(list);
}

- (void)i:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self outputWithLevel:SILogLevelInformation format:format arguments:list];
    va_end(list);
}

- (void)d:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self outputWithLevel:SILogLevelDebug format:format arguments:list];
    va_end(list);
}

- (void)v:(NSString *)format, ...
{
    va_list list;
    va_start(list, format);
    [self outputWithLevel:SILogLevelVerbose format:format arguments:list];
    va_end(list);
}

- (void)setLogFileURL:(NSURL *)logFileURL
{
    [self.fileHandle closeFile];
    _logFileURL = logFileURL;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFileURL.path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logFileURL.path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:logFileURL.path contents:[NSData data] attributes:nil];
    }
    NSError *error = nil;
    self.fileHandle = [NSFileHandle fileHandleForUpdatingURL:logFileURL error:&error];
    [self.fileHandle seekToEndOfFile];
}

@end
