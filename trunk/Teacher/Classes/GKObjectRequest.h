//
//  GKObjectRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GKObjectRequest : NSObject <NSCoding>{
	NSString* toPeer;
}

@property (nonatomic , retain) NSString* toPeer;

@end
