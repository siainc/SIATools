//
//  UIControl+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/12.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIAControlAction;

@interface UIControl (SIABlocks)

- (SIAControlAction *)sia_addActionForControlEvents:(UIControlEvents)controlEvents
                                         usingBlock:(void(^) (UIEvent * event))block;
- (void)sia_removeAction:(SIAControlAction *)action forControlEvents:(UIControlEvents)controlEvents;

@end
