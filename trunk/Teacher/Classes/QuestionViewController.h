//
//  QuestionViewController.h
//  Teacher
//
//  Created by Adrian Smith on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol QuestionViewControllerDelegate

- (void) nextQuestion;
- (void) previousQuestion;

@end


@interface QuestionViewController : UIViewController {
	NSDictionary* question;
	NSObject <QuestionViewControllerDelegate> *delegate;
	IBOutlet UITextView* questionText;
	IBOutlet UIButton* nextButton;
	IBOutlet UIButton* prevButton;
	
	id defaultValue;
}

- (QuestionResponseType) questionResponseType;
- (id) responseValue;

- (IBAction) next;
- (IBAction) previous;

@property (nonatomic , retain) NSDictionary* question;
@property (nonatomic , retain) NSObject <QuestionViewControllerDelegate> *delegate;
@property (nonatomic , readonly) UIButton* nextButton;
@property (nonatomic , readonly) UIButton* prevButton;
@property (nonatomic , retain) id defaultValue;

@end
