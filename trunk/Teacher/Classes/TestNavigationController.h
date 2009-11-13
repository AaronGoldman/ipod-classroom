//
//  TestNavigationController.h
//  Teacher
//
//  Created by Adrian Smith on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "ConnectingViewController.h"

@interface TestNavigationController : UIViewController <ClientDelegate>{
	ConnectingViewController* connectingViewController;
}

@property (nonatomic , retain) ConnectingViewController* connectingViewController;

@end
