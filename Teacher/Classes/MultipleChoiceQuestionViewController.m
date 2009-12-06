//
//  MultipleChoiceQuestionViewController.m
//  Teacher
//
//  Created by Adrian Smith on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MultipleChoiceQuestionViewController.h"


@implementation MultipleChoiceQuestionViewController
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
	
	if ( defaultValue != nil){
		int row = [defaultValue intValue];
		[pickerView selectRow:row inComponent:0 animated:NO];
	}
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [[[self.question objectForKey:@"possibleAnswers"] objectAtIndex:row] objectForKey:@"answer"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [[self.question objectForKey:@"possibleAnswers"] count];
}

- (QuestionResponseType) questionResponseType{
	return QuestionResponseTypeMutipleChoice;
}

- (id) responseValue{
	return [NSNumber numberWithInt:[pickerView selectedRowInComponent:0]];

}

- (void)dealloc {
    [super dealloc];
}


@end
