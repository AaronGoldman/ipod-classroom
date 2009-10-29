//
//  Client.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Client.h"

#define kSessionID @"iResponse"
#define kDisplayName @"iResponse"

@implementation Client
@synthesize userName;
@synthesize passwordHash;
@synthesize gkSession;
@synthesize delegate;

- (id) init{
	if ( self = [super init]){

	}
	return self;
}

- (void) start{
	self.gkSession = [[GKSession alloc] initWithSessionID:kSessionID displayName:kDisplayName sessionMode:GKSessionModeClient];
	gkSession.available = YES;
	gkSession.delegate = delegate;
	[gkSession setDataReceiveHandler:self withContext:nil];
	
	[gkSession release];
	NSLog(@"starting client");
}

- (void) loginWithUserName:(NSString*)_userName passwordHash:(NSString*)_passwordHash{
	NSLog(@"trying to login, but not implemented yet");
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"received data: %@", dataString);
	
	[dataString release];
	
}

- (void) dealloc{
	[delegate release];
	[gkSession release];
	[passwordHash release];
	[userName release];
	[super dealloc];
}
@end
