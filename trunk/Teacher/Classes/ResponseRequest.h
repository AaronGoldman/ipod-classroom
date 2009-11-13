//
//  ResponseRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface ResponseRequest : NSObject <NSCoding> {
	Response* response;
}

@property (nonatomic ,retain) Response* response;

@end
