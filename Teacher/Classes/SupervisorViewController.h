//
//  SupervisorViewController.h
//  Teacher
//
//  Created by Adrian Smith on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizServiceHttpServer.h"

@interface SupervisorViewController : UIViewController <QuizServiceHttpServerDelegate,UIWebViewDelegate>{
	IBOutlet UILabel* completedLabel;
	IBOutlet UILabel* disconnectedLabel;
	IBOutlet UILabel* authenticatedLabel;
	IBOutlet UISwitch* acceptNewSwitch;
	IBOutlet UIWebView* webView;
	
	QuizServiceHttpServer* httpServer;
	int tid;
	
	
}


- (IBAction) valueChanged:(id)component;

- (void) showEvent:(NSString*)eventName description:(NSString*)eventDescription class:(NSString*)eventClass;
- (void) showAuthenticatedEvent:(NSString*) studentName;
- (void) showCompletedEvent:(NSString*) studentName;
- (void) showGeneralEvent:(NSString*)eventName description:(NSString*)eventDescription;
- (void) showFailureEvent:(NSString*) eventName description:(NSString*)eventDescription;

@property (nonatomic , retain) QuizServiceHttpServer* httpServer;
@property (nonatomic , assign) int tid;
@end
