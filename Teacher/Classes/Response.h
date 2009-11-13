//
//  Response.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Response : NSObject <NSCoding>{
	NSString* udid;
	NSData* data;
	NSDate* date;
	int qid;
}

@property (nonatomic , retain) NSString* udid;
@property (nonatomic , retain) NSData* data;
@property (nonatomic , retain) NSDate* date;
@property (nonatomic , assign) int qid;

@end
