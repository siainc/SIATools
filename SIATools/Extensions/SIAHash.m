//
//  SIAHash.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAHash.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+SIATools.h"

#define CHUNK_SIZE (1000 * 1000)

NSString *SIACreateHashByMD5(const void *data, unsigned int length)
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSString *SIACreateHashBySHA1(const void *data, unsigned int length)
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSString *SIACreateHashBySHA256(const void *data, unsigned int length)
{
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSData *SIACreateHmacBySHA256(const void *key, unsigned int keyLength, const void *data, unsigned int dataLength)
{
    unsigned char hmac[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key, keyLength, data, dataLength, hmac);
    NSData *hash = [[NSData alloc] initWithBytes:hmac length:CC_SHA256_DIGEST_LENGTH];
    return hash;
}

@implementation NSData (NSDataSIAHashExtension)

- (NSString *)sia_md5Hash
{
    return SIACreateHashByMD5(self.bytes, (unsigned int)self.length);
}

- (NSString *)sia_sha1Hash
{
    return SIACreateHashBySHA1(self.bytes, (unsigned int)self.length);
}

- (NSString *)sia_sha256Hash
{
    return SIACreateHashBySHA256(self.bytes, (unsigned int)self.length);
}

- (NSData *)sia_sha256Hmac:(NSString *)key
{
    return SIACreateHmacBySHA256(key.UTF8String,
                                 (unsigned int)[key lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                                 self.bytes,
                                 (unsigned int)self.length);
}

@end

@implementation NSString (NSStringSIAHashExtension)

- (NSString *)sia_md5Hash
{
    return SIACreateHashByMD5(self.UTF8String,
                              (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sia_sha1Hash
{
    return SIACreateHashBySHA1(self.UTF8String,
                               (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sia_sha256Hash
{
    return SIACreateHashBySHA256(self.UTF8String,
                                 (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSData *)sia_sha256Hmac:(NSString *)key
{
    return SIACreateHmacBySHA256(key.UTF8String,
                                 (unsigned int)[key lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                                 self.UTF8String,
                                 (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

@end

@implementation NSFileManager (NSFileManagerSIAHashExtension)

- (NSString *)sia_md5HashAtPath:(NSString *)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    while (YES) {
        @autoreleasepool {
            NSData *fileData = [handle readDataOfLength:CHUNK_SIZE];
            CC_MD5_Update(&md5, fileData.bytes, (unsigned int)fileData.length);
            if (fileData.length == 0) {
                break;
            }
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

@end

