//
//  SIAWeakReference.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/20.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SIA_WEAK_RETAIN(wvar)            __weak * wvar, *wvar ## _SI_RETAIN; wvar = wvar ## _SI_RETAIN
#define SIA_WEAK(var, wvar)              *var, __weak * wvar; wvar                = var
#define SIA_DEFINE_WEAK_SELF(type, wvar) type __weak * wvar                       = self
#define SIA_DEFINE(type, var, wvar)      type * var, __weak * wvar; wvar          = var

@interface SIAWeakReference :   NSObject

+ (SIAWeakReference *)referenceWithObject:(id __weak)object;
- (instancetype)initWithObject:(id __weak)object;
@property (nonatomic, weak) id object;

@end
