#import <Cocoa/Cocoa.h>
#import "PreferencesController.h";

#if DEBUG
 #define HALLENPROJEKT_SERVER @"http://localhost:3000/"
#else
 #define HALLENPROJEKT_SERVER @"http://www.hallenprojekt.de/"
#endif

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
 @interface HallenprojektStatusAppDelegate : NSObject {
#else
 @interface HallenprojektStatusAppDelegate : NSObject <NSApplicationDelegate> {
#endif
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
