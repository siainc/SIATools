//
//  SIAPathTools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "SIAPathTools.h"

NSString *SIADocumentDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SIADocumentDirectoryURL()
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSString *SIACacheDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SIACacheDirectoryURL()
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

