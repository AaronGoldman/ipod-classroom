//
//  Client.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Client.h"
#import "TestResponsesRequest.h"
#import "LoginRequest.h"
#import "DeviceInfoRequest.h"
#import "Util.h"

#define kSessionID @"iResponse"
#define kDisplayName @"iResponse"


@implementation Client
@synthesize firstName;
@synthesize lastName;
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

	LoginRequest* loginRequest = [[LoginRequest alloc] init];
	loginRequest.firstName = firstName;
	loginRequest.lastName = lastName;
	loginRequest.udid = [[UIDevice currentDevice] uniqueIdentifier];
	loginRequest.passwordHash = passwordHash;
	
	[gkSession sendObjectToAllPeers:loginRequest];

}

- (void) sendDeviceInfo{
	DeviceInfoRequest* deviceInfoRequest = [[DeviceInfoRequest alloc] init];
	deviceInfoRequest.udid = [[UIDevice currentDevice] uniqueIdentifier];
	[gkSession sendObjectToAllPeers:deviceInfoRequest];
}

- (void) sendTestResponses:(NSMutableArray*)testResponses{
	TestResponsesRequest* request = [[TestResponsesRequest alloc] init];
	request.responses = testResponses;
	[self.gkSession sendObjectToAllPeers:request];
	
	[request release];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSLog(@"received object: %@", receivedObject);

	
	if ( [receivedObject isKindOfClass:[NSArray class]]){
		for( id request in receivedObject){
			[self processRequest:request];
		}		
	}else{
		[self processRequest:receivedObject];
	}
	
}

- (void) processRequest:(id)request{
	if( [request isKindOfClass:[LoginRequestReply class]]){
		[self receivedLoginRequestReply:request];
	}else if( [request isKindOfClass:[QuestionsRequest class]]){
		[self receivedQuestionsRequest:request];
	}
}

- (void) receivedLoginRequestReply:(LoginRequestReply*)reply{
	self.authenticated = reply.authenticated;
	if ( reply.authenticated){
		[self.delegate clientDidAuthenticate:self];
	}else{
		[self.delegate clientDidFailAuthentication:self];
	}
}

- (void) receivedQuestionsRequest:(QuestionsRequest*)request{
	[self.delegate client:self didReceiveQuestions:request.questions];
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
		[self sendDeviceInfo];
		
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
	[firstName release];
	[lastName release];
	[super dealloc];
}
@end
