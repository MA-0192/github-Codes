//
//  FacebookViewController.h
//  iChant
//
//  Created by iPhone Developer on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect/FBConnect.h"

@interface FacebookViewController : UIViewController{
	UIButton *login;
	
	//FBSession *session;
	//FBLoginDialog *dialog;

}
@property(nonatomic,retain)IBOutlet UIButton *login;
//@property(nonatomic,retain)FBLoginDialog *dialog;

- (void)updateFacebookButton;
- (IBAction)loginButtonClicked;
- (IBAction)sendFacebookMalaUpdate;
@end
