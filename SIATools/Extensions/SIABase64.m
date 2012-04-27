//
//  SIABase64.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/08.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIABase64.h"

static const unsigned char base64_encode_table[] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

static const unsigned char base64_decode_table[] = {
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99,  99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99,  99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62,  99,  99,  99,  63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99,  99,  99,  99,  99,
    99, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12,  13,  14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99,  99,  99,  99,  99,
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38,  39,  40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99,  99,  99,  99,  99
};

// buffは4byte必要。byteのlenは1-3。
void SIABase64EncodeByte(unsigned char *buff, unsigned char const *byte, NSInteger len)
{
    unsigned int four_byte = 0;
    memcpy(&four_byte, byte, len);
    four_byte = ntohl(four_byte);
    
    unsigned int mask = 0x0000003F;
    if (len == 3) {
        buff[0] = base64_encode_table[(four_byte >> 26) & mask];
        buff[1] = base64_encode_table[(four_byte >> 20) & mask];
        buff[2] = base64_encode_table[(four_byte >> 14) & mask];
        buff[3] = base64_encode_table[(four_byte >>  8) & mask];
    }
    else if (len == 2) {
        buff[0] = base64_encode_table[(four_byte >> 26) & mask];
        buff[1] = base64_encode_table[(four_byte >> 20) & mask];
        buff[2] = base64_encode_table[(four_byte >> 14) & mask];
        buff[3] = '=';
    }
    else if (len == 1) {
        buff[0] = base64_encode_table[(four_byte >> 26) & mask];
        buff[1] = base64_encode_table[(four_byte >> 20) & mask];
        buff[2] = '=';
        buff[3] = '=';
    }
}

// buffは3byte必要。stringはlenは1-4。
NSInteger SIABase64DecodeChar(unsigned char *buff, char const *string, NSInteger len)
{
    int ret = 3;
    if (len == 4) {
        buff[0] = (base64_decode_table[string[0]] << 2) | base64_decode_table[string[1]] >> 4;
        buff[1] = (base64_decode_table[string[1]] << 4) | base64_decode_table[string[2]] >> 2;
        buff[2] = (base64_decode_table[string[2]] << 6) | base64_decode_table[string[3]] >> 0;
        if (string[2] == '=') {
            ret = 1;
        }
        else if (string[3] == '=') {
            ret = 2;
        }
    }
    else if (len == 3) {
        buff[0] = (base64_decode_table[string[0]] << 2) | base64_decode_table[string[1]] >> 4;
        buff[1] = (base64_decode_table[string[1]] << 4) | base64_decode_table[string[2]] >> 2;
        buff[2] = (base64_decode_table[string[2]] << 6);
        if (string[2] == '=') {
            ret = 1;
        }
    }
    else if (len == 2) {
        buff[0] = (base64_decode_table[string[0]] << 2) | base64_decode_table[string[1]] >> 4;
        buff[1] = (base64_decode_table[string[1]] << 4);
        buff[2] = 0;
        ret = 1;
    }
    else if (len == 1) {
        buff[0] = (base64_decode_table[string[0]] << 2);
        buff[1] = 0;
        buff[2] = 0;
        ret = 1;
    }
    return ret;
}

NSString *SIABase64Encode(unsigned char const *byte, NSInteger len)
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:len * 4 / 3];
    unsigned char buff[5];
    buff[4] = '\0';
    int offset = 0;
    while (offset < len) {
        SIABase64EncodeByte(buff, byte + offset, MIN(3, len - offset));
        [string appendFormat:@"%s", buff];
        offset += 3;
    }
    return string;
}

NSData *SIABase64Decode(char const *string, NSInteger len)
{
    NSMutableData *data = [NSMutableData dataWithCapacity:len * 3 / 4];
    unsigned char buff[3];
    NSInteger offset = 0;
    while (offset < len) {
        NSInteger buff_len = SIABase64DecodeChar(buff, string + offset, MIN(4, len - offset));
        [data appendBytes:buff length:buff_len];
        offset += 4;
    }
    return data;
}

@implementation NSData (NSDataSIABase64Extensions)

+ (NSData *)sia_dataWithBase64String:(NSString *)base64String
{
    return SIABase64Decode(base64String.UTF8String, base64String.length);
}

- (NSString *)sia_encodeByBase64
{
    return SIABase64Encode(self.bytes, self.length);
}

@end

@implementation NSString (NSStringSIABase64Extensions)

+ (NSString *)sia_base64StringWithData:(NSData *)data
{
    return SIABase64Encode(data.bytes, data.length);
}

- (NSData *)sia_decodeByBase64
{
    return SIABase64Decode(self.UTF8String, self.length);
}

@end
