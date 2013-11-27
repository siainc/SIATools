//
//  NSBundle+SIATools.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/11.
//  Copyright (c) 2012-2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (SIATools)

- (void)localizeViewController:(UIViewController *)controller;
- (void)localizeView:(UIView *)view;

@end
