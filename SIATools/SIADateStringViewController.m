//
//  SIADateStringViewController.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import "SIADateStringViewController.h"
#import "SIATools.h"

@interface SIADateStringViewController ()

@end

@implementation SIADateStringViewController
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;

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
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setLabel3:nil];
    [self setLabel4:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)valueChanged:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    self.label1.text = [NSString stringFromDate:picker.date withFormat:@"yyyy-MM-dd HH:mm:SS"];
    self.label2.text = [[NSDate dateFromString:self.label1.text withFormat:@"yyyy-MM-dd HH:mm:SS"] description];
    self.label3.text = [NSString stringFromDate:picker.date withFormat:@"yyyy年MM月dd日 HH時mm分SS秒(EEE)"];
    self.label4.text = [NSString stringWithFormat:@"%d年 %d月 %d日", picker.date.components.year, picker.date.components.month,
                        picker.date.components.day];
}

@end
