//
//  LoginRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequest : NSObject <NSCoding>{
	NSString* userName;
	NSString* passwordHash;
}

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* passwordHash;

@end
