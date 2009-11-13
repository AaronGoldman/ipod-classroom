//
//  LoginRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoginRequest.h"


@implementation LoginRequest
@synthesize userName;
@synthesize passwordHash;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.userName			= [coder decodeObjectForKey:@"userName"];
		self.passwordHash		= [coder decodeObjectForKey:@"passwordHash"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:passwordHash		forKey:@"passwordHash"];
	[coder encodeObject:userName		forKey:@"userName"];
}

- (void) dealloc{
	[passwordHash release];
	[userName release];
	[super dealloc];
}
@end
