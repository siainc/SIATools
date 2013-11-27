//
//  SIAToolsLogger.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/22.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIAToolsLogger.h"

@implementation SIAToolsLogger

+ (SIAToolsLogger *)sharedLogger
{
    static dispatch_once_t onceToken;
    static SIAToolsLogger  *_sharedLogger;
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[SIAToolsLogger alloc] initWithTag:SIATOOLS_LOGGER_TAG];
        _sharedLogger.enabledConsole = NO;
        _sharedLogger.enabledLogFile = NO;
        _sharedLogger.outputLevel = SIALoggerLevelNone;
    });
    return _sharedLogger;
}

@end
