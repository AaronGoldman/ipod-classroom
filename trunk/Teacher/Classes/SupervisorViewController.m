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
	

	
	NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SupervisorLog" ofType:@"html"]];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	webView.delegate = self;
	[webView loadRequest:request];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	self.httpServer = [[QuizServiceHttpServer alloc] initWithTid:self.tid];
	[httpServer setDelegate:self];
	NSString* root = [[Util appDir] stringByAppendingPathComponent:@"www"];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	httpServer.acceptNew = acceptNewSwitch.on;
	httpServer.quizDelegate = self;
	
	[httpServer release];
	
	
	NSError *error = nil;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
		[self showFailureEvent:@"Error" description:@"Server failed to start"];
	}else{
		[self showGeneralEvent:@"Status" description:@"Server started"];
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

- (void) showEvent:(NSString*)eventName description:(NSString*)eventDescription class:(NSString*)eventClass{
	NSString* javascript = [NSString stringWithFormat:@"prependEventLog('%@','%@','%@');", eventName,eventDescription,eventClass];
	NSLog(@"javascript: %@" , javascript);
	[webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void) studentAuthenticated:(NSString*)studentName{
	[self showAuthenticatedEvent:studentName];
	int numAuthenticated = [self.httpServer.authenticated count];
	authenticatedLabel.text = [NSString stringWithFormat:@"%d",numAuthenticated];
}

- (void) studentFailedAuthentication:(NSString*)studentName{
	[self showFailureEvent:@"Authentication Failed" description:studentName];
}

- (void) showAuthenticatedEvent:(NSString*) studentName{
	[self showEvent:@"Authenticated" description:studentName class:@"event_authenticated"];
}

- (void) studentCompleted:(NSString*)studentName{
	[self showCompletedEvent:studentName];
	int numCompleted = [self.httpServer.completed count];
	completedLabel.text = [NSString stringWithFormat:@"%d",numCompleted];
}

- (void) showCompletedEvent:(NSString*) studentName{
	[self showEvent:@"Completed" description:studentName class:@"event_completed"];
}

- (void) showGeneralEvent:(NSString*)eventName description:(NSString*)eventDescription{
	[self showEvent:eventName description:eventDescription class:@"event_general"];
}

- (void) showFailureEvent:(NSString*) eventName description:(NSString*)eventDescription{
	[self showEvent:eventName description:eventDescription class:@"event_failure"];
}

- (void) netServiceDidPublish:(NSNetService *)ns{
	[self showGeneralEvent:@"Status" description:@"Bonjour Started"];
}

- (void) netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict{
	[self showFailureEvent:@"Bonjour Failed" description:@"Possible other teacher app running"];
}

- (void) serverStarted:(HTTPServer*)server{
	[self showGeneralEvent:@"Status" description:@"Server started"];
}

- (void)dealloc {
	[httpServer release];
    [super dealloc];
}


@end
