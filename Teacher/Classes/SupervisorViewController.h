//
//  SupervisorViewController.h
//  Teacher
//
//  Created by Adrian Smith on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Supervisor.h"
#import "QuizServiceHttpServer.h"

@interface SupervisorViewController : UIViewController <SupervisorDelegate>{
	IBOutlet UILabel* connectedLabel;
	IBOutlet UILabel* disconnectedLabel;
	IBOutlet UILabel* authenticatedLabel;
	IBOutlet UISwitch* acceptNewSwitch;
	
	QuizServiceHttpServer* httpServer;
	int tid;
}


- (IBAction) valueChanged:(id)component;

@property (nonatomic , retain) QuizServiceHttpServer* httpServer;
@property (nonatomic , assign) int tid;
@end
