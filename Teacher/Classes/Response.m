//
//  Response.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response
@synthesize data;
@synthesize date;
@synthesize udid;
@synthesize qid;


- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super init]){
		//version not need, but maybe later
		//int version = [coder decodeIntForKey:@"version"];
		
		self.data			= [coder decodeObjectForKey:@"data"];
		self.date			= [coder decodeObjectForKey:@"date"];
		self.udid			= [coder decodeObjectForKey:@"udid"];
		self.qid			= [coder decodeIntForKey:@"qid"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeInt:1 forKey:@"version"];
	
	[coder encodeObject:data		forKey:@"data"];
	[coder encodeObject:date		forKey:@"date"];
	[coder encodeObject:udid		forKey:@"udid"];
	[coder encodeInt:qid			forKey:@"qid"];
}

- (void) dealloc{
	[udid release];
	[data release];
	[date release];
	[super dealloc];
}

@end
