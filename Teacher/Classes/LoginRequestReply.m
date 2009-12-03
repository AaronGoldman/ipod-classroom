//
//  LoginRequestReply.m
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoginRequestReply.h"


@implementation LoginRequestReply
@synthesize authenticated;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.authenticated	= [coder decodeBoolForKey:@"authenticated"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeBool:authenticated		forKey:@"authenticated"];
}


- (void) dealloc{
	
	[super dealloc];
}
@end
