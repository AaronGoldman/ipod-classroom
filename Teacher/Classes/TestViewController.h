//
//  TestViewController.h
//  Teacher
//
//  Created by Adrian Smith on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestViewController : UITableViewController {
	NSMutableArray* tests;
}

@property (nonatomic , retain) NSMutableArray* tests;

@end
