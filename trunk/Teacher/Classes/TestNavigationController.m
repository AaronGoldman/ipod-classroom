//
//  TestNavigationController.m
//  Teacher
//
//  Created by Adrian Smith on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestNavigationController.h"


@implementation TestNavigationController

@synthesize connectingViewController;

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
	
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:YES];
	if( ![Client getInstance].authenticated){
		self.connectingViewController = [[ConnectingViewController alloc] init];
		
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[self.view addSubview:connectingViewController.view];
		[UIView commitAnimations];
		[connectingViewController release];
		
		[Client getInstance].delegate = self;
		[[Client getInstance] login];
	}
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

- (void) client:(Client*)_client didReceiveQuestions:(NSArray*)questions{
	NSLog(@"recieved questions: %@" , questions);
}

- (void)dealloc {
	[connectingViewController release];

    [super dealloc];
}


@end
