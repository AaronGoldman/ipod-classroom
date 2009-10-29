//
//  ConnectedDevicesViewController.h
//  Teacher
//
//  Created by Adrian Smith on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Supervisor.h"

@interface ConnectedDevicesViewController : UITableViewController <SupervisorDelegate,GKSessionDelegate>{
	NSMutableArray* devices;
	Supervisor* supervisor;
}

@property (nonatomic , retain) NSMutableArray* devices;
@property (nonatomic , retain) Supervisor* supervisor;

@end
