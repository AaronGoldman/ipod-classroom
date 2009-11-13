//
//  ResponseRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResponseRequest.h"


@implementation ResponseRequest
@synthesize response;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		self.response	= [coder decodeObjectForKey:@"response"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:response		forKey:@"response"];
}


- (void) dealloc{
	
	[response release];
	[super dealloc];
}

@end
