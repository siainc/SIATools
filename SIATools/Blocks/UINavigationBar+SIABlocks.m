//
//  UINavigationBar+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2014/01/10.
//  Copyright (c) 2014 SI Agency Inc. All rights reserved.
//

#import "UINavigationBar+SIABlocks.h"

#import "SIABlockProtocol.h"

@implementation UINavigationBar (SIABlocks)

- (void)sia_setPositionForBarUsingBlock:(UIBarPosition (^)(id <UIBarPositioning> bar))block
{
    [self sia_implementProtocol:@protocol(UIBarPositioningDelegate)
                 setterSelector:@selector(setDelegate:)
                     usingBlock:^(SIABlockProtocol *protocol)
     {
         [protocol addMethodWithSelector:@selector(positionForBar:)
                                   block:^UIBarPosition (SIABlockProtocol *protocol, id <UIBarPositioning> bar)
          {
              return block(bar);
          }];
     }];
}

@end
