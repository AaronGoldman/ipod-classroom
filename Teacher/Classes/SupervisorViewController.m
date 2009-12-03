//
//  SupervisorViewController.m
//  Teacher
//
//  Created by Adrian Smith on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SupervisorViewController.h"
#import "QuizServiceHttpConnection.h"
#import "Util.h"

@implementation SupervisorViewController
@synthesize httpServer;
@synthesize tid;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Blarg!";
	
	self.httpServer = [[QuizServiceHttpServer alloc] initWithTid:self.tid];
	
	NSString* root = [[Util appDir] stringByAppendingPathComponent:@"www"];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	httpServer.acceptNew = acceptNewSwitch.on;
	
	[httpServer release];

	
	NSError *error = nil;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}

- (IBAction) valueChanged:(UISwitch*)component{
	//do nothing right now
	httpServer.acceptNew = component.on;
	
}

- (void) updateUI{
	//authenticatedLabel.text = [NSString stringWithFormat:@"%d" , [[supervisor clientsWithState:ClientStateAuthenticated] count]];
	//connectedLabel.text		= [NSString stringWithFormat:@"%d" , [[supervisor clientsWithState:ClientStateConnected] count]];
	//disconnectedLabel.text	= [NSString stringWithFormat:@"%d" , [[supervisor clientsWithState:ClientStateDisconnected] count]];
}
	

- (void) supervisorDidHaveClientChangeState:(Supervisor*)supervisor{
	//[self updateUI];
}

- (void) supervisor:(Supervisor*)_supervisor didReceiveResponse:(Response*)response{
	//NSLog(@"received response");
}
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


- (void)dealloc {
	[httpServer release];
    [super dealloc];
}


@end
