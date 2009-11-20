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

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(@"%@", responseString);	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",[error localizedDescription]);
	NSLog(@"handle errors found in error object");
}

- (void)setLocation{
	NSURL *url = [NSURL URLWithString:@"http://localhost:3000/set_current_place"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:@"1" forKey:@"current_place_id"];
	[request setPostValue:@"json" forKey:@"format"];
	[request setUseKeychainPersistance:YES];
	[request setUsername:@"joe"];
	[request setPassword:@"testtest"];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setDelegate:self];
	[request startAsynchronous];	
}

- (IBAction) listPlaces: (id) sender {
	NSURL *url = [NSURL URLWithString:@"http://www.hallenprojekt.de/places.json"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request start];
	NSError *error = [request error];
	if (!error) {
		// Create SBJSON object to parse JSON
		SBJSON *parser = [[SBJSON alloc] init];
		NSString *json_string = [[NSString alloc] initWithString:[request responseString]];
		// parse the JSON string into an object - assuming json_string is a NSString of JSON data
		NSArray *places = [parser objectWithString:json_string error:nil];
		for (NSDictionary *place in [places objectAtIndex:0])
		{
			NSLog(@"%@", [[place objectForKey:@"place"] objectForKey:@"name"]);
		}
	}
	else {
		NSLog(@"%@",[error localizedDescription]);
	}
}


-(IBAction) setLocation: (id) sender{
	[self setLocation];
}

@end
