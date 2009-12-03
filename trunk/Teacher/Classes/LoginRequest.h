//
//  LoginRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequest : NSObject <NSCoding>{
	NSString* firstName;
	NSString* lastName;
	NSString* passwordHash;
	NSString* udid;
}

@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* udid;
@property (nonatomic, retain) NSString* passwordHash;

@end
