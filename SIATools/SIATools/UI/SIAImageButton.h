//
//  SIAImageButton.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2010/09/24.
//  Copyright (c) 2010 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIAImageButton :   UIButton

@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;

@end