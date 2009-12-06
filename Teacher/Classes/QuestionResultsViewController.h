//
//  QuestionResultsViewController.h
//  Teacher
//
//  Created by Adrian Smith on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionResultsViewController : UITableViewController {
	NSArray* questions;
	int tid;
}

@property (nonatomic , retain) NSArray* questions;
@property (nonatomic , assign) int tid;

@end
