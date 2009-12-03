//
//  ClientStatus.m
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ClientStatus.h"


@implementation ClientStatus

@synthesize udid;
@synthesize peerID;
@synthesize firstName;
@synthesize lastName;
@synthesize passHash;
@synthesize clientState;

- (void) dealloc{
	[udid release];
	[peerID release];
	[firstName release];
	[lastName release];
	[passHash release];
	[super dealloc];
}

@end
