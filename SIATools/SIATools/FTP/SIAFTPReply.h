//
//  SIAFTPReply.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/02.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAFTPReply :   NSObject

+ (SIAFTPReply *)replyWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

@property (nonatomic, copy, readwrite) NSString   *stringValue;
@property (nonatomic, assign, readonly) NSInteger code;
@property (nonatomic, copy, readonly) NSString    *message;

@end
