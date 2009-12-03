//
//  PostRequest.m
//  Facebook
//
//  Created by Adrian Smith on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PostRequest.h"
#import "Util.h"

@implementation PostRequest
@synthesize postValues;

- (id)initWithURLString:(NSString*)url data:(NSDictionary*)_postValues{
	if( self = [super initWithURL:[NSURL URLWithString:url] 
					  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
					  timeoutInterval:20.0f ]){
		
		self.postValues = _postValues;
		NSString* postString = [PostRequest getPostString:postValues];
		NSData* postData = [NSData dataWithBytes:[postString UTF8String] length:[postString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		[self setHTTPMethod:@"POST"];
		[self setHTTPBody:postData];

	}
	return self;
	
}


+ (NSString*) getPostString:(NSDictionary*)postData{
	NSString* postString = @"";
	for( NSString* key in postData){
		postString = [postString stringByAppendingString:@"&"];
		postString = [postString stringByAppendingString:key];
		postString = [postString stringByAppendingString:@"="];
		postString = [postString stringByAppendingString:[Util urlEncode:[postData objectForKey:key]]];

	}

	return postString;
}

- (void) dealloc{
	[postValues release];
	[super dealloc];
}


@end
