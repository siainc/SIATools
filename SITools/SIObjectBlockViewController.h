//
//  SIObjectBlockViewController.h
//  SITools
//
//  Created by Kurosaki Ryota on 12/04/27.
//  Copyright (c) 2012年 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIObjectBlockViewController : UIViewController

- (IBAction)mainThread:(id)sender;
- (IBAction)afterDelay:(id)sender;
- (IBAction)background:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *mainField;
@property (weak, nonatomic) IBOutlet UITextField *afterField;
@property (weak, nonatomic) IBOutlet UITextField *backField;

@end
