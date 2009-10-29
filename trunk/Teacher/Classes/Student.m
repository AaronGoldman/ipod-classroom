//
//  Student.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Student.h"


@implementation Student

@synthesize udid;
@synthesize firstName;
@synthesize lastName;
@synthesize passwordHash;
@synthesize studentID;


- (void) dealloc{
	[udid release];
	[firstName release];
	[lastName release];
	[passwordHash release];
	[super dealloc];
}
@end

