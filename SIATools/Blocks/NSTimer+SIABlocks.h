//
//  NSTimer+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/07/16.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SIABlocks)

+ (NSTimer *)sia_timerWithTimeInterval:(NSTimeInterval)ti
                               repeats:(BOOL)yesOrNo
                            usingBlock:(void (^)())block;
+ (NSTimer *)sia_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                        repeats:(BOOL)yesOrNo
                                     usingBlock:(void (^)())block;

@end