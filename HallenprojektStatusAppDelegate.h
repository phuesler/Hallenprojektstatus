//
//  HallenprojektStatusAppDelegate.h
//  HallenprojektStatus
//
//  Created by kafka on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h";

//#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
//@interface HallenprojektStatusAppDelegate : NSObject {
//#else
@interface HallenprojektStatusAppDelegate : NSObject <NSApplicationDelegate> {
//#endif
    NSWindow *window;
	NSStatusItem *sbItem;
	NSMenu *sbMenu;
	NSImage *statusImage;
	NSMenuItem *placesMenuItem;
	NSMenuItem *currentlySelectedItem;
	PreferencesController *preferencesController;
	NSMenuItem *selectedItem;
	NSMenuItem *logoutItem;
	NSTimer *timer;
	BOOL loggedIn;
}

-(IBAction) logout: (id) sender;
-(IBAction) gotoWebsite: (id) sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *sbMenu;
@property (assign) IBOutlet NSMenuItem *placesMenuItem;
@property (assign) IBOutlet NSMenuItem *logoutItem;
@property (assign) IBOutlet PreferencesController *preferencesController;
@property (assign) NSMenuItem *currentlySelectedItem;

@end
