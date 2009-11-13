//
//  MultipleChoiceQuestion.m
//  Teacher
//
//  Created by Adrian Smith on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MultipleChoiceQuestion.h"


@implementation MultipleChoiceQuestion
@synthesize possibleAnswers;

- (id) initWithCoder:(NSCoder*)coder{
	
	if( self = [super initWithCoder:coder]){
		//version not needed, but maybe later
		//int mversion = [coder decodeIntForKey:@"mversion"];
		
		self.possibleAnswers = [coder decodeObjectForKey:@"possibleAnswers"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[super encodeWithCoder:coder];
	
	[coder encodeInt:1 forKey:@"mversion"];
	[coder encodeObject:possibleAnswers forKey:@"possibleAnswers"];
	
}

- (void) dealloc{
	[possibleAnswers release];
	[super dealloc];
}

@end
