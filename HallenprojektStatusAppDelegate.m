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

@synthesize window, sbMenu, placesMenuItem, preferencesController;

- (void) fetchPlaces {
	NSURL *url = [NSURL URLWithString:@"http://localhost:3000/places.json"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request start];
	NSError *error = [request error];
	if (!error) {
		NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"the places"] autorelease];
		SBJSON *parser = [[SBJSON alloc] init];
		NSString *json_string = [[NSString alloc] initWithString:[request responseString]];
		NSArray *places = [parser objectWithString:json_string error:nil];
		for (NSDictionary *place in [places objectAtIndex:1])
		{
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[[place objectForKey:@"place"] objectForKey:@"name"] action:@selector(selectedItem:) keyEquivalent:@""];
			[item setTag:[[[place objectForKey:@"place"] objectForKey:@"id"] intValue]];
			[menu addItem:item];
			
		}
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
	statusImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"pomodoro" ofType: @"png"]];
	statusAltImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"pomodoroBreak" ofType: @"png"]];
	[sbItem setToolTip: @"A tooltip"];
	[sbItem setHighlightMode:YES];
	[sbItem setEnabled:YES];
	[sbItem setImage: statusImage];
	[sbItem setAlternateImage: statusAltImage];
	[sbItem setMenu:sbMenu];	
	[self fetchPlaces];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	NSLog(@"%@", responseString);	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",[error localizedDescription]);
	NSLog(@"handle errors found in error object");
}

- (void)setLocation:(NSString *) place_id {
	NSURL *url = [NSURL URLWithString:@"http://localhost:3000/set_current_place"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:place_id forKey:@"current_place_id"];
	[request setPostValue:@"json" forKey:@"format"];
	[request setUseKeychainPersistance:YES];
	[request setUsername:@"joe"];
	[request setPassword:@"testtest"];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setDelegate:self];
	[request start];	
}

- (void)selectedItem:(id) sender {
	NSMenuItem *item = (NSMenuItem *) sender;
	NSLog(@"%d", [item tag]);
	[self setLocation: [NSString stringWithFormat:@"%d", [item tag]]];
	[item setTitle: [[item title] stringByAppendingString:@" (logging in)"]];
}

- (IBAction) listPlaces: (id) sender {
}


@end
