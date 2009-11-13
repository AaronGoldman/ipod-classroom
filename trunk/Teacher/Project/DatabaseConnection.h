//
//  DatabaseConnection.h
//  Addressbook
//
//  Created by Adrian Smith on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseConnection : NSObject {
}

+ (NSString*) databasePath;
+ (sqlite3*) getConnection;
+ (void) cleanup;
+ (NSString*) databaseFilename;
+ (void)createEditableCopyOfDatabase;
+ (void) commit;
+ (void) begin;
+ (NSArray*) executeSelect:(NSString*)query;
+ (BOOL) dbExists;
+ (void) initializeDatabase;
+ (NSArray*) executeSelect:(NSString*)query params:(NSArray*)params;

@end

extern int callbackHook(void*);
extern double dbLastUpdated;

#define SQL_COLUMN_NSSTRING(X,Y) sqlite3_column_text(X, Y) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(X, Y)] : nil;