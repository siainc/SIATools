//
//  SIHash.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/11/21.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIHash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

NSString *SICreateMD5(const void *data, unsigned int length)
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH]; 
    CC_MD5(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i=0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSString *SICreateSHA1(const void *data, unsigned int length)
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH]; 
    CC_SHA1(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i=0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSString *SICreateSHA256(const void *data, unsigned int length)
{
    unsigned char digest[CC_SHA256_DIGEST_LENGTH]; 
    CC_SHA256(data, length, digest);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i=0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}

NSData *SICreateHmacSHA256(const void *key, unsigned int keyLength, const void *data, unsigned int dataLength)
{
    unsigned char hmac[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key, keyLength, data, dataLength, hmac);
    return [[NSData alloc] initWithBytes:hmac length:CC_SHA256_DIGEST_LENGTH];
}

@implementation NSData (SIHash)

- (NSString *)md5Hash
{
    return SICreateMD5(self.bytes, self.length);
}

- (NSString *)sha1Hash
{
    return SICreateSHA1(self.bytes, self.length);
}

- (NSString *)sha256Hash
{
    return SICreateSHA256(self.bytes, self.length);
}

- (NSData *)sha256Hmac:(NSString *)key
{
    return SICreateHmacSHA256(key.UTF8String, [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], self.bytes, self.length);
}

@end

@implementation NSString (SIHash)

- (NSString *)md5Hash
{
    return SICreateMD5(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sha1Hash
{
    return SICreateSHA1(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)sha256Hash
{
    return SICreateSHA256(self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSData *)sha256Hmac:(NSString *)key
{
    return SICreateHmacSHA256(key.UTF8String, [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], self.UTF8String, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

@end
