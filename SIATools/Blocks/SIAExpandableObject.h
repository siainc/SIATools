//
//  SIAExpandableObject.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/10.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAExpandableObject : NSObject

+ (Class)registerSubclass;
+ (instancetype)createSubclassInstance;

+ (void)addMethodWithSelector:(SEL)selector types:(const char *)types block:(id)block;
- (void)addMethodWithSelector:(SEL)selector types:(const char *)types block:(id)block;

@end
