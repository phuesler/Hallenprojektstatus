//
//  PreferencesController.m
//  HallenprojektStatus
//
//  Created by kafka on 21.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController
@synthesize panel, passwordTextField, usernameTextField;

-(IBAction) saveCredentials: (id) sender {
	OSStatus status = 0;
	NSString *serviceName = @"hallenprojekt.de status app";
	NSString *accountName = [usernameTextField stringValue];
	NSString *password = [passwordTextField stringValue];
	SecKeychainRef keychain = nil;
	SecKeychainItemRef item = nil;
	
	status = SecKeychainFindGenericPassword(	keychain,
										   [serviceName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
										   [serviceName UTF8String],
										   [accountName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
										   [accountName UTF8String], NULL, NULL, &item);
	NSLog(@"SecKeychainFindGenericPassword: %d", status);
	
	if (status == errSecItemNotFound){
		status = SecKeychainAddGenericPassword(	keychain,
											  [serviceName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [serviceName UTF8String],
											  [accountName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [accountName UTF8String],
											  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [password UTF8String], &item);
		NSLog(@"SecKeychainAddGenericPassword: %d", status);
		
	}else {
		NSString *newpassword = [[NSString alloc] initWithString:@"newpassword"];
		status = SecKeychainItemModifyContent(item, NULL, [newpassword lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [newpassword UTF8String]);
		NSLog(@"SecKeychainItemModifyContent: %d", status); // wrPermErr = -61, /*write permissions status*/
	}
	
	NSLog(@"saved credentials");
	
}
-(IBAction) loadPreferences: (id) sender {
	NSLog(@"load preferences");
	[panel makeKeyAndOrderFront:self];
	[panel makeFirstResponder:panel];
}
@end
