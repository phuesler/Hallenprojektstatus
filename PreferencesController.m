//
//  PreferencesController.m
//  HallenprojektStatus
//
//  Created by kafka on 21.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"
#import "SDKeychain.h"


@implementation PreferencesController
@synthesize panel, passwordTextField, usernameTextField, dataFile, username;

- (void) setupSupportFile {
	NSLog(@"setup support file");
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *appSupport =	[NSSearchPathForDirectoriesInDomains( NSApplicationSupportDirectory,
																 NSUserDomainMask, YES) objectAtIndex:0];
	NSString *dir = [NSString stringWithFormat:@"%@/HallenprojektStatus", appSupport];
	[fileManager createDirectoryAtPath:dir 
		   withIntermediateDirectories:YES
							attributes:nil
								 error: nil];
	
	self.dataFile = [dir stringByAppendingPathComponent:@"preferences.plist"];
}

- (id) init {
	if ((self = [super init])) {
		[self setupSupportFile];
		self.username =  [NSString stringWithContentsOfFile:self.dataFile encoding:NSUTF8StringEncoding error:nil];
	}
	return self;
}

- (void) storeUsername{
	
	
}

- (NSString *) getUsername{
	return self.username;
}

- (NSString *) getPassword{
	return [SDKeychain securePasswordForIdentifier: self.username];
}

-(IBAction) saveCredentials: (id) sender {
	self.username = [usernameTextField stringValue];
	[self.username writeToFile:self.dataFile atomically: YES encoding: NSUTF8StringEncoding error: nil];
	[SDKeychain setSecurePassword:[passwordTextField stringValue] 
				  forIdentifier: self.username];
	[panel close];
	 
}
-(IBAction) loadPreferences: (id) sender {
	[panel makeKeyAndOrderFront:self];
	[panel makeFirstResponder:panel];
}
@end
