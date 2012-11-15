//
//  SIHash.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *SICreateMD5(const void *data, unsigned int length);
NSString *SICreateSHA1(const void *data, unsigned int length);
NSString *SICreateSHA256(const void *data, unsigned int length);
NSData *SICreateHmacSHA256(const void *key, unsigned int keyLength, const void *data, unsigned int dataLength);

@interface NSData (SIHash)
- (NSString *)md5Hash;
- (NSString *)sha1Hash;
- (NSString *)sha256Hash;
- (NSData *)sha256Hmac:(NSString *)key;
@end

@interface NSString (SIHash)
- (NSString *)md5Hash;
- (NSString *)sha1Hash;
- (NSString *)sha256Hash;
- (NSData *)sha256Hmac:(NSString *)key;
@end
