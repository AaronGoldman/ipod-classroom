//
//  GKObjectSession.m
//  Teacher
//
//  Created by Adrian Smith on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GKObjectSession.h"


@implementation GKObjectSession


- (void) sendObject:(id <NSCoding>)object toPeers:(NSArray*)peers{
	NSError* sendError = nil;
	NSData* sendData = [NSKeyedArchiver archivedDataWithRootObject:object];
	

	
	if( peers != nil){
		[self sendData:sendData toPeers:peers withDataMode:GKSendDataReliable error:&sendError];
	}else{
		[self sendDataToAllPeers:sendData withDataMode:GKSendDataReliable error:&sendError];
	}
	
	if ( sendError){
		NSLog(@"Supervisor send error: %@" , [sendError localizedDescription]);
	}
}

- (void) sendObject:(id <NSCoding>)object toPeer:(NSString*)peer{
	[self sendObject:object toPeers:[NSArray arrayWithObject:peer]];
}

- (void) sendObjectToAllPeers:(id <NSCoding>)object{
	[self sendObject:object toPeers:nil];
}

@end
