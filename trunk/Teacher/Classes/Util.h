//
//  Util.h
//  Addressbook
//
//  Created by Adrian Smith on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Util : NSObject {

}

+ (NSString*) md5:(NSString*)message;
+ (NSDictionary*) queryParameters:(NSURL*)url;
+ (NSString*) sanitizePhoneNumber:(NSString*)recipientPhone;
+ (NSString*) appDir;
+ (UIView*) viewFromNibNamed:(NSString*)nibname;
+ (UIImage*) resizeImage:(UIImage*)image newSize:(CGRect)newSize;
+ (UIColor*) appleBlueColor;
+ (NSString*) urlEncode:(NSString*)str;
+ (NSString*) urlDecode:(NSString*)str;
+ (void) showAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (BOOL) isPhone;
+ (NSString*) appVersion;
+ (BOOL)redirectNSLog;

@end
