//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"


@interface MyHTTPConnection : HTTPConnection
{
	int dataStartIndex;
	NSMutableArray* multipartData;
	BOOL postHeaderOK;
	NSMutableDictionary* postDataParams;
}

- (BOOL)isBrowseable:(NSString *)path;
- (NSString *)createBrowseableIndex:(NSString *)path;

- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength;

- (NSString*) processPostData:(NSDictionary*)data forFile:(NSString*)fileName;
- (NSString*) handleClassSubmit:(NSDictionary*)data;
- (NSString*) handleTestSubtmit:(NSDictionary*)data;


@property (nonatomic , retain) NSMutableDictionary* postDataParams;

@end