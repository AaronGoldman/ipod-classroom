//
//  TestNavigationController.m
//  Teacher
//
//  Created by Adrian Smith on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestNavigationController.h"
#import "TextQuestionViewController.h"
#import "MultipleChoiceQuestionViewController.h"
#import "NumericQuestionViewController.h"
#import "BooleanQuestionViewController.h"
#import "DoneViewController.h"
#import "Response.h"
#import "Util.h"

@implementation TestNavigationController

@synthesize connectingViewController;
@synthesize questions;
@synthesize currentQuestionViewController;
@synthesize responses;

@synthesize firstName;
@synthesize lastName;
@synthesize client;
@synthesize passWord;
@synthesize statusAlertView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"viewDidLoad");
	
	self.responses = [NSMutableArray arrayWithCapacity:20];
	
	self.client = [[WifiClient alloc] init];
	client.delegate = self;
	[client searchForQuizService];
	NSLog(@"searching for quiz service");
	[client release];
	
	self.connectingViewController = [[ConnectingViewController alloc] init];
	[connectingViewController release];
	[self.view addSubview:connectingViewController.view];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) wifiClient:(WifiClient*)_client didReceiveQuestions:(NSArray*)_questions{
	NSLog(@"recieved questions: %@" , _questions);
	
	self.questions = [NSMutableArray arrayWithArray:_questions];
	
	//remove connection view controller if visible
	if( connectingViewController != nil){
		[self.connectingViewController.view removeFromSuperview];
		self.connectingViewController = nil;
	}
	
	[self showQuestionAtIndex:0];
	
}

- (void) wifiClientDidFailToResolveQuizService:(WifiClient*)client{
	NSLog(@"failed resolving quiz service");
	[self failAndClose:@"Could not resolve teacher device."];
}

- (void) wifiClientDidFailAuthentication:(WifiClient*)client{
	NSLog(@"failed authentication");
	[self failAndClose:@"Incorrect username or password."];
}

- (void) wifiClientDidAuthenticate:(WifiClient*)_client{
	//Do Nothing
	NSLog(@"authenticated");

	[client getQuestions];
}

- (void) wifiClientDidResolveQuizService:(WifiClient*)_client{
	[client authenticateWithFirstName:firstName lastName:lastName password:passWord];
}



- (void) showQuestionAtIndex:(int)index{
	currentQuestionIndex = index;
	
	if( index < 0 || index >= [questions count]){
		NSLog(@"question index out of bounds");
	}
	NSDictionary* question = [questions objectAtIndex:index];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];

	
	if( currentQuestionViewController != nil){
		[currentQuestionViewController.view removeFromSuperview];
		self.currentQuestionViewController = nil;
	}
	
	int responseType = [[question objectForKey:@"type"] intValue];
	switch ( responseType) {
		case QuestionResponseTypeText:
			self.currentQuestionViewController = [[TextQuestionViewController alloc] initWithNibName:@"TextQuestionViewController" 
																							  bundle:nil];
			[currentQuestionViewController release];
			break;
		case QuestionResponseTypeNumeric:
			self.currentQuestionViewController = [[NumericQuestionViewController alloc] initWithNibName:@"NumericQuestionViewController"
																								 bundle:nil];
			[currentQuestionViewController release];
			break;
		case QuestionResponseTypeBoolean:
			self.currentQuestionViewController = [[BooleanQuestionViewController alloc] initWithNibName:@"BooleanQuestionViewController" 
																								 bundle:nil];
			[currentQuestionViewController release];
			break;
		case QuestionResponseTypeMutipleChoice:
			self.currentQuestionViewController = [[MultipleChoiceQuestionViewController alloc] initWithNibName:@"MultipleChoiceQuestionViewController" 
																										bundle:nil];
			[currentQuestionViewController release];
			break;
		default:
			NSLog(@"received unsupported question type: %d", responseType);
			break;
	}
	
	currentQuestionViewController.question = question;
	currentQuestionViewController.delegate = self;
	[self.view addSubview:currentQuestionViewController.view];
	
	if ( index -1 < 0){
		currentQuestionViewController.prevButton.hidden = YES;
	}
	
	[UIView commitAnimations];
	
}

- (void) nextQuestion{
	[self addResponseFromQuestionViewController:self.currentQuestionViewController];
	if ( currentQuestionIndex+1 >= [questions count]){
		FinishedViewController* vc = [[FinishedViewController alloc] initWithNibName:@"FinishedViewController"
																			  bundle:nil];
		vc.delegate = self;
		[self presentModalViewController:vc animated:YES];
		[vc release];
	}else{
		[self showQuestionAtIndex:currentQuestionIndex+1];
	}
}

- (void) previousQuestion{
	[self addResponseFromQuestionViewController:self.currentQuestionViewController];
	[self showQuestionAtIndex:currentQuestionIndex-1];
}

- (void) backFromFinish{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) finish{
	[client submitResponses:responses];
	
	self.statusAlertView = [[UIAlertView alloc] initWithTitle:@"Sending Responses" 
													  message:nil
													 delegate:nil
											cancelButtonTitle:nil
											otherButtonTitles:nil];
	[statusAlertView show];
	[statusAlertView release];

	
}

- (void) wifiClientDidSuccessfullySendResponses:(WifiClient*)client{
	NSLog(@"successfully sent responses");
	[statusAlertView dismissWithClickedButtonIndex:0 animated:YES];
	
	DoneViewController* vc = [[DoneViewController alloc] initWithNibName:@"DoneViewController" 
																  bundle:nil];
	[self dismissModalViewControllerAnimated:NO];
	[self presentModalViewController:vc animated:NO];
	[vc release];
	
	[self clean];
}

- (void) wifiClientSendResponsesDidFail:(WifiClient*)client{
	[statusAlertView dismissWithClickedButtonIndex:0 animated:NO];
	[Util showAlertWithTitle:@"Erroneous!" message:@"Could not send responses. Please check you connection and try again."];
	NSLog(@"could not send responses successfully");
}

- (void) addResponseFromQuestionViewController:(QuestionViewController*)qvc{

	NSDictionary* response = [NSDictionary dictionaryWithObjectsAndKeys:
							  [[UIDevice currentDevice] uniqueIdentifier],@"udid",
							  qvc.responseValue,@"responseValue",
							  [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],@"date",
							  [qvc.question objectForKey:@"qid"],@"qid",
							  nil];
	
	[responses addObject:response];
}

- (void) failAndClose:(NSString*)message{	
	[self.parentViewController dismissModalViewControllerAnimated:YES];

	
	[Util showAlertWithTitle:@"Erroneous!" message:message];
	[self.parentViewController performSelector:@selector(dismissModalViewControllerAnimated:) 
	 withObject:[NSNumber numberWithBool:YES]
	 afterDelay:0.2];
	
	[self clean];
}

- (void) clean{
	self.connectingViewController = nil;
	self.currentQuestionViewController = nil;
	self.client = nil;
}

- (void)dealloc {
	[client release];
	[firstName release];
	[lastName release];
	[passWord release];
	[responses release];
	[connectingViewController release];
	[currentQuestionViewController release];
	[statusAlertView release];
    [super dealloc];
}


@end
