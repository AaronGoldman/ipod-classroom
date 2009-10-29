//
//  Client.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Question.h"

@class Client;
@protocol ClientDelegate

- (void) client:(Client*)client didReceiveQuestions:(NSArray*)question;

@end


@interface Client : NSObject {

	NSString* userName;
	NSString* passwordHash;
	GKSession* gkSession;
	NSObject <GKSessionDelegate, ClientDelegate> *delegate;
}

- (void) loginWithUserName:(NSString*)username passwordHash:(NSString*)passwordHash;
- (void) start;

@property (nonatomic , retain) NSString* userName;
@property (nonatomic , retain) NSString* passwordHash;
@property (nonatomic , retain) GKSession* gkSession;
@property (nonatomic , retain) NSObject <GKSessionDelegate,ClientDelegate> *delegate;

@end
