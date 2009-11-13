//
//  Supervisor.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKObjectSession.h"
#import "Response.h"
#import "LoginRequest.h"
#import "Test.h"


@class Supervisor;
@protocol SupervisorDelegate

- (void) supervisor:(Supervisor*)supervisor didReceiveResponse:(Response*)response;

@end


@interface Supervisor : NSObject {
	GKObjectSession* gkSession;
	Test* test;
	NSObject <GKSessionDelegate, SupervisorDelegate> *delegate;
}

- (void) start;
- (void) receivedLoginRequest:(LoginRequest*)loginRequest fromPeer:(NSString*)peer;

@property (nonatomic , retain) GKObjectSession* gkSession;
@property (nonatomic , retain) Test* test;
@property (nonatomic , retain) NSObject <GKSessionDelegate, SupervisorDelegate> *delegate;

@end
