//
//  Test.h
//  Teacher
//
//  Created by Adrian Smith on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Test : NSObject {
	NSString* name;
	NSDate* date;
	int tid;
}

@property (nonatomic , retain) NSString* name;
@property (nonatomic , retain) NSDate* date;
@property (nonatomic , assign) int tid;

@end
