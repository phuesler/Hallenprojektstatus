//
//  HallenprojektStatusAppDelegate.m
//  HallenprojektStatus
//
//  Created by kafka on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HallenprojektStatusAppDelegate.h"

@implementation HallenprojektStatusAppDelegate

@synthesize window;
@synthesize sbMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	sbItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[sbItem retain];
	NSBundle *bundle = [NSBundle mainBundle];
	statusImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"pomodoro" ofType: @"png"]];
	statusAltImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"pomodoroBreak" ofType: @"png"]];
	[sbItem setToolTip: @"A tooltip"];
	[sbItem setHighlightMode:YES];
	[sbItem setEnabled:YES];
	[sbItem setImage: statusImage];
	[sbItem setAlternateImage: statusAltImage];
	[sbItem setMenu:sbMenu];	
}

@end
