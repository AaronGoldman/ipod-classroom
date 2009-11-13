//
//  MultipleChoiceQuestionViewController.h
//  Teacher
//
//  Created by Adrian Smith on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleChoiceQuestion.h"

@interface MultipleChoiceQuestionViewController : UIViewController {

}

@property (nonatomic , readonly, getter=question) MultipleChoiceQuestion* mquestion;

@end
