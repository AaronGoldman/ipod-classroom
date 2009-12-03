//
//  LoginRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoginRequest.h"


@implementation LoginRequest
@synthesize firstName;
@synthesize lastName;
@synthesize passwordHash;
@synthesize udid;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.firstName			= [coder decodeObjectForKey:@"firstName"];
		self.lastName			= [coder decodeObjectForKey:@"lastName"];
		self.udid				= [coder decodeObjectForKey:@"udid"];
		self.passwordHash		= [coder decodeObjectForKey:@"passwordHash"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:passwordHash		forKey:@"passwordHash"];
	[coder encodeObject:udid				forKey:@"udid"];
	[coder encodeObject:firstName			forKey:@"firstName"];
	[coder encodeObject:lastName			forKey:@"lastName"];
}

- (void) dealloc{
	[udid release];
	[passwordHash release];
	[firstName release];
	[lastName release];
	[super dealloc];
}
@end
