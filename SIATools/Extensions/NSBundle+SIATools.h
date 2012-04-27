//
//  NSBundle+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/11.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (SIATools)

- (void)sia_localizeViewController:(UIViewController *)controller;
- (void)sia_localizeView:(UIView *)view;

@end
