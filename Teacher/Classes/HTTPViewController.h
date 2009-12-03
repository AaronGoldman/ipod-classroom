//
//  HTTPViewController.h
//  Teacher
//
//  Created by ece on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTPServer;


@interface HTTPViewController : UIViewController {
	IBOutlet UILabel* displayInfo; 
	HTTPServer *httpServer;
	NSDictionary *addresses;
	NSNetService* netService;
}

@property (nonatomic , retain) NSNetService* netService;

-(IBAction) startStopServer:(id)sender;
- (BOOL) enableBonjourWithDomain:(NSString*)domain applicationProtocol:(NSString*)protocol name:(NSString*)name;

@end
