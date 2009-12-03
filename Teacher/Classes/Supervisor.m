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
#import "MultipleChoiceQuestion.h"
#import "QuestionsRequest.h"
#import "DatabaseConnection.h"

#define kSessionID @"iResponse"
#define kDisplayName @"iResponse"

@implementation Supervisor
@synthesize gkSession;
@synthesize test;
@synthesize delegate;
@synthesize clientStatuses;
@synthesize acceptNew;

- (id) init{
	if (self = [super init]){
		self.clientStatuses = [NSMutableArray arrayWithCapacity:40];
	}
	return self;
}

- (void) start{
	self.gkSession = [[GKObjectSession alloc] initWithSessionID:kSessionID displayName:kDisplayName sessionMode:GKSessionModeServer];
	gkSession.available = YES;
	gkSession.delegate = self;
	[gkSession setDataReceiveHandler:self withContext:nil];
	
	[gkSession release];
	NSLog(@"starting supervisor");
}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSLog(@"received object: %@", receivedObject);
	
	ClientStatus* client = [self clientWithPeerID:peer];
	if ( [receivedObject isKindOfClass:[NSArray class]]){
		for( id request in receivedObject){
			[self processRequest:request fromClient:client];
		}		
	}else{
		[self processRequest:receivedObject fromClient:client];
	}
	
}

- (void) processRequest:(id)request fromClient:(ClientStatus*)client{
	if( [request isKindOfClass:[LoginRequest class]]){
		[self receivedLoginRequest:request fromClient:client];
	}else if ( [request isKindOfClass:[TestResponsesRequest class] ]){
		
		[self receivedTestResponsesRequest:request fromClient:client];
	}else if ( [request isKindOfClass:[DeviceInfoRequest class]]){
		[self receivedDeviceInfoRequest:request fromClient:client];
	}
}

- (void) receivedDeviceInfoRequest:(DeviceInfoRequest*)info fromClient:(ClientStatus*)client{
	
	ClientStatus* deadStatus = [self clientWithUdid:info.udid];
	if( deadStatus && deadStatus != client){
		[clientStatuses removeObject:deadStatus];
	}
	
	client.clientState = ClientStateConnected;
	[self.delegate supervisorDidHaveClientChangeState:self];
	
	NSLog(@"recieved device info");
	client.udid = [info.udid stringByReplacingOccurrencesOfString:@"'" withString:@""];
	NSArray* results = [DatabaseConnection executeSelect:[NSString stringWithFormat:@"select * from student where udid='%@'",client.udid]];
	NSLog(@"results: %@" , results);
	if( [results count] >= 1){
		NSDictionary* info = [results objectAtIndex:0];
		client.firstName = [info objectForKey:@"firstname"];
		client.lastName  = [info objectForKey:@"lastname"];
		client.passHash  = [info objectForKey:@"passhash"];
	}
}

- (void) receivedTestResponsesRequest:(TestResponsesRequest*)testResponsesRequest fromClient:(ClientStatus*)client{
	NSLog(@"processing responses");
	NSUInteger i, count = [testResponsesRequest.responses count];
	for (i = 0; i < count; i++) {
		Response* obj = [testResponsesRequest.responses objectAtIndex:i];
		NSLog(@"answer[%d,qid=%d] is %@" , i, obj.qid, [NSKeyedUnarchiver unarchiveObjectWithData:obj.data]);
	}
}

- (void) receivedLoginRequest:(LoginRequest*)loginRequest fromClient:(ClientStatus*)client{
	
	NSLog(@"processing login");
	NSMutableArray* requests = [NSMutableArray arrayWithCapacity:5];
	
	LoginRequestReply* reply = [[LoginRequestReply alloc] init];
	
	reply.authenticated = NO;
	if ([loginRequest.firstName isEqual:client.firstName] && 
		[loginRequest.lastName isEqual:client.lastName] && 
		[loginRequest.udid isEqual:client.udid] && 
		[loginRequest.passwordHash isEqual:client.passHash])
	{
		NSLog(@"%@ %@ authenticated" , loginRequest.firstName , loginRequest.lastName);
		client.clientState = ClientStateAuthenticated;
		[self.delegate supervisorDidHaveClientChangeState:self];
		reply.authenticated = YES;
		NSMutableArray* questions = [NSMutableArray arrayWithCapacity:10];
		QuestionsRequest* qrequest = [[QuestionsRequest alloc] init];
		
		Question* question = [[Question alloc] init];
		question.text = @"What's up?";
		question.responseType = QuestionResponseTypeText;
		[questions addObject:question];
		question.qid = 1;
		[question release];
		
		question = [[Question alloc] init];
		question.qid = 2;
		question.text = @"How are you?";
		question.responseType = QuestionResponseTypeNumeric;
		[questions addObject:question];
		[question release];
		
		MultipleChoiceQuestion* mquestion = [[MultipleChoiceQuestion alloc] init];
		mquestion.text = @"Pick one";
		mquestion.qid = 3;
		mquestion.possibleAnswers = [NSMutableArray arrayWithObjects:@"one",@"two",@"three",nil];
		[questions addObject:mquestion];
		[mquestion release];
		
		question = [[Question alloc] init];
		question.qid = 4;
		question.text = @"hiasdfad?";
		question.responseType = QuestionResponseTypeBoolean;
		[questions addObject:question];
		[question release];
		
		qrequest.questions = questions;
		[requests addObject:qrequest];
		[qrequest release];
		
	}else if(acceptNew && client.passHash == nil){
		NSLog(@"would set to pending, but by passing");
		client.clientState = ClientStateAuthenticated;
		reply.authenticated = YES;
		loginRequest.firstName		= [loginRequest.firstName stringByReplacingOccurrencesOfString:@"'" withString:@""];
		loginRequest.lastName		= [loginRequest.lastName stringByReplacingOccurrencesOfString:@"'" withString:@""];
		loginRequest.passwordHash	= [loginRequest.passwordHash stringByReplacingOccurrencesOfString:@"'" withString:@""];

		NSString* query = [NSString stringWithFormat:@"insert into student (firstname, lastname, udid, passhash) values('%@','%@','%@','%@');",loginRequest.firstName,loginRequest.lastName, loginRequest.udid,loginRequest.passwordHash];
		[DatabaseConnection executeSelect:query];
		
		[self.delegate supervisorDidHaveClientChangeState:self];
		
		NSMutableArray* questions = [NSMutableArray arrayWithCapacity:10];
		QuestionsRequest* qrequest = [[QuestionsRequest alloc] init];
		
		Question* question = [[Question alloc] init];
		question.text = @"What's up?";
		question.responseType = QuestionResponseTypeText;
		[questions addObject:question];
		question.qid = 1;
		[question release];
		
		question = [[Question alloc] init];
		question.qid = 2;
		question.text = @"How are you?";
		question.responseType = QuestionResponseTypeNumeric;
		[questions addObject:question];
		[question release];
		
		MultipleChoiceQuestion* mquestion = [[MultipleChoiceQuestion alloc] init];
		mquestion.text = @"Pick one";
		mquestion.qid = 3;
		mquestion.possibleAnswers = [NSMutableArray arrayWithObjects:@"one",@"two",@"three",nil];
		[questions addObject:mquestion];
		[mquestion release];
		
		question = [[Question alloc] init];
		question.qid = 4;
		question.text = @"hiasdfad?";
		question.responseType = QuestionResponseTypeBoolean;
		[questions addObject:question];
		[question release];
		
		qrequest.questions = questions;
		[requests addObject:qrequest];
		[qrequest release];
	}else{
		NSLog(@"could not log in %@ %@" , loginRequest.firstName, loginRequest.lastName);		
	}

	[requests addObject:reply];
	[reply release];

	[gkSession sendObject:requests toPeer:client.peerID];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
	[session acceptConnectionFromPeer:peerID error:nil];
	NSLog(@"accepting peer connection: %@" , peerID );
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
	NSLog(@"peer connection failed: %@ , %@" , peerID , error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
	NSLog(@"connection failed with error: %@" , error);
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{

	
	ClientStatus* status = [self clientWithPeerID:peerID];
	
	if ( status == nil){
		status = [[ClientStatus alloc] init];
		status.peerID = peerID;
		[clientStatuses addObject:status];
		[status release];
	}
	
	if ( state == GKPeerStateConnected){
		NSLog(@"Student connected connected");
//		[devices addObject:peerID];
//		[self.tableView reloadData];
	}else if ( state == GKPeerStateDisconnected){
		status.clientState = ClientStateDisconnected;
		[self.delegate supervisorDidHaveClientChangeState:self];
	}
	NSLog(@"state did change: %d" , state);
}

- (ClientStatus*) clientWithPeerID:(NSString*)peerID{
	for ( ClientStatus* status in clientStatuses){
		if ( [peerID isEqual:status.peerID]){
			return status;
		}
	}
	return nil;
}

- (ClientStatus*) clientWithUdid:(NSString*)udid{
	for ( ClientStatus* status in clientStatuses){
		if ( [udid isEqual:status.udid]){
			return status;
		}
	}
	return nil;
}
- (NSArray*) clientsWithState:(ClientState)clientState{
	NSMutableArray* clients = [NSMutableArray arrayWithCapacity:40];
	for( ClientStatus* status in clientStatuses){
		if ( clientState == status.clientState){
			[clients addObject:status];
		}
	}
	return clients;
}

- (NSArray*) disconnectedClients{
	return [self clientsWithState:ClientStateDisconnected];
}

- (NSArray*) connectedClients{
	return [self clientsWithState:ClientStateConnected];
}

- (NSArray*) pendingClients{
	return [self clientsWithState:ClientStatePending];
}

- (void) dealloc{
	[clientStatuses release];
	[delegate release];
	[gkSession release];
	[test release];
	[super dealloc];
}
@end
