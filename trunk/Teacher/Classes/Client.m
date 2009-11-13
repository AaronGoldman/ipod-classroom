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
#import "LoginRequest.h"

@implementation Client
@synthesize userName;
@synthesize passwordHash;
@synthesize gkSession;
@synthesize delegate;
@synthesize authenticated;
@synthesize loginOnConnect;

static Client *instance;

+ (Client*)getInstance{
	
	@synchronized(self){
		if (!instance){
			
			instance = [[Client alloc] init];
			[instance start];
		}
		
		return instance;
	}
	
	return nil;
}

- (id) init{
	if ( self = [super init]){
		loginOnConnect = YES;
	}
	return self;
}

- (void) start{
	self.gkSession = [[GKObjectSession alloc] initWithSessionID:kSessionID displayName:kDisplayName sessionMode:GKSessionModeClient];
	gkSession.available = YES;
	gkSession.delegate = self;
	[gkSession setDataReceiveHandler:self withContext:nil];
	
	[gkSession release];
	NSLog(@"starting client");
}

- (void) login{
	if( userName ){
		LoginRequest* loginRequest = [[LoginRequest alloc] init];
		loginRequest.userName = userName;
		loginRequest.passwordHash = passwordHash;
		
		[gkSession sendObjectToAllPeers:loginRequest];
	}
}



- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSLog(@"received object: %@", receivedObject);

	if( [receivedObject isKindOfClass:[LoginRequestReply class]]){
		[self receivedLoginRequestReply:receivedObject];
	}
	
}

- (void) receivedLoginRequestReply:(LoginRequestReply*)reply{
	
	if ( reply.authenticated){
		self.authenticated = YES;
		[self.delegate client:self didReceiveQuestions:reply.questions];
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
	NSLog(@"received connection request?");
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
	NSLog(@"peer connection failed: %@ , %@" , peerID , error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
	NSLog(@"connection failed with error: %@" , error);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	if ( state == 0){
		[session connectToPeer:peerID withTimeout:120.0];
	}
	if ( state == GKPeerStateConnected){
		NSLog(@"connected");
		if( loginOnConnect){
			[self login];
		}
	}
	NSLog(@"state did change: %d" , state);
}

- (void) dealloc{
	[delegate release];
	[gkSession release];
	[passwordHash release];
	[userName release];
	[super dealloc];
}
@end
