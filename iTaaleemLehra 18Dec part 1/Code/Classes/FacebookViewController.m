//
//  FacebookViewController.m
//  iChant
//
//  Created by iPhone Developer on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"


@implementation FacebookViewController
@synthesize login;
@synthesize dialog;

//static NSString* kApiKey = @"b9c0d5f95a932c82ded70366459372e0";
//static NSString* kApiSecret = @"253982b04555a666f4f1eba50108e2d6"; // @"<YOUR SECRET KEY>";
static NSString* kApiKey = @"2d4995a2f9e9fa0ae596328b88650aaa";
static NSString* kApiSecret = @"50dda7029592bd6c9378a3c688ea9e48"; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Facebook";
	self.navigationController.navigationBar.tintColor=[UIColor clearColor];
	UIBarButtonItem *cancel=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
	self.navigationItem.leftBarButtonItem=cancel;
 
 //To resume the facebook session if one is login already
 /*if (kGetSessionProxy)
 session = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy delegate:self] retain];
 else 
 session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
 [session resume];
 [self updateFacebookButton];*/
 [super viewDidLoad];
}
-(void) doneClicked
{
	[self dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*- (void)updateFacebookButton
{
	NSLog(@"came into updateFacebook button");
	UIImage *logInBtnBG = [[[UIImage imageNamed:@"login2.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	UIImage *logOffBtnBG = [[[UIImage imageNamed:@"logout.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
	NSLog(@"session connected %d",[session isConnected]);
	[login setImage:(([session isConnected] == YES) ? logOffBtnBG : logInBtnBG) forState:UIControlStateNormal];
	
}

- (IBAction)loginButtonClicked
{
	if([session isConnected] == YES)
	{
		[session logout];
	}
	else 
	{
		dialog = [[[FBLoginDialog alloc] initWithSession:session] autorelease];
		[dialog show];
		
	}
	
	
}
// Facebook publish
- (IBAction)sendFacebookMalaUpdate
{
	if([session isConnected] == YES)
	{
		FBStreamDialog* dialog1 = [[[FBStreamDialog alloc] init] autorelease];
		dialog1.delegate = self;
		dialog1.userMessagePrompt = @"What's on your mind ?";
		NSString *str = [[NSString alloc ]initWithFormat:@"{\"name\":\"iTaaleem Lehra\",\"href\":\"http://itunes.com/apps/itaaleemlehra\",\"caption\":\"I am using iTaaleem Lehra \",\"media\":[{\"type\":\"image\",\"src\":\"http://inapp.zenagestudios.com/data/icons/itaaleemlehra/facebook.png\",\"href\":\"http://www.zenagestudios.com\"}]}"];
		
		dialog1.attachment = str;	
		
		
		
		// replace this with a friend's UID
		// dialog.targetId = @"999999";
		[dialog1 show];
	}
	else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"You are not logged in,\n\t Please login!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

}


/////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	NSString * str = [NSString stringWithFormat:@"Error(%d) %@", error.code,error.localizedDescription];
	NSLog(@"%@",str);
}


/////////////////////////////////////////////////////////////////
// FBSessionDelegate

- (void)session:(FBSession*)sessio didLogin:(FBUID)uid {
	
	[self updateFacebookButton];
	
}


- (void)sessionDidNotLogin:(FBSession*)sessio {
	NSLog(@"Canceled login");
}


- (void)sessionDidLogout:(FBSession*)sessio {
	NSLog(@"Disconnected");
	[self updateFacebookButton];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
	NSString * str;
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		str = [NSString stringWithFormat:@"Logged in as %@", name];
		NSLog(@"%@",str);
	} else if ([request.method isEqualToString:@"facebook.users.setStatus"]) {
		NSString* success = result;
		if ([success isEqualToString:@"1"]) {
			str = [NSString stringWithFormat:@"Status successfully set"]; 
			NSLog(@"%@",str);
		} else {
			str = [NSString stringWithFormat:@"Problem setting status"]; 
			NSLog(@"%@",str);
		}
	} else if ([request.method isEqualToString:@"facebook.photos.upload"]) {
		NSDictionary* photoInfo = result;
		NSString* pid = [photoInfo objectForKey:@"pid"];
		str = [NSString stringWithFormat:@"Uploaded with pid %@", pid];
		NSLog(@"%@",str);
	}
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	NSString *str = [NSString stringWithFormat:@"Error(%d) %@", error.code,error.localizedDescription];
	NSLog(@"%@",str);
}

*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
