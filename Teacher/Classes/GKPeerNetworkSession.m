//
//  GKPeerNetworkSession.m
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GKPeerNetworkSession.h"
#import "HopRequest.h"

@implementation GKPeerNetworkSession
@synthesize hopCount;
@synthesize secondaryDelegate;
@synthesize peers;


- (void) start{
	self.delegate = self;
	[self setDataReceiveHandler:self withContext:nil];
	self.available = YES;
}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSLog(@"received object: %@", receivedObject);
	

	if ( [receivedObject isKindOfClass:[NSArray class]]){
		for( id request in receivedObject){
			[self processRequest:request fromPeer:peerID];
		}		
	}else{
		[self processRequest:receivedObject fromPeer:peerID];
	}
	
}

- (void) processRequest:(id)request fromPeer:(NSString*)peerID{

	if ( [request isKindOfClass:[HopRequest class]]){
		HopRequest* hr = request;
		[peers setObject:[NSNumber numberWithInt:hr.hops] forKey:peerID];
		NSLog(@"peer[%@] has hopcount: %d" , peerID, hr.hops);
		
		if ( hr.hops != -1 && hr.hops < self.hopCount){
			self.hopCount = hr.hops +1;
			hr.hops = self.hopCount;
			[self sendObjectToAllPeers:hr];
			NSLog(@"setting current hops to %d" , hopCount);
		}
		if ( hr.hops == -1 && self.hopCount == -1 && [peers count] >0 ){
			[self disconnectPeerFromAllPeers:peerID];
			NSLog(@"connections full, disconnecting from peer: %@" , peerID);
		}
		
	}
}

- (void) setDelegate:(id <GKSessionDelegate>)_delegate{
	
	if ( [_delegate isKindOfClass:[GKPeerNetworkSession class]]){
		[super setDelegate:_delegate];
	}else{
		self.secondaryDelegate = _delegate;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
	[self.secondaryDelegate session:session didReceiveConnectionRequestFromPeer:peerID];
	if( [self shouldConnectToPeer:peerID]){
		NSLog(@"accepting request from: %@" , peerID);
		[self acceptConnectionFromPeer:peerID error:nil];
	}else{
		NSLog(@"rejecting request from: %@" , peerID);
		[self denyConnectionFromPeer:peerID];
	}
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
	[self.secondaryDelegate session:session connectionWithPeerFailed:peerID withError:error];
	NSLog(@"peer connection failed: %@ , %@" , peerID , error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
	[self.secondaryDelegate session:session didFailWithError:error];
	NSLog(@"connection failed with error: %@" , error);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	[self.secondaryDelegate session:session peer:peerID didChangeState:state];
	
	if ( state == 0 ){
		if ( [self shouldConnectToPeer:peerID]){
			[session connectToPeer:peerID withTimeout:120.0];
			NSLog(@"sending connection request to: %@" , peerID);
		}else{
			NSLog(@"found available peer[%@], but refusing to connect",peerID);
		}
	}
	if ( state == GKPeerStateConnected){
		NSLog(@"connected with current hops: %d", hopCount);
		HopRequest* hopRequest = [[HopRequest alloc] init];
		hopRequest.hops = self.hopCount;
		[self sendObject:hopRequest toPeer:peerID];
		[hopRequest release];
	}
	if ( state == GKPeerStateDisconnected){
		NSLog(@"peer disconnected: %@", peerID);
		[peers removeObjectForKey:peerID];
	}

	NSLog(@"state did change: %d" , state);
}

- (BOOL) shouldConnectToPeer:(NSString*)peerID{
	return hopCount != -1 || ([peers count] < 2 && ![blockedPeers containsObject:peerID]);
}

- (void) dealloc{
	[secondaryDelegate release];
	[peers release];
	[super dealloc];
}

@end
