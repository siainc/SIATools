//
//  SIAViewController.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "SIAViewController.h"
#import "SIATools.h"

@interface SIAViewController ()

@end

@implementation SIAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSBundle mainBundle] sia_localizeViewController:self];
}

- (void)viewDidUnload
{
    [self setTestButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
