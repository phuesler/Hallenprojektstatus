#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject {
	NSPanel *panel;
	NSSecureTextField *passwordTextField;
	NSTextField *usernameTextField;
	NSString * username;
	NSString *dataFile;
	
}

@property(assign) IBOutlet NSPanel *panel;
@property(assign) IBOutlet NSSecureTextField *passwordTextField;
@property(assign) IBOutlet NSTextField *usernameTextField;
@property(copy) NSString *dataFile;
@property(copy) NSString *username;

-(IBAction) saveCredentials: (id) sender;
-(IBAction) loadPreferences: (id) sender;
-(NSString *) getUsername;
-(NSString *) getPassword;

@end
