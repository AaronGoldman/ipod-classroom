//
//  GKObjectRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GKObjectRequest.h"


@implementation GKObjectRequest
@synthesize toPeer;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"objectVersion"];
		
		self.toPeer		= [coder decodeObjectForKey:@"toPeer"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"objectVersion"];
	
	[coder encodeObject:toPeer		forKey:@"toPeer"];
}

- (void) dealloc{
	[toPeer release];
	[super dealloc];
}

@end
