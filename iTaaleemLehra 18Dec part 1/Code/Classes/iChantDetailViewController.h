//
//  iChantDetailViewController.h
//  iChant
//
//  Created by iPhone Developer on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iChantAppDelegate.h"
#import "PlayerViewController.h"
#import "UpdateProduectViewController.h"
#import "SettingViewController.h"
#import "Constants.h"
#import "ItemParser.h"
#import "ConstantInApps.h"
#import "MPAdView.h"
#import "FBConnect.h"
@interface iChantDetailViewController : UIViewController <MPAdViewDelegate,SettingsViewDelegate,UIPopoverControllerDelegate>{
	
	UIView *instructionsView;
	UITableView *mTableView;
	UIBarButtonItem *infoButton;
	UIBarButtonItem *editButton;
	UIBarButtonItem *done;
	UIButton *login;
	iChantAppDelegate *appdel;
	
	//FBSession *session;
	//FBLoginDialog *dialog;
	BOOL editing;
	
	/*NSUserDefaults *userDefaults;
	NSMutableArray *narrations;
	NSMutableArray *displayLanguages;
	NSMutableArray *beadsArray;
	NSMutableArray *malasArray;
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;*/
	NSMutableArray *productIDArray;
	NSMutableArray *displayProductOrderArray;
	
	NSMutableArray *chantNameArray;
	NSMutableArray *chantIconArray;
	NSMutableArray *chantDirectoryArray;
	
	NSString *chantDetailPath;
	NSString *directoryPath;
	
	NSMutableArray *narrationArray;
	NSMutableArray *displayArray;
	NSString *paidOrFree;
	NSArray *content;
    __unsafe_unretained IBOutlet UIButton *GetMoreButton;
    
    
    UIBarButtonItem *SettingBarButton;
    
}
- (IBAction)GetMoreButtonAction:(id)sender;
@property (nonatomic, retain) Facebook *fbObject;

@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)IBOutlet UIView *instructionsView;
@property(nonatomic,strong)IBOutlet UIBarButtonItem *done;
@property(nonatomic,strong)IBOutlet UIButton *login;

@property(nonatomic,strong)NSMutableArray *chantNameArray;
@property(nonatomic,strong)NSMutableArray *chantIconArray;
@property(nonatomic,strong)NSMutableArray *chantDirectoryArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;
@property(nonatomic,strong)NSMutableArray *displayProductOrderArray;
@property(nonatomic,strong)NSString *directoryPath;

@property(nonatomic,strong)NSMutableArray *narrationArray;
@property(nonatomic,strong)NSMutableArray *displayArray;
@property(nonatomic,strong)NSString *paidOrFree;
@property(nonatomic,strong)NSArray *content;

@property(nonatomic,strong)UIBarButtonItem *infoButton;
//@property(nonatomic,retain)FBLoginDialog *dialog;
@property(nonatomic)BOOL editing;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBarSettings;

//MOPUB BANNER ADS
@property (nonatomic,strong) MPAdView *adView;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;
//POPOVER
@property (strong, nonatomic) UIPopoverController *popOverController;
@property (strong, nonatomic) UIPopoverController *mPopOverController;

@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBG;

-(IBAction) settingButtonClicked;

@end


