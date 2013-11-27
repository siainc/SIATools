//
//  SIAToolsLogger.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/22.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import "SIALogger.h"

#define SIATOOLS_LOGGER_TAG @"SIATools"

#ifdef SIATOOLS_DEBUG
#define SIAToolsELog(fmt, ...) [[SIAToolsLogger sharedLogger] e : @"|E|SIATOOLS_LOGGER_TAG|%4d|%s " fmt, __LINE__, __PRETTY_FUNCTION__, \
## __VA_ARGS__]
#define SIAToolsWLog(fmt, ...) [[SIAToolsLogger sharedLogger] w : @"|W|SIATOOLS_LOGGER_TAG|%4d|%s " fmt, __LINE__, __PRETTY_FUNCTION__, \
## __VA_ARGS__]
#define SIAToolsILog(fmt, ...) [[SIAToolsLogger sharedLogger] i : @"|I|SIATOOLS_LOGGER_TAG|%4d|%s " fmt, __LINE__, __PRETTY_FUNCTION__, \
## __VA_ARGS__]
#define SIAToolsDLog(fmt, ...) [[SIAToolsLogger sharedLogger] d : @"|D|SIATOOLS_LOGGER_TAG|%4d|%s " fmt, __LINE__, __PRETTY_FUNCTION__, \
## __VA_ARGS__]
#define SIAToolsVLog(fmt, ...) [[SIAToolsLogger sharedLogger] v : @"|V|SIATOOLS_LOGGER_TAG|%4d|%s " fmt, __LINE__, __PRETTY_FUNCTION__, \
## __VA_ARGS__]
#else
#define SIAToolsELog(...)      do { } while (0)
#define SIAToolsWLog(...)      do { } while (0)
#define SIAToolsILog(...)      do { } while (0)
#define SIAToolsDLog(...)      do { } while (0)
#define SIAToolsVLog(...)      do { } while (0)
#endif

@interface SIAToolsLogger :   SIALogger

+ (SIAToolsLogger *)sharedLogger;

@end
