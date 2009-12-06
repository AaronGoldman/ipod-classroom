//
//  QuizServiceHttpServer.h
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"

@protocol QuizServiceHttpServerDelegate

- (void) studentAuthenticated:(NSString*)studentName;
- (void) studentFailedAuthentication:(NSString*)studentName;
- (void) studentCompleted:(NSString*)studentCompleted;


@end


@interface QuizServiceHttpServer : HTTPServer {
	int tid;
	NSMutableDictionary* authenticated;
	NSMutableDictionary* completed;
	BOOL acceptNew;
	id <NSObject,QuizServiceHttpServerDelegate> quizDelegate;
}
- (id) initWithTid:(int)_tid;


@property (nonatomic , assign) BOOL acceptNew;
@property (nonatomic , assign) int tid;
@property (nonatomic , retain) NSMutableDictionary* authenticated;
@property (nonatomic , retain) NSMutableDictionary* completed;
@property (nonatomic , retain) id <NSObject,QuizServiceHttpServerDelegate> quizDelegate;


@end
