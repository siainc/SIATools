//
//  NSObject+SITools.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/04/27.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SITools)

@property(nonatomic,readonly) id notNullObject;
- (void)runBlockOnMainThread:(void (^)())block waitUntilDone:(BOOL)wait;
- (void)runBlock:(void (^)())block afterDelay:(NSTimeInterval)timeInterval;
- (void)runBlockInBackground:(void (^)())block;

@end
