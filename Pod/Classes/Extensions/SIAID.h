//
//  SIAID.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/12/04.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *SIACreateUUID();

NSString *SIAGetUIID(BOOL useKeychain);
NSString *SIAGetUIIDByUserDefaults();
NSString *SIAGetUIIDByKeychain();
