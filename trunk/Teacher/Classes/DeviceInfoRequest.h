//
//  DeviceInfoRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceInfoRequest : NSObject <NSCoding> {
	NSString* udid;
}

@property (nonatomic , retain) NSString* udid;

@end
