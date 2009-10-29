//
//  Question.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize text;
@synthesize date;
@synthesize responseType;
@synthesize qid;
@synthesize tid;

- (void) dealloc{
	[text release];
	[date release];
	
	[super dealloc];
}
@end
