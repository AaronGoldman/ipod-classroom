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

- (void) next;
- (void) previous;

@end


@interface QuestionViewController : UIViewController {
	Question* question;
	NSObject <QuestionViewControllerDelegate> *delegate;
	IBOutlet UITextView* questionText;
	
}

- (QuestionResponseType) questionResponseType;
- (NSData*) responseData;

- (IBAction) next;
- (IBAction) previous;

@property (nonatomic , retain) Question* question;
@property (nonatomic , retain) NSObject <QuestionViewControllerDelegate> *delegate;

@end
