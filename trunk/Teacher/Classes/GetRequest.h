//
//  GetRequest.h
//  Facebook
//
//  Created by Adrian Smith on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GetRequest : NSMutableURLRequest {
	NSMutableData *receivedData;
	id responseDelegate;
	SEL responseSelector;
	SEL failSelector;
}

- (void) send:(id)_responseDelegate onSuccess:(SEL)_responseSelector onFail:(SEL)_failSelector;
+ (char) checksum:(char*)ptr length:(size_t)length;
- (id)initWithURLString:(NSString*)url;

@property (nonatomic, retain) id responseDelegate;
@property (assign) SEL responseSelector;
@property (assign) SEL failSelector;
@property (assign, nonatomic) NSMutableData* receivedData;


@end
