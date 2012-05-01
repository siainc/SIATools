//
//  SIObjectBlockViewController.m
//  SITools
//
//  Created by Kurosaki Ryota on 12/04/27.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import "SIObjectBlockViewController.h"
#import "SIBlock.h"

@interface SIObjectBlockViewController ()

@end

@implementation SIObjectBlockViewController
@synthesize mainField = _mainField;
@synthesize afterField = _afterField;
@synthesize backField = _backField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMainField:nil];
    [self setAfterField:nil];
    [self setBackField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)mainThread:(id)sender
{
    SIRunBlockOnMainThread(^{
        self.mainField.text = [[NSThread currentThread] description];
        NSLog(@"1");
    });
    NSLog(@"2");
}

- (IBAction)afterDelay:(id)sender
{
    SIRunBlockOnMainThreadAfterDelay(^{
        self.afterField.text = [[NSThread currentThread] description];
        NSLog(@"3");
    }, 3);
    NSLog(@"4");
}

- (IBAction)background:(id)sender
{
    SIRunBlockInBackground(^{
        self.backField.text = [[NSThread currentThread] description];
        NSLog(@"5");
    });
    NSLog(@"6");
}

@end
