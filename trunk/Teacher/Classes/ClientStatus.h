//
//  ClientStatus.h
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef 
enum  {
	ClientStateUnknown  = 0,
	ClientStateConnected,
	ClientStateAuthenticated,
	ClientStateDisconnected,
	ClientStatePending
} ClientState;

@interface ClientStatus : NSObject {
	NSString* udid;
	NSString* peerID;
	NSString* firstName;
	NSString* lastName;
	NSString* passHash;
	ClientState clientState;
}

@property (nonatomic , retain) NSString* udid;
@property (nonatomic , retain) NSString* peerID;
@property (nonatomic , retain) NSString* firstName;
@property (nonatomic , retain) NSString* lastName;
@property (nonatomic , retain) NSString* passHash;
@property (nonatomic , assign) ClientState clientState;

@end
