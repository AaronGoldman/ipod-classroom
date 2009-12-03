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
}

@property (nonatomic, assign) BOOL authenticated;

@end
