//
//  QuizServiceHttpServer.m
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuizServiceHttpServer.h"
#import "QuizServiceHTTPConnection.h"

@implementation QuizServiceHttpServer
@synthesize tid;
@synthesize authenticated,completed;
@synthesize acceptNew;
@synthesize quizDelegate;

- (id) initWithTid:(int)_tid{
	if ( self = [super init]){
		self.tid = _tid;
		connectionClass = [QuizServiceHttpConnection self];
		[self setType:@"_http._tcp."];
		[self setName:@"teacher_quiz"];
		self.authenticated = [[NSMutableDictionary alloc] initWithCapacity:40];
		[authenticated release];
		
		self.completed = [[NSMutableDictionary alloc] initWithCapacity:40];
		[completed release];
	}
	
	return self;
}

- (void)setConnectionClass:(Class)value
{
	if( [value isKindOfClass:[QuizServiceHttpConnection class]]){
		[super setConnectionClass:value];
	}else{
		[[NSException exceptionWithName:@"Invalid Connection Type" 
								reason:@"This Server type only accepts connection types of class QuizServiceHttpConnect" 
							  userInfo:nil] raise];
	}
}

- (void) dealloc{
	[quizDelegate release];
	[authenticated release];
	[completed release];
	[super dealloc];
}

@end
