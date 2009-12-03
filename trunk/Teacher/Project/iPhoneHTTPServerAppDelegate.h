//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import <UIKit/UIKit.h>
@class   HTTPServer;

@interface iPhoneHTTPServerAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	HTTPServer *httpServer;
	NSDictionary *addresses;
	
	IBOutlet UILabel *displayInfo;
	
	NSNetService* netService;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSNetService* netService;

-(IBAction) startStopServer:(id)sender;
@end

