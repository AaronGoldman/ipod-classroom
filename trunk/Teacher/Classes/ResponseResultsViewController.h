//
//  ResponseResultsViewController.h
//  Teacher
//
//  Created by Adrian Smith on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResponseResultsViewController : UITableViewController {
	int qid;
	NSMutableArray* responses;
}

@property (nonatomic , retain) NSMutableArray* responses;
@property (nonatomic , assign) int qid;

@end
