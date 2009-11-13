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

@class Client;
@protocol ClientDelegate

- (void) client:(Client*)client didReceiveQuestions:(NSArray*)question;

@end


@interface Client : NSObject <GKSessionDelegate> {

	NSString* userName;
	NSString* passwordHash;
	GKObjectSession* gkSession;
	BOOL authenticated;
	NSObject <GKSessionDelegate, ClientDelegate> *delegate;
	BOOL loginOnConnect;
}

+ (Client*)getInstance;
- (void) login;
- (void) start;

- (void) receivedLoginRequestReply:(LoginRequestReply*)reply;

@property (nonatomic , retain) NSString* userName;
@property (nonatomic , retain) NSString* passwordHash;
@property (nonatomic , retain) GKObjectSession* gkSession;
@property (nonatomic , retain) NSObject <ClientDelegate> *delegate;
@property (nonatomic , assign) BOOL authenticated;
@property (nonatomic , assign) BOOL loginOnConnect;

@end
