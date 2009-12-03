//
//  QuestionsRequest.h
//  Teacher
//
//  Created by Adrian Smith on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionsRequest : NSObject {
	NSArray* questions;
}

@property (nonatomic, retain) NSArray* questions;

@end
