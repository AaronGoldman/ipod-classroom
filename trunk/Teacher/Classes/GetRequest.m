//
//  GetRequest.m
//  Facebook
//
//  Created by Adrian Smith on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GetRequest.h"


@implementation GetRequest

@synthesize responseDelegate;
@synthesize responseSelector;
@synthesize receivedData;
@synthesize failSelector;

- (id)initWithURLString:(NSString*)url{
	if( self = [super initWithURL:[NSURL URLWithString:url] 
					  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
				  timeoutInterval:20.0f ]){
		
		[self setHTTPMethod:@"GET"];
		
	}
	return self;
	
}

- (void) send:(id)_responseDelegate onSuccess:(SEL)_responseSelector onFail:(SEL)_failSelector{
	self.responseDelegate = _responseDelegate;
	//[self setResponseDelegate:_responseDelegate];
	[self setResponseSelector:_responseSelector];
	[self setFailSelector:_failSelector];
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:self delegate:self];
	if (theConnection) {
		receivedData=[[NSMutableData data] retain];
		// want to make sure we're not garbage collected 
		// since we're the delegate for theConnection object
		// we release ourselves in the same place as the receivedData
		// object to ensure no memory leaks
		[self retain];
	}else{
		NSLog(@"Connection object not made");
	}
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	
	if( [responseDelegate respondsToSelector:failSelector]){
		[responseDelegate performSelector:failSelector withObject:self];
	}else{
		NSLog(@"Could not perform selector");
	}
	
	[self autorelease];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	if( [responseDelegate respondsToSelector:responseSelector]){
		[responseDelegate performSelector:responseSelector withObject:self withObject:receivedData];
	}else{
		NSLog(@"Could not perform selector");
	}
	
    // release the connection, and the data object
    [connection release];
    [receivedData autorelease];
	[self autorelease];
}



+ (char) checksum:(char*)ptr length:(size_t)length{
	char sum = 0;
	for( int i = 0; i < length ;i++){
		sum += ptr[i];
	}
	
	return sum;
}

- (void) dealloc{
	[responseDelegate release];
	[super dealloc];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest=request;
    if (redirectResponse) {
		newRequest = [[[NSURLRequest alloc] initWithURL:[request URL]] autorelease];
    }
    return newRequest;
}


@end
