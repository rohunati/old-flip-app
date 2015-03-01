//
//  ConnectionsViewController.m
//  FlipDemo1
//
//  Created by Rohun Ati on 6/6/14.
//  Copyright (c) 2014 Rohun Ati. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "UnoAppDelegate.h"

@interface ConnectionsViewController()

@property (nonatomic, strong) UnoAppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;


-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;


@end


@implementation ConnectionsViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    _appDelegate = (UnoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate manager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate manager] advertiseSelf:_swVisible.isOn];
    
     [_txtname setDelegate:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    
    [_tblConnectedDevices setDelegate:self];
    [_tblConnectedDevices setDataSource:self];
    
    
    }

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtname resignFirstResponder];
    
    _appDelegate.manager.peerID = nil;
    _appDelegate.manager.session = nil;
    _appDelegate.manager.browser = nil;
    
    if ([_swVisible isOn]) {
        [_appDelegate.manager.advertiser stop];
    }
    _appDelegate.manager.advertiser = nil;
    
    
    [_appDelegate.manager setupPeerAndSessionWithDisplayName:_txtname.text];
    [_appDelegate.manager setupMCBrowser];
    [_appDelegate.manager advertiseSelf:_swVisible.isOn];
    
    return YES;
}

#pragma mark - Public method implementation

- (IBAction)browseForDevices:(id)sender {
    [[_appDelegate manager] setupMCBrowser];
    [[[_appDelegate manager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate manager] browser] animated:YES completion:nil];
}

- (IBAction)toggleVisibility:(id)sender {
    [_appDelegate.manager advertiseSelf:_swVisible.isOn];
}

- (IBAction)disconnect:(id)sender {
    [_appDelegate.manager.session disconnect];
    
    _txtname.enabled = YES;
    
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.manager.browser dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.manager.browser dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Private method implementation

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
        
        [_tblConnectedDevices reloadData];
        
        
        BOOL peersExist = ([[_appDelegate.manager.session connectedPeers] count] == 0);
        [_btnDisconnect setEnabled:!peersExist];
        [_txtname setEnabled:peersExist];
    }




}


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}



@end
