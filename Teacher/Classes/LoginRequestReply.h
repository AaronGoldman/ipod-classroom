//
//  LoginRequestReply.h
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequestReply : NSObject <NSCoding> {
	BOOL authenticated;
	NSArray* questions;
}

@property (nonatomic, assign) BOOL authenticated;
@property (nonatomic, retain) NSArray* questions;

@end
