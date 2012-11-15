//
//  SIPathTools.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/10/03.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "SIPathTools.h"

NSString *SIDocumentDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SIDocumentDirectoryURL()
{
    return [NSURL fileURLWithPath:SIDocumentDirectoryPath()];
}

NSString *SICacheDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

NSURL *SICacheDirectoryURL()
{
    return [NSURL fileURLWithPath:SICacheDirectoryPath()];
}
