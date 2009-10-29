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

- (void) dealloc{
	[udid release];
	[data release];
	[date release];
	[super dealloc];
}

@end
