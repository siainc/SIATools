//
//  UINavigationBar+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2014/01/10.
//  Copyright (c) 2014 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (SIABlocks)

- (void)sia_setPositionForBarUsingBlock:(UIBarPosition (^)(id <UIBarPositioning> bar))block;

@end
