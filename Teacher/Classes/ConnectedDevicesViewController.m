//
//  ConnectedDevicesViewController.m
//  Teacher
//
//  Created by Adrian Smith on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConnectedDevicesViewController.h"


@implementation ConnectedDevicesViewController
@synthesize devices;
@synthesize supervisor;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Connected Devices";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.devices = [NSMutableArray arrayWithCapacity:40];
	self.supervisor = [[Supervisor alloc] init];
	supervisor.delegate = self;
	[supervisor start];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [devices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [devices objectAtIndex:indexPath.row];
	
	//if( indexPath.row % 3 == 0){
		//cell.imageView.image = [UIImage imageNamed:@"device_notconnected.png"];
	//}else{
		cell.imageView.image = [UIImage imageNamed:@"device_connected.png"];		
	//}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//- (IBAction) ping{
//	NSLog(@"pinging");
//	NSData* pingData = [[[UIDevice currentDevice] uniqueIdentifier] dataUsingEncoding:NSUTF8StringEncoding];
//	[session sendDataToAllPeers:pingData withDataMode:GKSendDataReliable error:nil];
//}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
	BOOL connected = [session acceptConnectionFromPeer:peerID error:nil];
	NSLog(@"accepting peer connection: %@, %d" , peerID , connected);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
	NSLog(@"peer connection failed: %@ , %@" , peerID , error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
	NSLog(@"connection failed with error: %@" , error);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
//	if ( state == 0){
//		[session connectToPeer:peerID withTimeout:120.0];
//	}
	if ( state == GKPeerStateConnected){
		NSLog(@"Student connected connected");
		[devices addObject:peerID];
		[self.tableView reloadData];
	}
	NSLog(@"state did change: %d" , state);
}

- (void) supervisor:(Supervisor*)_supervisor didReceiveResponse:(Response*)response{
	NSLog(@"received response");
}

- (void)dealloc {
	[supervisor release];
	[devices release];
    [super dealloc];
}


@end

