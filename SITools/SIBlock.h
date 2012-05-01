//
//  SIBlock.h
//  SITools
//
//  Created by Kurosaki Ryota on 12/05/01.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SITools_SIBlock_h
#define SITools_SIBlock_h

void SIRunBlockOnMainThread(void(^block)());
void SIRunBlockOnMainThreadAfterDelay(void(^block)(), NSTimeInterval delay);
void SIRunBlockInBackground(void(^block)());
void SIRunBlockInBackgroundAfterDelay(void(^block)(), NSTimeInterval delay);

#endif
