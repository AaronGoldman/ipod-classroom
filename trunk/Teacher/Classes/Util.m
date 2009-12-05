//
//  Util.m
//  Addressbook
//
//  Created by Adrian Smith on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation Util


+ (NSString*) md5:(NSString*)message{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( [message UTF8String], [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding], result );
	
	return [NSString 
			stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]
			];
}

+ (NSDictionary*) queryParameters:(NSURL*)url{
	NSArray* params = [[url query] componentsSeparatedByString:@"&"];
	NSMutableDictionary* queryDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
	
	for(int i = 0; i < [params count]; i ++){
		NSArray* parts = [[params objectAtIndex:i] componentsSeparatedByString:@"="];
		[queryDict setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
	}
	
	for( NSString* key in queryDict){
		NSLog(@"%@: %@" , key , [queryDict objectForKey:key]);
	}
	
	return queryDict;
}

+ (NSString*) sanitizePhoneNumber:(NSString*)recipientPhone{
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"#" withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"." withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
	recipientPhone = [recipientPhone stringByReplacingOccurrencesOfString:@"" withString:@""];
	return recipientPhone;
}

+ (NSString*)appDir{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
	
	return documentsDirectory;
}

+ (UIView*) viewFromNibNamed:(NSString*)nibname{
	UIView* view = nil;
	
	NSArray* tops = [[NSBundle mainBundle] loadNibNamed:nibname owner:nibname options:nil];
	
	for( int i = 0;i < [tops count];i ++){
		if ( [[tops objectAtIndex:i] isKindOfClass:[UIView class]]){
			view = [tops objectAtIndex:i];
			break;
		}
	}	
	
	if( view == nil){
		NSException* ex = [NSException exceptionWithName:@"Util: Bad nib Exception" 
												  reason:[NSString stringWithFormat:@"Could not load a UIView from nib %@", nibname]
												userInfo:nil];
		[ex raise];
	}
	
	return view;
}

+ (UIImage*) resizeImage:(UIImage*)image newSize:(CGRect)newSize{
	CGRect resizeFrame = newSize;
	UIGraphicsBeginImageContext( resizeFrame.size );
	[image drawInRect:resizeFrame];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}


+ (UIColor*) appleBlueColor{
	return [UIColor colorWithRed:68.0/255 green:94.0f/255 blue:144.0f/255 alpha:1.0f];
}


+ (NSString*) urlEncode:(NSString*)str{
	str = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
	str = [str stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
	str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	str = [str stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
	str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
	str = [str stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
	str = [str stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
	str = [str stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	str = [str stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
	str = [str stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
	str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
	str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
	str = [str stringByReplacingOccurrencesOfString:@"^" withString:@"%5E"];
	str = [str stringByReplacingOccurrencesOfString:@"`" withString:@"%60"];
	str = [str stringByReplacingOccurrencesOfString:@"{" withString:@"%7B"];
	str = [str stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"];
	str = [str stringByReplacingOccurrencesOfString:@"}" withString:@"%7D"];
	str = [str stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
	str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"%5C"];
	str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
	str = [str stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
	
	return str;
}

+ (NSString*) urlDecode:(NSString*)str{
	str = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
	str = [str stringByReplacingOccurrencesOfString:@"%24" withString:@"$"];
	str = [str stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
	str = [str stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
	str = [str stringByReplacingOccurrencesOfString:@"%2C" withString:@","];
	str = [str stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
	str = [str stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
	str = [str stringByReplacingOccurrencesOfString:@"%3B" withString:@";"];
	str = [str stringByReplacingOccurrencesOfString:@"%3C" withString:@"<"];
	str = [str stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
	str = [str stringByReplacingOccurrencesOfString:@"%3E" withString:@">"];
	str = [str stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
	str = [str stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
	str = [str stringByReplacingOccurrencesOfString:@"%5B" withString:@"["];
	str = [str stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];
	str = [str stringByReplacingOccurrencesOfString:@"%5E" withString:@"^"];
	str = [str stringByReplacingOccurrencesOfString:@"%60" withString:@"`"];
	str = [str stringByReplacingOccurrencesOfString:@"%7B" withString:@"{"];
	str = [str stringByReplacingOccurrencesOfString:@"%7C" withString:@"|"];
	str = [str stringByReplacingOccurrencesOfString:@"%7D" withString:@"}"];
	str = [str stringByReplacingOccurrencesOfString:@"%7E" withString:@"~"];
	str = [str stringByReplacingOccurrencesOfString:@"%5C" withString:@"\\"];
	str = [str stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
	str = [str stringByReplacingOccurrencesOfString:@"%21" withString:@"!"];
	
	return str;
}


+ (void) showAlertWithTitle:(NSString*)title message:(NSString*)message{
	UIAlertView* av = [[UIAlertView alloc] initWithTitle:title
												 message:message
												delegate:nil
									   cancelButtonTitle:nil
									   otherButtonTitles:@"OK",nil];
	[av show];
	[av release];
}

+ (NSString*) appVersion{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (BOOL) isPhone{
	int mib[2];
	size_t len = 255;
	char p[255];
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, p, &len, NULL, 0);
	p[6] = 0;
	
	return !strncmp("iPhone", p, 6);

}

+ (BOOL)redirectNSLog{
	// Create log file
	NSString* path = [[Util appDir] stringByAppendingPathComponent:@"NSLog.txt"];
	[@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	id fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	if (!fileHandle)	return NSLog(@"Opening log failed"), NO;
	[fileHandle retain];
	
	// Redirect stderr
	int err = dup2([fileHandle fileDescriptor], STDERR_FILENO);
	if (!err)	return	NSLog(@"Couldn't redirect stderr"), NO;
	
	return	YES;
}

@end
