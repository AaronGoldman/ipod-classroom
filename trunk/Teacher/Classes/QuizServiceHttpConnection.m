//
//  QuizServiceHttpConnection.m
//  Teacher
//
//  Created by Adrian Smith on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuizServiceHttpConnection.h"
#import "JSON.h"
#import "DatabaseConnection.h"
#import "QuizServiceHttpServer.h"

@implementation QuizServiceHttpConnection


- (NSString*) processPostData:(NSDictionary*)data forFile:(NSString*)fileName{
	NSString* response = nil;
	if ( [fileName isEqual:@"quizService"]){
		NSString* method = [data objectForKey:@"method"];
		NSDictionary* params = [SBJSON objectWithString:[data objectForKey:@"params"]];
		if ( [method isEqual:@"getQuestions"]){
			response = [self handleGetQuestions];
		}else if ( [method isEqual:@"authenticate"]){
			response = [self handleAuthenticate:params];
		}else if ( [method isEqual:@"submitResponses"]){
			response = [self handleSubmitResponses:params];
		}
	}
	
	return response;
}

- (NSString*) handleGetQuestions{
	
	NSString* query =	[NSString stringWithFormat:@"Select * from question where tid=%d" ,self.quizServiceHttpServer.tid];
	NSArray* questions = [DatabaseConnection executeSelect:query];
	for (NSMutableDictionary* question in questions) {
		if ( [[question objectForKey:@"type"] intValue] == 3){
			query = [NSString stringWithFormat:@"Select * from manswer where qid=%d",[[question objectForKey:@"qid"] intValue]];
			
			NSArray* possibleAnswers = [DatabaseConnection executeSelect:query];
			if( possibleAnswers != nil){
				[question setObject:possibleAnswers forKey:@"possibleAnswers"];
			}
			
		}
	}
	
	NSString* responseString =  [SBJSON stringWithObject:[NSDictionary dictionaryWithObject:questions forKey:@"questions"]];;
	
	NSLog(@"get Questions, returning:\n%@", responseString);
	return responseString;
}

- (NSString*) handleAuthenticate:(NSDictionary*)params{
	NSString* firstname = [params objectForKey:@"firstname"];
	firstname = [firstname stringByReplacingOccurrencesOfString:@"'" withString:@""];
	
	NSString* lastname = [params objectForKey:@"lastname"];
	lastname = [lastname stringByReplacingOccurrencesOfString:@"'" withString:@""];
	
	NSString* passhash = [params objectForKey:@"passhash"];
	passhash = [passhash stringByReplacingOccurrencesOfString:@"'" withString:@""];
	
	NSString* udid = [params objectForKey:@"udid"];
	udid = [udid stringByReplacingOccurrencesOfString:@"'" withString:@""];
	
	NSString* query = [NSString stringWithFormat:@"Select * from student where firstname='%@' collate nocase and lastname='%@' collate nocase and passhash='%@' and udid='%@'",
					   firstname,lastname,passhash,udid];
	NSLog(@"authentication query: %@" , query);
	
	NSArray* results = [DatabaseConnection executeSelect:query];
	BOOL authenticated = [results count] > 0;
	if ( authenticated ){
		[self.quizServiceHttpServer.authenticated setObject:[results objectAtIndex:0] forKey:udid];
	}else if ( self.quizServiceHttpServer.acceptNew && [firstname length] > 0 && [lastname length] > 0 && [passhash length] > 0 && [udid length] > 0){
		authenticated = YES;
		query = [NSString stringWithFormat:@"insert into student (firstname,lastname,udid,passhash) values ('%@','%@','%@','%@');",firstname,lastname,udid,passhash];
		[DatabaseConnection executeSelect:query];
		NSNumber* student_id = [NSNumber numberWithInt:sqlite3_last_insert_rowid([DatabaseConnection getConnection])];
		NSDictionary* studentInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									 student_id,@"student_id",
									 firstname,@"firstname",
									 lastname,@"lastname",
									 udid,@"udid",
									 passhash,@"passhash",
									 nil];
		[self.quizServiceHttpServer.authenticated setObject:studentInfo forKey:udid];
	}
	
	
	NSLog(@"handle authenticate");
	NSDictionary* response = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:authenticated] forKey:@"authenticated"];
	return  [SBJSON stringWithObject:response];
}

- (NSString*) handleSubmitResponses:(NSDictionary*)params{
	NSLog(@"got responses: %@" ,params);
	NSString* udid = [params objectForKey:@"udid"];
	NSDictionary* student = [self.quizServiceHttpServer.authenticated objectForKey:udid];
	int student_id = [[student objectForKey:@"student_id"] intValue];
	
	NSArray* responses = [params objectForKey:@"responses"];
	for( NSDictionary* response in responses){
		int time = [[response objectForKey:@"date"] intValue];
		int qid = [[response objectForKey:@"qid"] intValue];
		
		NSData* data = [NSKeyedArchiver archivedDataWithRootObject:[response objectForKey:@"responseValue"]];
		NSLog(@"responseValue raw:[%@] %@" ,[[response objectForKey:@"responseValue"] class], [response objectForKey:@"responseValue"]);
		
		NSString* query = [NSString stringWithFormat:@"insert into response (qid,data,time,student_id) values (%d,?,%d,%d)",qid,time,student_id];
		NSLog(@"submit response query: %@" , query);
		[DatabaseConnection executeSelect:query params:[NSArray arrayWithObject:data]];
						   
	}
	
	NSLog(@"handling Submit responses");
	NSDictionary* response = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"success"];
	return [SBJSON stringWithObject:response];
	
	
}

- (QuizServiceHttpServer*) quizServiceHttpServer{
	return (QuizServiceHttpServer*)server;
}

@end
