//
//  LoginViewController.m
//  Student
//
//  Created by Adrian Smith on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "TestNavigationController.h"

#import "Util.h"

@implementation LoginViewController
@synthesize tableView;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	tableView.backgroundColor = [UIColor clearColor];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITextField* textField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 5.5, 5.5)];
		textField.center = cell.contentView.center;
		textField.frame = CGRectMake((int)textField.frame.origin.x, (int)textField.frame.origin.y, (int)textField.frame.size.width, (int)textField.frame.size.height);
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		if ( indexPath.row == 0){
			textField.tag = 1;
			textField.placeholder = @"First name";
			[textField becomeFirstResponder];
		}else if ( indexPath.row == 1){
			textField.tag = 1;
			textField.placeholder = @"Last name";
			[textField becomeFirstResponder];
		}else if ( indexPath.row == 2){
			textField.tag = 1;
			textField.secureTextEntry = YES;
			textField.placeholder = @"Password";
		}else{
			NSLog(@"Login Table View: unexpected row: %@" , indexPath.row);
		}
		
		[cell.contentView addSubview:textField];
		[textField release];
    }
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (IBAction) connect{
	NSString* firstName = [(UITextField*)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1] text];
	NSString* lastName = [(UITextField*)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:1] text];
	NSString* password = [(UITextField*)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:1] text];
	
	if ( firstName && lastName && password){
		NSLog(@"firstName: %@" , firstName);
		NSLog(@"lastName: %@" , lastName);
		NSLog(@"password: %@" , password);
		
		
		TestNavigationController* vc = [[TestNavigationController alloc] init];
		vc.firstName = firstName;
		vc.lastName = lastName;
		vc.passWord = password;
		[self presentModalViewController:vc animated:YES];
		[vc release];
	}else{
		[Util showAlertWithTitle:@"Erroneous" message:@"Please fill in all fields."];
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

