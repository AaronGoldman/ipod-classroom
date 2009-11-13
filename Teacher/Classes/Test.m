//
//  Test.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Test.h"


@implementation Test
@synthesize name;
@synthesize date;
@synthesize tid;



- (void) dealloc{
	[name release];
	[date release];
	[super dealloc];
}


@end
