//
//  SIABase64.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/08.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#ifndef SIATools_SIABase64_h
#define SIATools_SIABase64_h

#import <Foundation/Foundation.h>

NSString *SIABase64Encode(unsigned char const *byte, NSInteger len);
NSData *SIABase64Decode(char const *string, NSInteger len);

@interface NSData (NSDataSIABase64Extensions)
+ (NSData *)sia_dataWithBase64String:(NSString *)base64String;
- (NSString *)sia_encodeByBase64;
@end

@interface NSString (NSStringSIABase64Extensions)
+ (NSString *)sia_base64StringWithData:(NSData *)data;
- (NSData *)sia_decodeByBase64;
@end

#endif
