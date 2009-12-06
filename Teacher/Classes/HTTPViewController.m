//
//  HTTPViewController.m
//  Teacher
//
//  Created by ece on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HTTPViewController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "Util.h"

@implementation HTTPViewController
@synthesize netService;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)viewDidLoad
{

	
	NSString *root = [[Util appDir] stringByAppendingPathComponent:@"www"];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	//[httpServer setType:@"http"];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	//[httpServer setDomain:@"app."];
	[httpServer setName:@"teacher_results"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
}

- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
	
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
	
	if (!localIP)
		info = @"Wifi: No Connection!\n";
	else{
		info = [NSString stringWithFormat:@"http://%@:%d\n", localIP, port];
	}
	
//	NSString *wwwIP = [addresses objectForKey:@"www"];
//	
//	if (wwwIP)
//		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
//	else
//		info = [info stringByAppendingString:@"Web: Unable to determine external IP\n"];
	
	displayInfo.text = info;
}


- (IBAction)startStopServer:(id)sender
{
	if ([sender isOn])
	{
		// You may OPTIONALLY set a port for the server to run on.
		// 
		// If you don't set a port, the HTTP server will allow the OS to automatically pick an available port,
		// which avoids the potential problem of port conflicts. Allowing the OS server to automatically pick
		// an available port is probably the best way to do it if using Bonjour, since with Bonjour you can
		// automatically discover services, and the ports they are running on.
		[httpServer setPort:8080];

		
		NSError *error = nil;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		
		[self displayInfoUpdate:nil];
	}
	else
	{
		[httpServer stop];
	}
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

- (BOOL) enableBonjourWithDomain:(NSString*)domain applicationProtocol:(NSString*)protocol name:(NSString*)name
{
    if(![domain length])
        domain = @".app"; //Will use default Bonjour registration doamins, typically just ".local"
    if(![name length])
        name = @"teacher"; //Will use default Bonjour name, e.g. the name assigned to the device in iTunes
    
    if(!protocol || ![protocol length] )
        return NO;
    
	
    self.netService = [[NSNetService alloc] initWithDomain:domain type:protocol name:name port:httpServer.port];
    if(self.netService == nil)
        return NO;
    
    [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.netService publish];
    [self.netService setDelegate:self];
	[netService release];
    
    return YES;
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"service published");
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
	NSLog(@"did not publish: %@" , errorDict);
}


- (void)dealloc {
	[netService release];
	[httpServer release];
    [super dealloc];
}


@end
