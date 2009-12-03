//
//  QuizServiceHttpConnection.h
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHTTPConnection.h"
#import "QuizServiceHttpServer.h"

@interface QuizServiceHttpConnection : MyHTTPConnection {
}

- (NSString*) handleGetQuestions;
- (NSString*) handleSubmitResponses:(NSDictionary*)params;
- (NSString*) handleAuthenticate:(NSDictionary*)params;

@property (nonatomic, readonly) QuizServiceHttpServer* quizServiceHttpServer;

@end
