//
//  SIAHash.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *SIACreateMD5(const void *data, unsigned int length);
NSString *SIACreateSHA1(const void *data, unsigned int length);
NSString *SIACreateSHA256(const void *data, unsigned int length);
NSData   *SIACreateHmacSHA256(const void *key, unsigned int keyLength, const void *data, unsigned int dataLength);

@interface NSData (NSDataSIAHashExtension)
- (NSString *)md5Hash;
- (NSString *)sha1Hash;
- (NSString *)sha256Hash;
- (NSData *)sha256Hmac:(NSString *)key;
@end

@interface NSString (NSStringSIAHashExtension)
- (NSString *)md5Hash;
- (NSString *)sha1Hash;
- (NSString *)sha256Hash;
- (NSData *)sha256Hmac:(NSString *)key;
@end

@interface NSFileManager (NSFileManagerSIAHashExtension)
- (NSString *)md5HashAtPath:(NSString *)path;
@end
