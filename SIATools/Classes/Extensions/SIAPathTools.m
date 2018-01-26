//
//  SIAPathTools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "SIAPathTools.h"

NSString *SIADocumentDirectoryPath(void)
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SIADocumentDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSString *SIACacheDirectoryPath(void)
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SIACacheDirectoryURL(void)
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

