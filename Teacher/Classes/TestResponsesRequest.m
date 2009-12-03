//
//  TestResponsesRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestResponsesRequest.h"


@implementation TestResponsesRequest
@synthesize responses;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.responses		= [coder decodeObjectForKey:@"responses"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:responses		forKey:@"responses"];
}

- (void) dealloc{
	[responses release];
	[super dealloc];
}

@end
