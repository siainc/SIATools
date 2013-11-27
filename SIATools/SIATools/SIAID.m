//
//  SIAID.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/12/04.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAID.h"
#import <Security/Security.h>
#import "SIAToolsLogger.h"

#define SIA_CREATE_UIID_KEY  @"SIA_CREATE_UIID_KEY"
#define SIA_KEYCHAIN_ACCOUNT @"SIA_KEYCHAIN_ACCOUNT"

NSString *SIACreateUUID()
{
    SIAToolsVLog(@">>");
    CFUUIDRef uuid        = CFUUIDCreate(kCFAllocatorDefault);
    NSString  *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    SIAToolsVLog(@"<<%@", uuidString);
    return uuidString;
}

NSString *SIAGetUIID()
{
    SIAToolsVLog(@">>");
    NSString *UIID = [[NSUserDefaults standardUserDefaults] objectForKey:SIA_CREATE_UIID_KEY];
    if (UIID == nil) {
        SIAToolsDLog(@"UIIDが取得できなかったため生成する");
        UIID = SIAGetUIID();
        [[NSUserDefaults standardUserDefaults] setObject:UIID forKey:SIA_CREATE_UIID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    SIAToolsVLog(@"<<%@", UIID);
    return UIID;
}

NSString *SIAGetUIIDByKeychain()
{
    SIAToolsVLog(@">>");
    NSString     *UIID        = nil;
    
    NSDictionary *searchQueue = [NSDictionary dictionaryWithObjectsAndKeys:
                                 (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                                 SIA_KEYCHAIN_ACCOUNT, (__bridge id)kSecAttrAccount,
                                 (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnData, nil];
    CFDataRef uiidDataRef = NULL;
    OSStatus  osStatus    = SecItemCopyMatching((__bridge CFDictionaryRef)searchQueue, (CFTypeRef *)&uiidDataRef);
    if (osStatus == noErr) {
        UIID = [[NSString alloc] initWithData:(__bridge NSData *)uiidDataRef encoding:NSUTF8StringEncoding];
    }
    else if (osStatus == errSecItemNotFound) {
        SIAToolsDLog(@"keychainでUIIDが見つからなかった");
    }
    else {
        SIAToolsDLog(@"SecItemCopyMatchingでエラー:%d", (int)osStatus);
    }
    
    if (UIID == nil) {
        SIAToolsDLog(@"UIIDが取得できなかったため生成する");
        UIID = SIACreateUUID();
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                                    SIA_KEYCHAIN_ACCOUNT, (__bridge id)kSecAttrAccount,
                                    [UIID dataUsingEncoding:NSUTF8StringEncoding], (__bridge id)kSecValueData, nil];
        
        OSStatus result = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
        if (result != noErr) {
            SIAToolsDLog(@"SecItemAddでエラー:%d", (int)result);
            SIAToolsDLog(@"<<%@", nil);
            return nil;
        }
    }
    SIAToolsVLog(@"<<%@", UIID);
    return UIID;
}