//
//  SIDateStringViewController.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2012/04/26.
//  Copyright (c) 2012 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIDateStringViewController : UIViewController

- (IBAction)valueChanged:(id)sender;
@property(nonatomic,weak) IBOutlet UITextField *label1;
@property(nonatomic,weak) IBOutlet UITextField *label2;
@property(nonatomic,weak) IBOutlet UITextField *label3;
@property(nonatomic,weak) IBOutlet UITextField *label4;
@end
