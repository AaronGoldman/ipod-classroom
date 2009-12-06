//
//  AppDelegate.m
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseConnection.h"
#import "Util.h"

@implementation AppDelegate
@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	NSLog(@"app dir: %@" , [Util appDir]); 
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	//Create a server directory
	NSString* toDirectory = [[Util appDir] stringByAppendingPathComponent:@"www"];
	if( ![[NSFileManager defaultManager] fileExistsAtPath:toDirectory]){
		[[NSFileManager defaultManager] createDirectoryAtPath:toDirectory attributes:nil];
	}
	//Copy all, html, js, and htm files to the server directory
	NSMutableArray* pathsForServerFiles = [NSMutableArray arrayWithCapacity:50];
	[pathsForServerFiles addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"css" inDirectory:nil]];
	[pathsForServerFiles addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"html" inDirectory:nil]];
	[pathsForServerFiles addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"js" inDirectory:nil]];
	[pathsForServerFiles addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"htm" inDirectory:nil]];
	NSError* error = nil;
	for ( NSString* path in pathsForServerFiles){
		NSString* filename = [path lastPathComponent];
		NSString* toPath = [toDirectory stringByAppendingPathComponent:filename];
		[[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
		[[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath  error:&error];
		if ( error){
			NSLog(@"error copying server file <%@>: %@" ,filename, error );
			error = nil;
		}
	}

//	
////[DatabaseConnection executeSelect:@"INSERT INTO class (name, class_id) VALUES ('Tim', NULL);"];
////	[DatabaseConnection executeSelect:@"INSERT INTO manswer (qid) VALUES (5);"];
////	[DatabaseConnection executeSelect:@"DELETE FROM class WHERE class_id>3;"];
//		NSArray* vals = [DatabaseConnection executeSelect:@"SELECT * FROM manswer WHERE qid>0"];
//	
//	NSLog(@"vals: %@", vals);
//	//NSLog(@"val: %@" , [vals objectAtIndex:1]);
//	//int thirdRowVal = [[[vals objectAtIndex:1] objectForKey:@"class_id"] intValue];
//	
//	//id object;
//	NSLog(@"object name: %@",vals);
//	//NSLog(@"Row: %d",thirdRowVal);


}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
