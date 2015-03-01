//
//  PageViewController.h
//  FlipDemo1
//
//  Created by Rohun Ati on 8/16/14.
//  Copyright (c) 2014 Rohun Ati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PageViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *txtname;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;


- (IBAction)settingsAction:(UIBarButtonItem *)sender;

-(IBAction)browseForDevices:(id)sender;
-(IBAction)toggleVisibility:(id)sender;
-(IBAction)disconnect:(id)sender;

@end
