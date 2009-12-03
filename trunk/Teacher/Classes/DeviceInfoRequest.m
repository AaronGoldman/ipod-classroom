//
//  DeviceInfoRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DeviceInfoRequest.h"


@implementation DeviceInfoRequest
@synthesize udid;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.udid		= [coder decodeObjectForKey:@"udid"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:udid		forKey:@"udid"];
}

- (void) dealloc{
	[udid release];
	[super dealloc];
}

@end

