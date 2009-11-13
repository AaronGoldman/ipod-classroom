//
//  Question.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize text;
@synthesize date;
@synthesize responseType;
@synthesize qid;
@synthesize tid;


- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.text			= [coder decodeObjectForKey:@"text"];
		self.date			= [coder decodeObjectForKey:@"date"];
		self.responseType	= [coder decodeIntForKey:@"responseType"];
		self.qid			= [coder decodeIntForKey:@"qid"];
		self.tid			= [coder decodeIntForKey:@"tid"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:text		forKey:@"text"];
	[coder encodeObject:date		forKey:@"date"];
	[coder encodeInt:responseType	forKey:@"responseType"];
	[coder encodeInt:qid			forKey:@"qid"];
	[coder encodeInt:tid			forKey:@"tid"];
}


- (void) dealloc{
	[text release];
	[date release];
	
	[super dealloc];
}
@end
