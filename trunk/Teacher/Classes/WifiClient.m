//
//  WifiClient.m
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WifiClient.h"
#import "JSON.h"
#import "PostRequest.h"
#import "Util.h"

@implementation WifiClient
@synthesize browser;
@synthesize baseURL;
@synthesize delegate;
@synthesize foundService;

- (void) searchForQuizService {
	self.foundService = NO;
	self.browser = [[NSNetServiceBrowser alloc] init];
	browser.delegate = self;
	[browser searchForServicesOfType:@"_http._tcp." inDomain:@""];
	[browser release];

	[self performSelector:@selector(serviceSearchTimeout) withObject:nil afterDelay:20.0];
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"browsing and searching");
}

- (void) serviceSearchTimeout{
	if( !self.foundService){
		[self.browser stop];
		[self.delegate wifiClientDidFailToResolveQuizService:self];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
	NSLog(@"did Find service: %@" , netService.name);
	if ( [netService.name isEqual:@"teacher_quiz"]){
		NSLog(@"found quiz service!");
		[netService retain];
		netService.delegate = self;
		[netService resolveWithTimeout:20];
		self.foundService = YES;
	}
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo{
	NSLog(@"did not start service search!");
	[self.delegate wifiClientDidFailToResolveQuizService:self];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender{
	
	self.baseURL = [NSString stringWithFormat:@"http://%@:%d/" , [sender hostName] , [sender port]];
	NSLog(@"got service base url: %@" , baseURL);
	[self.delegate wifiClientDidResolveQuizService:self];
	
	[sender release];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
	NSLog(@"did not resolve addresses : %@" , errorDict);
	[self.delegate wifiClientDidFailToResolveQuizService:self];
	
	[sender release];
}

- (void) authenticateWithFirstName:(NSString*)firstName lastName:(NSString*)lastName password:(NSString*)password{
	NSString* passhash = [Util md5:password];
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							firstName, @"firstname",
							lastName , @"lastname",
							passhash , @"passhash",
							[[UIDevice currentDevice] uniqueIdentifier], @"udid",
							nil];
	[self sendMessageWithMethod:@"authenticate" params:params];
}

- (void) getQuestions{
	[self sendMessageWithMethod:@"getQuestions" params:nil];
}

- (void) submitResponses:(NSArray*)responses{
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							responses,@"responses",
							[[UIDevice currentDevice] uniqueIdentifier],@"udid",
							nil];
	NSLog(@"sending responses: %@" , responses);
	[self sendMessageWithMethod:@"submitResponses" params:params];
}

- (void) sendMessageWithMethod:(NSString*)method params:(NSDictionary*)params{
	//allow nil to be passed in for params, this translates to an empty dictionary
	if ( params == nil) params = [NSDictionary dictionary];
	
	NSDictionary* postVals = [NSDictionary dictionaryWithObjectsAndKeys: 
							 method, @"method",
							 [SBJSON stringWithObject:params],@"params",
							 nil];
	
	PostRequest* pr = [[PostRequest alloc] initWithURLString:[baseURL stringByAppendingString:@"quizService"] data:postVals];
	
	[pr send:self onSuccess:@selector(sendMessageSuccess:data:) onFail:@selector(sendMessageFail:)];
	[pr release];
}

- (void) sendMessageSuccess:(PostRequest*)sender data:(NSData*)data{
	NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSString* method = [sender.postValues objectForKey:@"method"];
	NSLog(@"received message response: %@" , dataString);
	
	NSDictionary* message = [SBJSON objectWithString:dataString];
	if ( [method isEqual:@"authenticate"] ){
		BOOL authenticated = [[message objectForKey:@"authenticated"] boolValue];
		if ( authenticated){
			NSLog(@"autenticated");
			[self.delegate wifiClientDidAuthenticate:self]; 
		}else{
			NSLog(@"failed authentication");
			[self.delegate wifiClientDidFailAuthentication:self message:@"Incorrect username or password."]; 
		}
		
	}else if ( [method isEqual:@"getQuestions"]){
		NSLog(@"received questions");
		
		[self.delegate wifiClient:self didReceiveQuestions:[message objectForKey:@"questions"]]; 
		
		
	}else if ( [method isEqual:@"submitResponses"]){
		NSLog(@"successfully sent responses");
		BOOL success = [[message objectForKey:@"success"] boolValue];
		if( success ){
			[self.delegate wifiClientDidSuccessfullySendResponses:self]; 
		}else{
			[self.delegate wifiClientSendResponsesDidFail:self];
		}
	}
}

- (void) sendMessageFail:(PostRequest*)sender{
	NSString* method = [sender.postValues objectForKey:@"method"];
	NSLog(@"send message fail: %@", [sender.postValues objectForKey:@"method"]);
	if ( [method isEqual:@"authenticate"] ){
		[self.delegate wifiClientDidFailAuthentication:self message:@"Authentication failed. Please check you connection and try again."]; 
	}else if ( [method isEqual:@"submitResponses"]){
		[self.delegate wifiClientSendResponsesDidFail:self];
	}
}

- (void) dealloc{
	[delegate release];
	[baseURL release];
	[browser release];
	[super dealloc];

}
@end
