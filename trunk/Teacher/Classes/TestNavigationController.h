//
//  TestNavigationController.h
//  Teacher
//
//  Created by Adrian Smith on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiClient.h"
#import "ConnectingViewController.h"
#import "QuestionViewController.h"
#import "FinishedViewController.h"

@interface TestNavigationController : UIViewController <WifiClientDelegate,QuestionViewControllerDelegate, FinishedViewControllerDelegate>{
	ConnectingViewController* connectingViewController;
	NSMutableArray* questions;
	QuestionViewController* currentQuestionViewController;
	int currentQuestionIndex;
	NSMutableDictionary* responses;
	NSString* firstName;
	NSString* lastName;
	NSString* passWord;
	WifiClient* client;
	
	UIAlertView* statusAlertView;
}

- (void) failAndClose:(NSString*)message;
- (void) addResponseFromQuestionViewController:(QuestionViewController*)qvc;
- (void) showQuestionAtIndex:(int)index;
- (void) backFromFinish;
- (void) finish;
- (void) clean;

@property (nonatomic , retain) ConnectingViewController* connectingViewController;
@property (nonatomic , retain) NSMutableArray* questions;
@property (nonatomic , retain) QuestionViewController* currentQuestionViewController;
@property (nonatomic , retain) NSMutableDictionary* responses;
@property (nonatomic , retain) NSString* firstName;
@property (nonatomic , retain) NSString* lastName;
@property (nonatomic , retain) NSString* passWord;
@property (nonatomic , retain) WifiClient* client;
@property (nonatomic , retain) UIAlertView* statusAlertView;

@end
