//
//  HopRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKObjectRequest.h"

@interface HopRequest : GKObjectRequest {
	int hops;
}

@property (nonatomic , assign) int hops;

@end
