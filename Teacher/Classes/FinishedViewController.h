//
//  FinishedViewController.h
//  Teacher
//
//  Created by Adrian Smith on 11/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishedViewControllerDelegate

- (void) finish;
- (void) backFromFinish;

@end


@interface FinishedViewController : UIViewController {
	NSObject <FinishedViewControllerDelegate> *delegate;
}

- (IBAction) prev;
- (IBAction) finish;

@property (nonatomic , retain) NSObject <FinishedViewControllerDelegate> *delegate;

@end
