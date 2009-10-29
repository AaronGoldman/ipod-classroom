//
//  LoginViewController.h
//  Student
//
//  Created by Adrian Smith on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
	UITableView* tableView;
}

- (IBAction) connect;

@property (nonatomic , assign) IBOutlet UITableView* tableView;

@end
