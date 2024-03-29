//
//  QuestionsRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuestionsRequest.h"


@implementation QuestionsRequest
@synthesize questions;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.questions		= [coder decodeObjectForKey:@"questions"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:questions		forKey:@"questions"];
}

- (void) dealloc{
	[questions release];
	[super dealloc];
}

@end
