//
//  SIAFTPCommand.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/02.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAFTPCommand :   NSObject

+ (SIAFTPCommand *)commandWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

@property (nonatomic, copy, readwrite) NSString *stringValue;
- (NSData *)data;

@end
