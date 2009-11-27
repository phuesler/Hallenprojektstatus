//
//  HallenprojektStatusAppDelegate.h
//  HallenprojektStatus
//
//  Created by kafka on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h";

@interface HallenprojektStatusAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSStatusItem *sbItem;
	NSMenu *sbMenu;
	NSImage *statusImage;
	NSImage *statusAltImage;
	NSMenuItem *placesMenuItem;
	PreferencesController *preferencesController;
	NSMenuItem *selectedItem;
	NSMenuItem *logoutItem;
	NSTimer *timer;
}

-(IBAction) logout: (id) sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *sbMenu;
@property (assign) IBOutlet NSMenuItem *placesMenuItem;
@property (assign) IBOutlet NSMenuItem *logoutItem;
@property (assign) IBOutlet PreferencesController *preferencesController;
@property (assign) NSMenuItem *currentlySelectedItem;

@end
