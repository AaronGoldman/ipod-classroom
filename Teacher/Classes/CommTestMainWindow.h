//
//  CommTestMainWindow.h
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface CommTestMainWindow : UIViewController<GKSessionDelegate> {
	GKSession* inSession;
	GKSession* outSession;
	IBOutlet UILabel* peerIDLabel1;
	IBOutlet UILabel* peerIDLabel2;
	IBOutlet UITextView* errorLog;
	NSNetServiceBrowser* browser;
	IBOutlet UIWebView* webView;
}

@property (nonatomic , retain) NSNetServiceBrowser* browser;


- (IBAction) start;
@end
