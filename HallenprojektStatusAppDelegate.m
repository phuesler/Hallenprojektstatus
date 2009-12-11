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

- (void) fileNotifications
{
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
														   selector: @selector(receiveSleepNote:) name: NSWorkspaceWillSleepNotification object: NULL];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
														   selector: @selector(receiveWakeNote:) name: NSWorkspaceDidWakeNotification object: NULL];
}


- (void) setStatusIcon {
	NSBundle *bundle = [NSBundle mainBundle];
	if(loggedIn){
		statusImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"status_bar_icon_active" ofType: @"png"]];	
	}
	else {
		statusImage = [[NSImage alloc] initWithContentsOfFile: [bundle pathForResource: @"status_bar_icon_inactive" ofType: @"png"]];		
	}
	[sbItem setImage: statusImage];
	[sbItem setAlternateImage: statusImage];

}

- (void) fetchPlaces {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HALLENPROJEKT_SERVER,@"places.json"]];
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
	loggedIn = false;
	sbItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[sbItem retain];
	[self setStatusIcon];
	[sbItem setToolTip: @"Hallenprojekt Status App"];
	[sbItem setHighlightMode:YES];
	[sbItem setEnabled:YES];
	[sbItem setMenu:sbMenu];
	[sbMenu setAutoenablesItems:false];
	[self fetchPlaces];
	timer = [NSTimer scheduledTimerWithTimeInterval:600
											 target:self
										   selector: @selector(updateLocation)
										   userInfo:nil
											repeats: YES];
	[self fileNotifications];
}

- (NSError *)setLocation:(NSString *) place_id {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HALLENPROJEKT_SERVER,@"set_current_place"]];

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
	}
	else 
	{
		if(self.currentlySelectedItem)
		{
			[self.currentlySelectedItem setState:NSOffState];
		}
		[item setState:NSOnState];
		self.currentlySelectedItem = item;
		[self.logoutItem setEnabled:true];
		[self.logoutItem setTitle:[NSString stringWithFormat:@"Check out from %@", [item title]]];
		loggedIn = true;
		[self setStatusIcon];
	}
}

- (void) updateMenuForLogoutState {
	[self.logoutItem setEnabled:false];
	[self.currentlySelectedItem setState:NSOffState];
	self.currentlySelectedItem = NULL;
	[self.logoutItem setTitle:@"Check out"];
	loggedIn = false;
	[self setStatusIcon];	
}

- (IBAction) logout: (id) sender {
	[self setLocation: @""];
	[self updateMenuForLogoutState];
}

-(IBAction) gotoWebsite: (id) sender{
 [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.hallenprojekt.de"]];
}

- (void) receiveSleepNote: (NSNotification*) note
{
	[self updateMenuForLogoutState];
}

- (void) receiveWakeNote: (NSNotification*) note
{
	//	update list of places;
}

-(void) dealloc {	
    [timer invalidate];
	[timer release];
	[window release];
    [statusImage release];
	[preferencesController release];
	[selectedItem release];
	[logoutItem release];
    [super dealloc];
}

@end
