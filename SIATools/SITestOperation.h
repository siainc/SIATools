//
//  SITestOperation.h
//  SIQueue
//
//  Created by KUROSAKI Ryota on 2012/07/19.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "SIBaseOperation.h"

@interface SITestOperation : SIBaseOperation
@property(copy,nonatomic) NSString *message;
- (id)initWithMessage:(NSString *)message;
@end
