//
//  CommTestMainWindow.m
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CommTestMainWindow.h"
#import "GKPeerNetworkSession.h"
#import "Util.h"

@implementation CommTestMainWindow
@synthesize browser;

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
//	[Util redirectNSLog];
//	[NSTimer scheduledTimerWithTimeInterval:1.0
//									 target:self
//								   selector:@selector(updateLog)
//								   userInfo:nil
//									repeats:YES];
	self.browser = [[NSNetServiceBrowser alloc] init];
	browser.delegate = self;
	//[browser searchForRegistrationDomains];
	[browser searchForServicesOfType:@"_http._tcp." inDomain:@""];
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing{
	NSLog(@"didFindDomain: %@" , domainName);
	[browser searchForServicesOfType:@"_http._tcp." inDomain:domainName];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
	NSLog(@"did Find service: %@" , netService.name);
	[netService retain];
	netService.delegate = self;
	[netService resolveWithTimeout:60];
	
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender{

	NSString* urlString = [NSString stringWithFormat:@"http://%@:%d" , [sender hostName] , [sender port]];
	NSLog(@"testing download from: %@" , urlString);
	NSString* testDownload = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
	NSLog(@"contents are:\n%@" , testDownload);
	[webView loadHTMLString:testDownload baseURL:[NSURL URLWithString:urlString]];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
	NSLog(@"did not resolve addresses : %@" , errorDict);
}
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser{
	NSLog(@"starting to browse");
}
- (void) updateLog{
	NSString* log = [NSString stringWithContentsOfFile:[[Util appDir] stringByAppendingPathComponent:@"NSLog.txt"]
											  encoding:NSUTF8StringEncoding
												 error:nil];
	
	errorLog.text = log;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) start{
//	inSession = [[GKSession alloc] initWithSessionID:@"inSession" displayName:@"inSession" sessionMode:GKSessionModeServer];
//	inSession.delegate = self;
//	[inSession setDataReceiveHandler:self withContext:nil];
//	inSession.available = YES;
//	peerIDLabel1.text = inSession.peerID;
//	
//	outSession = [[GKSession alloc] initWithSessionID:@"inSession" displayName:@"inSession" sessionMode:GKSessionModeClient];
//	outSession.delegate = self;
//	[outSession setDataReceiveHandler:self withContext:nil];
//	outSession.available = YES;
//	peerIDLabel2.text = outSession.peerID;
	GKPeerNetworkSession* session = [[GKPeerNetworkSession alloc] initWithSessionID:@"session" displayName:@"session" sessionMode:GKSessionModePeer];
	[session start];
}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	NSLog(@"received object: %@,%d", receivedObject , session == inSession);
	

	
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{

	NSLog(@"accepting request from: %@,%d" , peerID, session == inSession);
	[session acceptConnectionFromPeer:peerID error:nil];


}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
	NSLog(@"peer connection failed: %@ , %@,%d" , peerID , error, session == inSession);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
	NSLog(@"connection failed with error: %@,%d" , error, session == inSession);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	if ( state == 0 ){
		[session connectToPeer:peerID withTimeout:120.0];
		NSLog(@"sending connection request to: %@,%d" , peerID, session == inSession);
	}
	if ( state == GKPeerStateConnected){
		NSLog(@"connected to %@,%d" , peerID, session == inSession);

	}
	if ( state == GKPeerStateDisconnected){
		NSLog(@"peer disconnected: %@,%d", peerID, session == inSession);

	}
	
	NSLog(@"state did change: %d,%d" , state, session == inSession);
}

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
	[browser release];
    [super dealloc];
}


@end
