//
//  SIAFTPError.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/05/03.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#ifndef SIATools_SIAFTPError_h
#define SIATools_SIAFTPError_h

extern NSString *const SIAFTPErrorDoman;

typedef NS_ENUM (NSInteger, SIAFTPError) {
    SIAFTPErrorUnknown      = 1,
    SIAFTPErrorCancelled    = 2,
    SIAFTPErrorStreamWrite  = 3,
    SIAFTPErrorStreamRead   = 4,
    SIAFTPErrorStreamEvent  = 5,
    
    SIAFTPErrorCommandReply = 10001,
};

#endif
