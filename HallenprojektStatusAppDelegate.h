//
//  HallenprojektStatusAppDelegate.h
//  HallenprojektStatus
//
//  Created by kafka on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HallenprojektStatusAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSStatusItem *sbItem;
	NSMenu *sbMenu;
	NSImage *statusImage;
	NSImage *statusAltImage;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *sbMenu;

-(IBAction) setLocation: (id) sender;
-(IBAction) listPlaces: (id) sender;

@end
