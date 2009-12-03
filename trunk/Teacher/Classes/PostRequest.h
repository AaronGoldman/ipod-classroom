//
//  PostRequest.h
//  Facebook
//
//  Created by Adrian Smith on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetRequest.h"

@interface PostRequest : GetRequest {
	NSDictionary* postValues;
}

+ (NSString*) getPostString:(NSDictionary*)postData;
- (id)initWithURLString:(NSString*)url data:(NSDictionary*)_postValues;

@property (nonatomic , retain) NSDictionary* postValues;

@end
