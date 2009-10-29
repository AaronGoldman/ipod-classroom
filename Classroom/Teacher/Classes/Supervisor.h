//
//  Supervisor.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Response.h"

@class Supervisor;
@protocol SupervisorDelegate

- (void) supervisor:(Supervisor*)supervisor didReceiveResponse:(Response*)response;

@end


@interface Supervisor : NSObject {
	GKSession* gkSession;
	NSArray* questions;
	NSObject <GKSessionDelegate, SupervisorDelegate> *delegate;
}

- (void) start;

@property (nonatomic , retain) GKSession* gkSession;
@property (nonatomic , retain) NSArray* questions;
@property (nonatomic , retain) NSObject <GKSessionDelegate, SupervisorDelegate> *delegate;

@end
