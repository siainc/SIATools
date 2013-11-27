//
//  SIAHash.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAHash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+SIATools.h"
#import "SIAToolsLogger.h"

#define CHUNK_SIZE (1000 * 1000)

NSString *SIACreateMD5(const void *data, unsigned int length)
{
    SIAToolsDLog(@">>data=%p, length=%u", data, length);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    SIAToolsDLog(@"<<%@", hash);
    return hash;
}

NSString *SIACreateSHA1(const void *data, unsigned int length)
{
    SIAToolsDLog(@">>data=%p, length=%u", data, length);
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    SIAToolsDLog(@"<<%@", hash);
    return hash;
}

NSString *SIACreateSHA256(const void *data, unsigned int length)
{
    SIAToolsDLog(@">>data=%p, length=%u", data, length);
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    SIAToolsDLog(@"<<%@", hash);
    return hash;
}

NSData *SIACreateHmacSHA256(const void *key, unsigned int keyLength, const void *data, unsigned int dataLength)
{
    SIAToolsDLog(@">>key=%p, keyLength=%u, data=%p, dataLength=%u", key, keyLength, data, dataLength);
    unsigned char hmac[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key, keyLength, data, dataLength, hmac);
    NSData        *hash = [[NSData alloc] initWithBytes:hmac length:CC_SHA256_DIGEST_LENGTH];
    SIAToolsDLog(@"<<%@", [hash lightDescription]);
    return hash;
}

@implementation NSData (NSDataSIAHashExtension)

- (NSString *)md5Hash
{
    return SIACreateMD5(self.bytes, self.length);
}

- (NSString *)sha1Hash
{
    return SIACreateSHA1(self.bytes, self.length);
}

- (NSString *)sha256Hash
{
    return SIACreateSHA256(self.bytes, self.length);
}

- (NSData *)sha256Hmac:(NSString *)key
{
    return SIACreateHmacSHA256(key.UTF8String, [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], self.bytes, self.length);
}

@end

@implementation NSString (NSStringSIAHashExtension)

- (NSString *)md5Hash
{
    return SIACreateMD5(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sha1Hash
{
    return SIACreateSHA1(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sha256Hash
{
    return SIACreateSHA256(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSData *)sha256Hmac:(NSString *)key
{
    return SIACreateHmacSHA256(key.UTF8String, [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], self.UTF8String,
                               [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

@end

@implementation NSFileManager (NSFileManagerSIAHashExtension)

- (NSString *)md5HashAtPath:(NSString *)path
{
    SIAToolsDLog(@">>path=%@", path);
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) {
        SIAToolsDLog(@"<<%@", nil);
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    while (YES) {
        @autoreleasepool {
            NSData *fileData = [handle readDataOfLength:CHUNK_SIZE];
            CC_MD5_Update(&md5, fileData.bytes, fileData.length);
            if (fileData.length == 0) {
                break;
            }
        }
    }
    
    unsigned char   digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    SIAToolsDLog(@"<<%@", hash);
    return hash;
}

@end

