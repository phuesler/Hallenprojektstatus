//
//  HallenprojektStatusAppDelegate.m
//  HallenprojektStatus
//
//  Created by kafka on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSON.h"
#import "HallenprojektStatusAppDelegate.h"

@implementation HallenprojektStatusAppDelegate

@synthesize window, sbMenu, placesMenuItem, logoutItem, preferencesController, currentlySelectedItem;

- (void) addItemsToMenu:(NSMenu *) menu fromDictionary:(NSDictionary *) dictionary{
	for (NSDictionary *place in dictionary)
	{
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[[place objectForKey:@"place"] objectForKey:@"name"] action:@selector(selectedItem:) keyEquivalent:@""];
		[item setTag:[[[place objectForKey:@"place"] objectForKey:@"id"] intValue]];
		[menu addItem:item];
		
	}	
}

- (void) fetchPlaces {
	NSURL *url = [NSURL URLWithString:@"http://www.hallenprojekt.de/places.json"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request start];
	NSError *error = [request error];
	if (!error) {
		NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"the places"] autorelease];
		SBJSON *parser = [[SBJSON alloc] init];
		NSString *json_string = [[NSString alloc] initWithString:[request responseString]];
		NSArray *places = [parser objectWithString:json_string error:nil];
		[self addItemsToMenu:menu fromDictionary:[places objectAtIndex:0]];
		[self addItemsToMenu:menu fromDictionary:[places objectAtIndex:1]];
		[placesMenuItem setSubmenu:menu];
		
	}
	else {
		NSLog(@"%@",[error localizedDescription]);
	}
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	sbItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[sbItem retain];
	NSBundle *bundle = [NSBundle mainBundle];
	statusImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"status_bar_icon" ofType: @"png"]];
	statusAltImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"status_bar_icon" ofType: @"png"]];
	[sbItem setToolTip: @"Hallenprojekt Status App"];
	[sbItem setHighlightMode:YES];
	[sbItem setEnabled:YES];
	[sbItem setImage: statusImage];
	[sbItem setAlternateImage: statusAltImage];
	[sbItem setMenu:sbMenu];
	[sbMenu setAutoenablesItems:false];
	[self fetchPlaces];
	timer = [NSTimer scheduledTimerWithTimeInterval:600
											 target:self
										   selector: @selector(updateLocation)
										   userInfo:nil
											repeats: YES];
}

- (NSError *)setLocation:(NSString *) place_id {
	NSURL *url = [NSURL URLWithString:@"http://www.hallenprojekt.de/set_current_place"];

	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:place_id forKey:@"current_place_id"];
	[request setUsername:[preferencesController getUsername]];
	[request setPassword:[preferencesController getPassword]];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setDelegate:self];
	[request start];
	return [request error];
}

- (void) updateLocation {
	if(self.currentlySelectedItem){
		[self setLocation: [NSString stringWithFormat:@"%d", [self.currentlySelectedItem tag]]];
	}
}


- (void)selectedItem:(id) sender {
	NSMenuItem *item = (NSMenuItem *) sender;
	NSError *error = [self setLocation: [NSString stringWithFormat:@"%d", [item tag]]];
	if(error){
		NSLog(@"%@",[error localizedDescription]);
		[preferencesController loadPreferences:self];
	}else {
		if(self.currentlySelectedItem)
		{
			[self.currentlySelectedItem setState:NSOffState];
		}
		[item setState:NSOnState];
		self.currentlySelectedItem = item;
		[self.logoutItem setEnabled:true];
	}
}

- (IBAction) logout: (id) sender {
	[self setLocation: @""];
	[self.logoutItem setEnabled:false];
	[self.currentlySelectedItem setState:NSOffState];
	self.currentlySelectedItem = NULL;
}

-(void) dealloc {	
    [timer invalidate];
	[timer release];
	[window release];
    [statusImage release];
    [statusAltImage release];
	[preferencesController release];
	[selectedItem release];
	[logoutItem release];
    [super dealloc];
}

@end
