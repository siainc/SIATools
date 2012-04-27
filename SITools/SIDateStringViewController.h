//
//  SIDateStringViewController.h
//  SITools
//
//  Created by Kurosaki Ryota on 12/04/26.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIDateStringViewController : UIViewController

- (IBAction)valueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *label1;
@property (weak, nonatomic) IBOutlet UITextField *label2;
@property (weak, nonatomic) IBOutlet UITextField *label3;
@property (weak, nonatomic) IBOutlet UITextField *label4;
@end
