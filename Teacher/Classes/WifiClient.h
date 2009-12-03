//
//  WifiClient.h
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WifiClient;

@protocol WifiClientDelegate

- (void) wifiClientDidAuthenticate:(WifiClient*)client;
- (void) wifiClientDidFailAuthentication:(WifiClient*)client;
- (void) wifiClient:(WifiClient*)client didReceiveQuestions:(NSArray*)questions;
- (void) wifiClientDidSuccessfullySendResponses:(WifiClient*)client;
- (void) wifiClientSendResponsesDidFail:(WifiClient*)client;
- (void) wifiClientDidResolveQuizService:(WifiClient*)client;
- (void) wifiClientDidFailToResolveQuizService:(WifiClient*)client;

@end


@interface WifiClient : NSObject {
	NSString* baseURL;
	NSNetServiceBrowser* browser;
	id <NSObject,WifiClientDelegate> delegate;
}

- (void) authenticateWithFirstName:(NSString*)firstName lastName:(NSString*)lastName password:(NSString*)password;
- (void) sendMessageWithMethod:(NSString*)method params:(NSDictionary*)params;
- (void) searchForQuizService;
- (void) getQuestions;
- (void) authenticateWithFirstName:(NSString*)firstName lastName:(NSString*)lastName password:(NSString*)password;
- (void) submitResponses:(NSArray*)responses;

@property (nonatomic , retain) NSNetServiceBrowser* browser;
@property (nonatomic , retain) id <WifiClientDelegate,NSObject> delegate;
@property (nonatomic , retain) NSString* baseURL;

@end
