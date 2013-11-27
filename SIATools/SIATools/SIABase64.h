//
//  SIABase64.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/08.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#ifndef SIATools_SIABase64_h
#define SIATools_SIABase64_h

#import <Foundation/Foundation.h>

NSString *SIABase64Encode(unsigned char const *byte, int len);
NSData   *SIABase64Decode(char const *string, int len);

@interface NSData (NSDataSIABase64Extensions)
+ (NSData *)dataWithBase64String:(NSString *)base64String;
- (NSString *)encodeWithBase64;
@end

@interface NSString (NSStringSIABase64Extensions)
+ (NSString *)base64StringWithData:(NSData *)data;
- (NSData *)decodeWithBase64;
@end

#endif
