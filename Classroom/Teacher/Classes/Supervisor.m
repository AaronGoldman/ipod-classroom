//
//  Supervisor.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Supervisor.h"

#define kSessionID @"iResponse"
#define kDisplayName @"iResponse"

@implementation Supervisor
@synthesize gkSession;
@synthesize questions;
@synthesize delegate;

- (id) init{
	if (self = [super init]){
		
	}
	return self;
}

- (void) start{
	self.gkSession = [[GKSession alloc] initWithSessionID:kSessionID displayName:kDisplayName sessionMode:GKSessionModeServer];
	gkSession.available = YES;
	gkSession.delegate = delegate;
	[gkSession setDataReceiveHandler:self withContext:nil];
	
	[gkSession release];
	NSLog(@"starting supervisor");
}
//- (IBAction) ping{
//	NSLog(@"pinging");
//	NSData* pingData = [[[UIDevice currentDevice] uniqueIdentifier] dataUsingEncoding:NSUTF8StringEncoding];
//	[session sendDataToAllPeers:pingData withDataMode:GKSendDataReliable error:nil];
//}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"received data: %@", dataString);
	
	[dataString release];
	
}


- (void) dealloc{
	[delegate release];
	[gkSession release];
	[questions release];
	[super dealloc];
}
@end
