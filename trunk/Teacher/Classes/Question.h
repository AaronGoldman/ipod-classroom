//
//  Question.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	QuestionResponseTypeText = 1,
	QuestionResponseTypeNumeric,
	QuestionResponseTypeMutipleChoice,
	QuestionResponseTypeBoolean
} QuestionResponseType;


@interface Question : NSObject <NSCoding>{
	NSString* text;
	QuestionResponseType responseType;
	NSDate* date;
	int qid;
	int tid;
}

@property (nonatomic , retain) NSString* text;
@property (nonatomic , retain) NSDate* date;
@property (nonatomic , assign) QuestionResponseType responseType;
@property (nonatomic , assign) int qid;
@property (nonatomic , assign) int tid;
@end

