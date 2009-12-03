//
//  HopRequest.m
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HopRequest.h"


@implementation HopRequest
@synthesize hops;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super initWithCoder:coder]){
		//version not needed, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.hops		= [coder decodeIntForKey:@"hops"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[super encodeWithCoder:coder];
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeInt:hops forKey:@"hops"];
}
@end
