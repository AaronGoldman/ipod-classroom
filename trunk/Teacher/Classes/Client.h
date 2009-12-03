//
//  Client.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "LoginRequestReply.h"
#import "GKObjectSession.h"
#import "QuestionsRequest.h"

@class Client;
@protocol ClientDelegate

- (void) client:(Client*)client didReceiveQuestions:(NSArray*)question;
- (void) clientDidFailAuthentication:(Client*)client;
- (void) clientDidAuthenticate:(Client*)client;

@end


@interface Client : NSObject <GKSessionDelegate> {

	NSString* firstName;
	NSString* lastName;
	NSString* passwordHash;
	GKObjectSession* gkSession;
	BOOL authenticated;
	NSObject <GKSessionDelegate, ClientDelegate> *delegate;
	BOOL loginOnConnect;
}

+ (Client*)getInstance;
- (void) login;
- (void) sendDeviceInfo;
- (void) start;
- (void) sendTestResponses:(NSMutableArray*)testResponses;

- (void) receivedLoginRequestReply:(LoginRequestReply*)reply;
- (void) receivedQuestionsRequest:(QuestionsRequest*)request;
- (void) processRequest:(id)request;


@property (nonatomic , retain) NSString* firstName;
@property (nonatomic , retain) NSString* lastName;
@property (nonatomic , retain) NSString* passwordHash;
@property (nonatomic , retain) GKObjectSession* gkSession;
@property (nonatomic , retain) NSObject <ClientDelegate> *delegate;
@property (nonatomic , assign) BOOL authenticated;
@property (nonatomic , assign) BOOL loginOnConnect;

@end
