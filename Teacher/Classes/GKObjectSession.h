//
//  GKObjectSession.h
//  Teacher
//
//  Created by Adrian Smith on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GKObjectSession : GKSession {

}

- (void) sendObject:(id <NSCoding>)object toPeers:(NSArray*)peers;
- (void) sendObject:(id <NSCoding>)object toPeer:(NSString*)peer;
- (void) sendObjectToAllPeers:(id <NSCoding>)object;

@end
