//
//  ResponseResultsViewController.m
//  Teacher
//
//  Created by Adrian Smith on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResponseResultsViewController.h"
#import "DatabaseConnection.h"


@implementation ResponseResultsViewController
@synthesize qid;
@synthesize responses;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSString* query = [NSString stringWithFormat:@"Select type,(firstname||' '||substr(lastname,0,1)||'.') as name,data from response inner join student on (student.student_id=response.student_id) inner join question on (question.qid=response.qid) where response.qid=%d", qid];
	NSArray* results = [DatabaseConnection executeSelect:query];
	NSLog(@"results: %@" , results);
	
	self.responses = [NSMutableArray arrayWithCapacity:[results count]];
	for( NSDictionary* result in results){
		id responseValue = [NSKeyedUnarchiver unarchiveObjectWithData:[result objectForKey:@"data"]];
		NSString* studentName = [result objectForKey:@"name"];

		int type = [[result objectForKey:@"type"] intValue];
		
		NSString* responseText = nil;
		int answerIndex;
		NSArray* possibleAnswers;
		switch (type) {

			case 1: //text
			case 2: //numeric
				responseText = [responseValue description];
				break;
			case 3://multiple choice
				answerIndex = [responseValue intValue];
				query = [NSString stringWithFormat:@"select * from manswer where qid=%d",qid];
				possibleAnswers = [DatabaseConnection executeSelect:query];
				responseText = [[[possibleAnswers objectAtIndex:answerIndex] objectForKey:@"answer"] description];
				break;
			case 4://True,false
				responseText = [responseValue boolValue] ? @"True" : @"False";
				break;
			default:
				NSLog(@"invalid question type");
				break;
		}
		
		responseText = [NSString stringWithFormat:@"%@- %@", studentName, responseText];
		[responses addObject:responseText];
		
	}

	NSLog(@"responses: %@" ,responses);
	[self.tableView reloadData];
	
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
    return [responses count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [responses objectAtIndex:indexPath.row];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
	[responses release];
    [super dealloc];
}


@end

