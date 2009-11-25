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

- (NSString *) getUsername{
	return @"test";
}

- (NSString *) getPassword{
	return @"testtest";	
}

-(IBAction) saveCredentials: (id) sender {
	OSStatus status = 0;
	NSString *serviceName = @"hallenprojekt.de status app";
	SecKeychainRef keychain = nil;
	SecKeychainItemRef item = nil;
	
	status = SecKeychainFindGenericPassword(	keychain,
										   [serviceName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
										   [serviceName UTF8String],
										   [[usernameTextField stringValue] lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
										   [[usernameTextField stringValue] UTF8String], NULL, NULL, &item);
	if (status == errSecItemNotFound){
		status = SecKeychainAddGenericPassword(	keychain,
											  [serviceName lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [serviceName UTF8String],
											  [[usernameTextField stringValue] lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [[usernameTextField stringValue] UTF8String],
											  [[passwordTextField stringValue] lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [[passwordTextField stringValue] UTF8String], &item);
		NSLog(@"SecKeychainAddGenericPassword: %d", status);
		
	}else {
		status = SecKeychainItemModifyContent(item, NULL, [[passwordTextField stringValue] lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
											  [[passwordTextField stringValue] UTF8String]);
		SecKeychainAttribute attr;
		SecKeychainAttributeList attrList;
		
		// The attribute we want is the account name
		attr.tag = kSecAccountItemAttr;
		attr.length = strlen(username);
		attr.data = (void*)username;
		
		attrList.count = 1;
		attrList.attr = &attr;
		
		// Want to modify so that Keychain entry metadata is preserved.
		SecKeychainItemModifyContent(itemRef, &attrList, strlen(password), (void *)password);
		CFRelease(itemRef);
		
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
