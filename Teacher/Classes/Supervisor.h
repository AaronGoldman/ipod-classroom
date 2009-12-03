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
#import "TestResponsesRequest.h"
#import "DeviceInfoRequest.h"
#import "ClientStatus.h"

@class Supervisor;
@protocol SupervisorDelegate

- (void) supervisor:(Supervisor*)supervisor didReceiveResponse:(Response*)response;
- (void) supervisorDidHaveClientChangeState:(Supervisor*)supervisor;

@end


@interface Supervisor : NSObject <GKSessionDelegate>{
	GKObjectSession* gkSession;
	Test* test;
	NSObject <SupervisorDelegate> *delegate;
	NSMutableArray* clientStatuses;
	BOOL acceptNew;
}

- (void) start;
- (void) receivedLoginRequest:(LoginRequest*)loginRequest fromClient:(ClientStatus*)client;
- (void) receivedTestResponsesRequest:(TestResponsesRequest*)testResponsesRequest fromClient:(ClientStatus*)client;
- (void) receivedDeviceInfoRequest:(DeviceInfoRequest*)info fromClient:(ClientStatus*)client;
- (void) processRequest:(id)request fromClient:(ClientStatus*)client;

- (ClientStatus*) clientWithUdid:(NSString*)udid;
- (ClientStatus*) clientWithPeerID:(NSString*)peerID;
- (NSArray*) clientsWithState:(ClientState)clientState;
- (NSArray*) disconnectedClients;
- (NSArray*) connectedClients;
- (NSArray*) pendingClients;

@property (nonatomic , retain) GKObjectSession* gkSession;
@property (nonatomic , retain) Test* test;
@property (nonatomic , retain) NSObject <SupervisorDelegate> *delegate;
@property (nonatomic , retain) NSMutableArray* clientStatuses;
@property (nonatomic , assign) BOOL acceptNew;

@end
