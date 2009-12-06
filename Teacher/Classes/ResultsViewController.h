//
//  ResultsViewController.h
//  Teacher
//
//  Created by Adrian Smith on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultsViewController : UITableViewController {
	NSArray* tests;
}

@property (nonatomic , retain) NSArray* tests;

@end
