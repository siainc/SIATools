//
//  SIAControlAction.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/02/12.
//  Copyright (c) 2013 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAControlAction :   NSObject

@property (nonatomic, assign, readonly) UIControlEvents controlEvents;
@property (nonatomic, weak, readonly) NSOperationQueue  *queue;
@property (nonatomic, copy, readonly) void              (^block)(UIEvent *event);

@end

@interface UIControl (UIControlSIAControlActionExtensions)

- (SIAControlAction *)addActionForControlEvents:(UIControlEvents)controlEvents
                                          queue:(NSOperationQueue *)queue
                                     usingBlock:(void(^) (UIEvent * event))block;
- (void)removeAction:(SIAControlAction *)action forControlEvents:(UIControlEvents)controlEvents;

@end
