//
//  TestResponsesRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestResponsesRequest : NSObject <NSCoding>{
	NSMutableArray* responses;
}

@property (nonatomic , retain) NSMutableArray* responses;

@end
