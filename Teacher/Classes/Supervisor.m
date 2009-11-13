//
//  Supervisor.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Supervisor.h"
#import "LoginRequestReply.h"
#import "Question.h"

#define kSessionID @"iResponse"
#define kDisplayName @"iResponse"

@implementation Supervisor
@synthesize gkSession;
@synthesize test;
@synthesize delegate;

- (id) init{
	if (self = [super init]){
		
	}
	return self;
}

- (void) start{
	self.gkSession = [[GKObjectSession alloc] initWithSessionID:kSessionID displayName:kDisplayName sessionMode:GKSessionModeServer];
	gkSession.available = YES;
	gkSession.delegate = delegate;
	[gkSession setDataReceiveHandler:self withContext:nil];
	
	[gkSession release];
	NSLog(@"starting supervisor");
}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSLog(@"received object: %@", receivedObject);

	if( [receivedObject isKindOfClass:[LoginRequest class]]){
		[self receivedLoginRequest:receivedObject fromPeer:peer];
	}
	
}

- (void) receivedLoginRequest:(LoginRequest*)loginRequest fromPeer:(NSString*)peer{
	
	NSLog(@"processing login");

	LoginRequestReply* reply = [[LoginRequestReply alloc] init];

	//check password and hash, and then set authenticated	
	reply.authenticated = YES;
	
	if( reply.authenticated){
		NSMutableArray* questions = [NSMutableArray arrayWithCapacity:10];
		
		Question* question = [[Question alloc] init];
		question.text = @"What's up?";
		question.responseType = QuestionResponseTypeText;
		[questions addObject:question];
		[question release];
		
		question = [[Question alloc] init];
		question.text = @"How are you?";
		question.responseType = QuestionResponseTypeNumeric;
		[questions addObject:question];
		[question release];
		
		reply.questions = questions;
	}
	
	[gkSession sendObject:reply toPeer:peer];
}


- (void) dealloc{
	[delegate release];
	[gkSession release];
	[test release];
	[super dealloc];
}
@end
