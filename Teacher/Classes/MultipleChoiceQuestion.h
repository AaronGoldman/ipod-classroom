//
//  MultipleChoiceQuestion.h
//  Teacher
//
//  Created by Adrian Smith on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface MultipleChoiceQuestion : Question {
	NSMutableArray* possibleAnswers;
}

@property (nonatomic , retain) NSMutableArray* possibleAnswers;

@end
