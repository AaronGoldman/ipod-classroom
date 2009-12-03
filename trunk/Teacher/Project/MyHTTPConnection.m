//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import "MyHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "AsyncSocket.h"
#import "Util.h"
#import "DatabaseConnection.h"
#import "JSON.h"

@implementation MyHTTPConnection
@synthesize postDataParams;

/**
 * Returns whether or not the requested resource is browseable.
**/
- (BOOL)isBrowseable:(NSString *)path
{
	// Override me to provide custom configuration...
	// You can configure it for the entire server, or based on the current request
	
	return YES;
}


/**
 * This method creates a html browseable page.
 * Customize to fit your needs
**/
- (NSString *)createBrowseableIndex:(NSString *)path
{
    
	NSLog(@"browser path: %@" , path);
	NSArray *array = [[NSFileManager defaultManager] directoryContentsAtPath:path];
    
    NSMutableString *outdata = [NSMutableString new];
	[outdata appendString:@"<html><head>"];
	[outdata appendFormat:@"<title>Files from %@</title>", server.name];
    [outdata appendString:@"<style>html {background-color:#eeeeee} body { background-color:#FFFFFF; font-family:Tahoma,Arial,Helvetica,sans-serif; font-size:18x; margin-left:15%; margin-right:15%; border:3px groove #006600; padding:15px; } </style>"];
    [outdata appendString:@"</head><body>"];
	[outdata appendFormat:@"<h1>Files from %@</h1>", server.name];
    [outdata appendString:@"<bq>The following files are hosted live from the iPhone.</bq>"];
	[outdata appendString:@"<br> Hi we found the web site :)"];
    [outdata appendString:@"<p>"];
	[outdata appendFormat:@"<a href=\"..\">..</a><br />\n"];
    for (NSString *fname in array)
    {
        NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:[path stringByAppendingPathComponent:fname] traverseLink:NO];
		//NSLog(@"fileDict: %@", fileDict);
        NSString *modDate = [[fileDict objectForKey:NSFileModificationDate] description];
		if ([[fileDict objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"]) fname = [fname stringByAppendingString:@"/"];
		[outdata appendFormat:@"<a href=\"%@\">%@</a>		(%8.1f Kb, %@)<br />\n", fname, fname, [[fileDict objectForKey:NSFileSize] floatValue] / 1024, modDate];
    }
    [outdata appendString:@"</p>"];
	
	if ([self supportsPOST:path withSize:0])
	{
		[outdata appendString:@"<form action=\"\" method=\"post\" enctype=\"multipart/form-data\" name=\"form1\" id=\"form1\">"];
		[outdata appendString:@"<label>upload file"];
		[outdata appendString:@"<input type=\"file\" name=\"file\" id=\"file\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"<label>"];
		[outdata appendString:@"<input type=\"submit\" name=\"button\" id=\"button\" value=\"Submit\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"</form>"];
	}
	
	[outdata appendString:@"</body></html>"];
    
	//NSLog(@"outData: %@", outdata);
    return [outdata autorelease];
	//return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]];
}


- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)relativePath
{
	if ([@"POST" isEqualToString:method])
	{
		return YES;
	}
	
	return [super supportsMethod:method atPath:relativePath];
}


/**
 * Returns whether or not the server will accept POSTs.
 * That is, whether the server will accept uploaded data for the given URI.
**/
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
//	NSLog(@"POST:%@", path);
	
	dataStartIndex = 0;
	multipartData = [[NSMutableArray alloc] init];
	postHeaderOK = FALSE;
	
	return YES;
}


/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
**/
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	NSLog(@"httpResponseForURI: method:%@ path:%@", method, path);
	
	NSData *requestData = [(NSData *)CFHTTPMessageCopySerializedMessage(request) autorelease];
	
	NSString *requestStr = [[[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"\n=== Request ====================\n%@\n================================", requestStr);

	
	if (requestContentLength > 0 && [multipartData count] >= 2)  // Process POST data
	{
		NSLog(@"processing post data: %i", requestContentLength);
		
		if ([multipartData count] < 2) return nil;
		
		NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes]
													  length:[[multipartData objectAtIndex:1] length]
													encoding:NSUTF8StringEncoding];
		
		NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
		postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
		postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
		NSString* filename = [postInfoComponents lastObject];
		
		if (![filename isEqualToString:@""]) //this makes sure we did not submitted upload form without selecting file
		{
			UInt16 separatorBytes = 0x0A0D;
			NSMutableData* separatorData = [NSMutableData dataWithBytes:&separatorBytes length:2];
			[separatorData appendData:[multipartData objectAtIndex:0]];
			int l = [separatorData length];
			int count = 2;	//number of times the separator shows up at the end of file data
			
			NSFileHandle* dataToTrim = [multipartData lastObject];
			NSLog(@"data: %@", dataToTrim);
			
			for (unsigned long long i = [dataToTrim offsetInFile] - l; i > 0; i--)
			{
				[dataToTrim seekToFileOffset:i];
				if ([[dataToTrim readDataOfLength:l] isEqualToData:separatorData])
				{
					[dataToTrim truncateFileAtOffset:i];
					i -= l;
					if (--count == 0) break;
				}
			}
			
			NSLog(@"NewFileUploaded");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NewFileUploaded" object:nil];
		}
		
		for (int n = 1; n < [multipartData count] - 1; n++)
			NSLog(@"%@", [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:n] bytes] length:[[multipartData objectAtIndex:n] length] encoding:NSUTF8StringEncoding]);
		
		[postInfo release];
		[multipartData release];
		requestContentLength = 0;
		
	}else if ( [postDataParams count] > 0){
		NSString* responseString = [self processPostData:postDataParams forFile:[path lastPathComponent]];
		NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
		return [[[HTTPDataResponse alloc] initWithData:responseData] autorelease];
	}
	
	NSString *filePath = [self filePathForURI:path];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return [[[HTTPFileResponse alloc] initWithFilePath:filePath] autorelease];
	}
	else
	{
		NSString *folder = [path isEqualToString:@"/"] ? [[server documentRoot] path] : [NSString stringWithFormat: @"%@%@", [[server documentRoot] path], path];

		if ([self isBrowseable:folder])
		{
			//NSLog(@"folder: %@", folder);
			NSData *browseData = [[self createBrowseableIndex:folder] dataUsingEncoding:NSUTF8StringEncoding];
			return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
		}
	}

	return nil;
}


/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
**/
- (void)processDataChunk:(NSData *)postDataChunk
{
	// Override me to do something useful with a POST.
	// If the post is small, such as a simple form, you may want to simply append the data to the request.
	// If the post is big, such as a file upload, you may want to store the file to disk.
	// 
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	//NSLog(@"processPostDataChunk");
//	NSString* postDataString = [[NSString alloc] initWithData:postDataChunk encoding:NSUTF8StringEncoding];
//	NSLog(@"postDatastring: %@" , postDataString);
	
	NSString* postDataChunkString = [[[NSString alloc] initWithData:postDataChunk encoding:NSUTF8StringEncoding] autorelease];

	NSLog(@"post data string: %@" , postDataChunkString);
	
	NSArray* params = [postDataChunkString componentsSeparatedByString:@"&"];
	
//	NSString* formtype = @" ";
	
	self.postDataParams = [NSMutableDictionary dictionaryWithCapacity:25];
	for(int i = 0; i < [params count]; i ++){
		NSArray* parts = [[params objectAtIndex:i] componentsSeparatedByString:@"="];
		if ( [parts count] == 2){
			//(NSString*) urlunEncode:(NSString*)str;
			//NSString* field = [urlunEncode:[parts objectAtIndex:0]];
			//NSString* value = [urlunEncode:[parts objectAtIndex:1]];
			
			NSString* field = [[Util urlunEncode:[parts objectAtIndex:0]] lowercaseString];
			//lowercase=[original lowercaseString];

			NSLog(@"Field is: %@" , field);
			NSString* value = [Util urlunEncode:[parts objectAtIndex:1]];
			NSLog(@"Value is: %@" , value);
			
			if( [field hasSuffix:@"[]"]){
				
				if ( [postDataParams objectForKey:field] == nil ){
					[postDataParams setObject:[NSMutableArray arrayWithCapacity:10] forKey:field];
				}
				[[postDataParams objectForKey:field] addObject:value];
			}else{
				[postDataParams setObject:value forKey:field];
			}

		}

		
	
		//int thirdRowVal = [[[vals objectAtIndex:1] objectForKey:@"class_id"] intValue];
	}
	
	
	
	//[DatabaseConnection executeSelect:@"INSERT INTO class (name, class_id) VALUES ('Tim', NULL);"];
	//	[DatabaseConnection executeSelect:@"INSERT INTO manswer (qid) VALUES (5);"];
	//	[DatabaseConnection executeSelect:@"DELETE FROM class WHERE class_id>3;"];
	//NSArray* vals = [DatabaseConnection executeSelect:@"SELECT * FROM manswer WHERE qid>0"];
	
	
	
	//NSLog(@"val: %@" , [vals objectAtIndex:1]);
	//int thirdRowVal = [[[vals objectAtIndex:1] objectForKey:@"class_id"] intValue];
	
	//id object;
	//NSLog(@"object name: %@",vals);
	//NSLog(@"Row: %d",thirdRowVal);
	
	
	
	/*+ (NSDictionary*) queryParameters:(NSURL*)url{
		NSArray* params = [[url query] componentsSeparatedByString:@"&"];
		NSMutableDictionary* queryDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
		
		for(int i = 0; i < [params count]; i ++){
			NSArray* parts = [[params objectAtIndex:i] componentsSeparatedByString:@"="];
			[queryDict setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
		}
		
		for( NSString* key in queryDict){
			NSLog(@"%@: %@" , key , [queryDict objectForKey:key]);
		}
		
		return queryDict;*/
	
	
	
	if (!postHeaderOK)
	{
		UInt16 separatorBytes = 0x0A0D;
		NSData* separatorData = [NSData dataWithBytes:&separatorBytes length:2];
		
		int l = [separatorData length];

		for (int i = 0; i < [postDataChunk length] - l; i++)
		{
			NSRange searchRange = {i, l};

			if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
			{
				NSRange newDataRange = {dataStartIndex, i - dataStartIndex};
				dataStartIndex = i + l;
				i += l - 1;
				NSData *newData = [postDataChunk subdataWithRange:newDataRange];

				if ([newData length])
				{
					[multipartData addObject:newData];
				}
				else
				{
					postHeaderOK = TRUE;
					
					NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
					NSLog(@"postInfo: %@" , postInfo);
					NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
					NSLog(@"postInfoComponents1: %@" , postInfoComponents);
					postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
					NSLog(@"postInfoComponents2: %@" , postInfoComponents);
					postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
					NSLog(@"postInfoComponents3: %@" , postInfoComponents);
					NSString* filename = [[[server documentRoot] path] stringByAppendingPathComponent:[postInfoComponents lastObject]];
					NSRange fileDataRange = {dataStartIndex, [postDataChunk length] - dataStartIndex};
					
					[[NSFileManager defaultManager] createFileAtPath:filename contents:[postDataChunk subdataWithRange:fileDataRange] attributes:nil];
					NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filename] retain];

					if (file)
					{
						[file seekToEndOfFile];
						[multipartData addObject:file];
					}
					
					[postInfo release];
					
					break;
				}
			}
		}
	}
	else
	{
		[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
	}
}

- (NSString*) processPostData:(NSDictionary*)data forFile:(NSString*)fileName{
	NSString* response = nil;
	if( [fileName isEqual:@"classSubmit.html"]){
		response = [self handleClassSubmit:data];
	}else if( [fileName isEqual:@"testSubmit.html"]){
		response = [self handleTestSubtmit:data];
	}
	
	return response;
}



- (NSString*) handleTestSubtmit:(NSDictionary*)data{
	NSLog(@"handling test submit with data: %@" , data);
	return @"test submitted";
}

- (NSString*) handleClassSubmit:(NSDictionary*)data{
	NSLog(@"handling class submit with data: %@" , data);
//	if([formtype isEqualToString:@"test"]){
//		//multqtext
//		if([field isEqualToString:@"multqtext"]){
//			//Add multipal choise qwestion text to qwestion table
//			NSString* sqlstatement = [NSString stringWithFormat: @"INSERT INTO question (qid, text, time, type, tid) VALUES (NULL, '%@', 1234567, 3, );", value];
//			[DatabaseConnection executeSelect: sqlstatement];
//		}
//		//option
//		if([field isEqualToString:@"option"]){
//			//add a option for the last created multipal choise qwestion
//		}
//		//tfqtext
//		if([field isEqualToString:@"tfqtext"]){
//			//Add true false qwestion text to qwestion table
//			NSString* sqlstatement = [NSString stringWithFormat: @"INSERT INTO question (qid, text, time, type, tid) VALUES (NULL, '%@', 1234567, 4, );", value];
//			[DatabaseConnection executeSelect: sqlstatement];
//		}
//		//numqtext
//		if([field isEqualToString:@"numqtext"]){
//			//Add numeric responce qwestion text to qwestion table
//			NSString* sqlstatement = [NSString stringWithFormat: @"INSERT INTO question (qid, text, time, type, tid) VALUES (NULL, '%@', 1234567, 2, );", value];
//			[DatabaseConnection executeSelect: sqlstatement];
//			
//		}
//		//textqtext
//		if([field isEqualToString:@"textqtext"]){
//			//Add text responce qwestion text to qwestion table
//			NSString* sqlstatement = [NSString stringWithFormat: @"INSERT INTO question (qid, text, time, type, tid) VALUES (NULL, '%@', 1234567, 1, );", value];
//			[DatabaseConnection executeSelect: sqlstatement];
//		}
//	}
//	if([formtype isEqualToString:@"class"]){
//		//sudentname
//		if([field isEqualToString:@"sudentname"]){
//			//add student to most resently created class 
//		}
//		//devise
//		if([field isEqualToString:@"devise"]){
//			//add device id to most recently created student
//		}
//		//password
//		if([field isEqualToString:@"password"]){
//			//add password to most recently created student
//		}
//	}
//	//form type identivifation
//	if([formtype isEqualToString:@" "]){
//		if([field isEqualToString:@"testname"]){
//			formtype = @"test";
//			//create test with name value
//			
//			//message = [NSString stringWithFormat: @"Your age is %d", age];
//			
//			
//			NSString* sqlstatement = [NSString stringWithFormat: @"INSERT INTO test (name, time, tid) VALUES ('%@', 1234567, NULL);", value];
//			//NSString* sqlstatement =  @"INSERT INTO test (name, time, tid) VALUES ('BoB', 1234567, NULL);";
//			
//			
//			[DatabaseConnection executeSelect: sqlstatement];
//			
//			NSArray* testvals = [DatabaseConnection executeSelect:@"SELECT * FROM test WHERE tid>0"];
//			
//			//NSArray* tid = [DatabaseConnection executeSelect:@"SELECT tid FROM test WHERE tid = last_insert_rowid()"];
//			
//			int tid = sqlite3_last_insert_rowid([DatabaseConnection getConnection]);
//			
//			NSLog(@"tid: %d", tid);
//			NSLog(@"testvals: %@", testvals);
//			
//			//[outdata appendFormat:@"<h1>Files from %@</h1>", server.name];
//			
//			//select class_id from class where class_id = last_insert_rowid();	
//			
//		}
//		if([field isEqualToString:@"classname"]){
//			formtype = @"class";
//			//cerate class with name value
//		}
//		
//		//form from client
//		/*if([field isEqualToString:@"client"]){
//		 formtype = @"client";
//		 //code for client comunication
//		 }*/
//	}
	
	return @"Helllow reaponst world!";
}

- (void) dealloc{
	[postDataParams release];
	[super dealloc];
}


@end