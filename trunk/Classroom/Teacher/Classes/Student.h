//
//  Student.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Student : NSObject {
	NSString* udid;
	NSString* firstName;
	NSString* lastName;
	NSString* passwordHash;
	int studentID;
}

@property (nonatomic , retain) NSString* udid;
@property (nonatomic , retain) NSString* firstName;
@property (nonatomic , retain) NSString* lastName;
@property (nonatomic , retain) NSString* passwordHash;
@property (nonatomic , assign) int studentID;

@end

