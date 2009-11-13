//
//  DatabaseConnection.m
//  Addressbook
//
//  Created by Adrian Smith on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DatabaseConnection.h"
#import "Util.h"


@implementation DatabaseConnection

static sqlite3 *database;

+ (sqlite3*) getConnection{
	if (!database){

		
		if (  ![self dbExists]){
			[self createEditableCopyOfDatabase];
			
			[self initializeDatabase];
		}
		
		if( sqlite3_open([[self databasePath] UTF8String], &database )!= SQLITE_OK) {
			// Even though the open failed, call close to properly clean up resources.
			sqlite3_close(database);
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
			// Additional error handling, as appropriate...
		}else{
			sqlite3_commit_hook(database , callbackHook, 0);
		}
		

	}
	
	return database;
}

+ (void) initializeDatabase{
	
}
+ (BOOL) dbExists{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self databasePath]];
}

+ (void)createEditableCopyOfDatabase{
	// First, test for existence.
	BOOL success;
	NSError* error;
	
	NSString *writableDBPath = [self databasePath];
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self databaseFilename]];
	
	success = [[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSLog( @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}
	
	
+ (NSString*) databasePath{
	return [[Util appDir] stringByAppendingPathComponent:[self databaseFilename]];
}
	
+ (NSString*) databaseFilename{
	return @"database.sqlite";
}

+ (void) cleanup{
	sqlite3_close(database);
}

+ (void) begin{
	const char *sql = "BEGIN";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([self getConnection], sql, -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}

+ (void) commit{
	const char *sql = "COMMIT";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([self getConnection], sql, -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}




+ (sqlite3_stmt*) createStatementWithQuery:(NSString*)query params:(NSArray*)params{
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([self getConnection], [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self getConnection]));
		return nil;
	}
	
	
	for( int i = 0; i < [params count]; i ++){
		if( i >= sqlite3_bind_parameter_count(statement)){
			NSLog(@"error: too many bind parameters passed");
			break;
		}
		
		
		id param = [params objectAtIndex:i];
		if( [param isKindOfClass:[NSString class]]){
			sqlite3_bind_text(statement, i+1, [param UTF8String], -1, SQLITE_TRANSIENT);
		}else if ( [param isKindOfClass:[NSNumber class]]){
			NSLog(@"param: %s, %s", [param objCType] , @encode(int));
			if( *[param objCType] == *@encode( int)){
				sqlite3_bind_int( statement, i+1, [param intValue]);
			}else if( *[param objCType] == *@encode(float) || *[param objCType] == *@encode(double)){
				sqlite3_bind_double(statement, i+1, [param doubleValue]);
			}else{
				NSLog(@"Error: unknown number type passed in to executeSelect");
			}
		}else if( [param isKindOfClass:[NSData class]]){
			sqlite3_bind_blob(statement, i+1, [param bytes], [param length], SQLITE_TRANSIENT);
		}else{
			NSLog(@"Error: executeSelect parameter found type %@ which is not NSNumber or NSString or NSData" , [param class]);
			
			
		}
		
		
	}
	
	
	return statement;
}

+ (NSArray*) executeSelect:(NSString*) query{
	return [self executeSelect:query params:nil];
	
}


+ (NSArray*) executeSelect:(NSString*)query params:(NSArray*)params{
	sqlite3_stmt *statement = [self createStatementWithQuery:query params:params];
	if (!statement) {
		return nil;
	}

	
	NSMutableArray* toRet = [NSMutableArray arrayWithCapacity:100];
	int columnCount = sqlite3_column_count(statement);
	while (sqlite3_step(statement) == SQLITE_ROW) {
		
		NSMutableDictionary* row = [NSMutableDictionary dictionaryWithCapacity:columnCount];
		for ( int column = 0; column < columnCount; column ++){

			NSString* key = [NSString stringWithUTF8String:sqlite3_column_name(statement, column)];
			
			id value = nil;
			
			//SQLITE_INTEGER, SQLITE_FLOAT, SQLITE_TEXT, SQLITE_BLOB, or SQLITE_NULL.
			int type = sqlite3_column_type(statement, column);
			if( type == SQLITE_INTEGER){
				value = [NSNumber numberWithInt:sqlite3_column_int(statement, column)];
			}else if ( type == SQLITE_FLOAT){
				value = [NSNumber numberWithDouble:sqlite3_column_double(statement, column)];
			}else if ( type == SQLITE_TEXT){
				char* text = (char *)sqlite3_column_text(statement, column);
				value =  [NSString stringWithUTF8String:text];

			}else if( type == SQLITE_BLOB){
				const void* bytes = sqlite3_column_blob(statement, column);
				int length  = sqlite3_column_bytes(statement, column);
				value = [[[NSData alloc] initWithBytes:bytes length:length] autorelease];
			}
			
			if( value != nil){
				[row setObject:value forKey:key];
			}
			
		}
		
		[toRet addObject:row];

	}
	// Reset the statement for future reuse.
	sqlite3_finalize(statement);
	
	return toRet;
}

@end


double dbLastUpdated;
int callbackHook(void* item){
	dbLastUpdated = [[NSDate date] timeIntervalSince1970];
	
	return 0;
}
