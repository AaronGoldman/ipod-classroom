//
//  GKPeerNetworkSession.h
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GKObjectSession.h"


@interface GKPeerNetworkSession : GKObjectSession <GKSessionDelegate> {
	int hopCount;
	id<GKSessionDelegate> secondaryDelegate;
	NSArray* blockedPeers;
	NSMutableDictionary* peers;
}

- (void) processRequest:(id)request fromPeer:(NSString*)peerID;
- (BOOL) shouldConnectToPeer:(NSString*)peerID;
- (void) start;

@property (nonatomic , assign) int hopCount;
@property (nonatomic , retain) id<GKSessionDelegate> secondaryDelegate;
@property (nonatomic , retain) NSMutableDictionary* peers;


@end
