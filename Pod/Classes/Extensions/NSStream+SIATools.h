//
//  NSStream+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/04/30.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream (SIATools)

+ (void)sia_getStreamsToHostName:(NSString *)hostName
                            port:(NSInteger)port
                     inputStream:(NSInputStream **)inputStream
                    outputStream:(NSOutputStream **)outputStream;

@end
