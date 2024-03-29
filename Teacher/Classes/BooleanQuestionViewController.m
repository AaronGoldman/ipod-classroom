//
//  BooleanQuestionViewController.m
//  Teacher
//
//  Created by Adrian Smith on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BooleanQuestionViewController.h"


@implementation BooleanQuestionViewController

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

	if( defaultValue != nil){
		responseSegmentedControl.selectedSegmentIndex = [defaultValue boolValue] ? 0 : 1;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
/*
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	

}
 */

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (QuestionResponseType) questionResponseType{
	return QuestionResponseTypeBoolean;
}

- (id) responseValue{
	//For the segmented control
	//index 0 is true which is represented by the int 1,
	//index 1 is false which is represented by the int 0
	int response = responseSegmentedControl.selectedSegmentIndex == 1 ? 0 : 1;
	return [NSNumber numberWithInt:response];
}

- (void)dealloc {
    [super dealloc];
}


@end
