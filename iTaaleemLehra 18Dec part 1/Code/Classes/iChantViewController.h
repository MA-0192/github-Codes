//
//  iChantViewController.h
//  iChant
//
//  Created by iPhone Developer on 9/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "iChantAppDelegate.h"
#import "PlayerViewController.h"
#import "UpdateProduectViewController.h"
#import "FacebookViewController.h"
#import "iChantDetailViewController.h"
#import "Constants.h"
#import "ItemParser.h"
#import <iAd/iAd.h>
#import "ConstantInApps.h"
#import "MPAdView.h"
#import <Twitter/Twitter.h>
#import "FBConnect.h"
#import "PackageListModalClass.h"
#import "MAProductRequest.h"

@interface iChantViewController : UIViewController<MFMailComposeViewControllerDelegate,UIWebViewDelegate,MPAdViewDelegate,FBSessionDelegate,FBRequestDelegate,FBDialogDelegate, MAProductRequestDelegate> {
    
    
    UIImageView *bgpopimg,*bgpopimg1;
    UIImageView *imageView;
    UILabel *PopLbl;
    UIButton *goBtn;
    
	int k;
    UILabel *TimerLbl;
    NSString *remainCountTimer;
    
	UIView *instructionsView;
	UITableView *mTableView;
	UIBarButtonItem *editButton;
	UIBarButtonItem *done;
	
	iChantAppDelegate *appdel;
	NSUserDefaults *userDefaultObj; 
	
	BOOL editing;
	
	NSUserDefaults *userDefaults;
	NSMutableArray *narrations;
	NSMutableArray *displayLanguages;
	NSMutableArray *beadsArray;
	NSMutableArray *malasArray;
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;
	NSMutableArray *productIDArray;
	//NSMutableArray *displayProductOrderArray;
	
	NSMutableArray *chantNameArray;
	NSMutableArray *chantIconArray;
	NSMutableArray *chantDirectoryArray;
	NSString *chantDetailPath;
	
	
	NSString *addBanner;
	ADBannerView *banner;
	UIActivityIndicatorView *addBannerActivity;
	
	UIView *firstTimeInfoView;
	UIButton *infoViewEnableButton;
	UITextView *firstInfoTextView;
	BOOL infoViewYESorNo;
	UIWebView *addBannerWebView;
	UIActivityIndicatorView *activityIndicator;
    
    UIView *popupview;
    
    NSMutableArray *packagesArray;
    
    NSTimer *timer;
    
    
    int IndexPath;
    __unsafe_unretained IBOutlet UIButton *GetmoreButton;
}
@property (nonatomic, retain) Facebook *fbObject;


@property (strong, nonatomic) PackageListModalClass *item;
@property (strong, nonatomic) MAProductRequest *productReq;



@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)IBOutlet UIView *instructionsView;
@property(nonatomic,strong)IBOutlet UIBarButtonItem *done;
@property(nonatomic,strong)IBOutlet ADBannerView *banner;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *addBannerActivity;
@property (nonatomic, strong) UIBarButtonItem *flipButton;

@property(nonatomic,strong)NSMutableArray *narrations;
@property(nonatomic,strong)NSMutableArray *displayLanguages;
@property(nonatomic,strong)NSMutableArray *beadsArray;
@property(nonatomic,strong)NSMutableArray *malasArray;
@property(nonatomic,strong)NSMutableArray *selectedAudioSettingArray;
@property(nonatomic,strong)NSMutableArray *numberOfTimesArray;
@property(nonatomic,strong)NSMutableArray *numberOfSecondArray;

@property(nonatomic,strong)NSMutableArray *chantNameArray;
@property(nonatomic,strong)NSMutableArray *chantIconArray;
@property(nonatomic,strong)NSMutableArray *chantDirectoryArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;
//@property(nonatomic,retain)NSMutableArray *displayProductOrderArray;

@property(nonatomic)BOOL editing;

@property(nonatomic,strong) NSUserDefaults *userDefaultObj;
@property(nonatomic,strong)IBOutlet UIView *firstTimeInfoView;
@property(nonatomic,strong)IBOutlet UIButton *infoViewEnableButton;
@property(nonatomic,strong)IBOutlet UITextView *firstInfoTextView;
@property(nonatomic)BOOL infoViewYESorNo;
@property (nonatomic,strong)IBOutlet UIWebView *addBannerWebView;
@property (nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) IBOutlet UIButton *btnFirstTimeHelpScreen;
@property (nonatomic, strong) IBOutlet UIButton *btnDontShowAgainHelpScreen;
@property (nonatomic, strong) IBOutlet UILabel *lblDontShowAgain;
@property (nonatomic, strong) IBOutlet UIView *viewFirstTimeHelpView;
@property (nonatomic, strong) IBOutlet UIButton *btnHelpScreenOk;
@property(nonatomic) BOOL boolHelpScreen;

@property (nonatomic,strong) IBOutlet UIToolbar *toolBarGetMore;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewBackground;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewHelpScreen;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewHelpRestore;

@property (nonatomic,strong) IBOutlet UILabel *lblCopyright;
@property (nonatomic,strong) IBOutlet UIButton *btnOtherApps;
@property (nonatomic,strong) IBOutlet UIButton *btnFaq;
@property (nonatomic,strong) IBOutlet UIButton *btnFeedback;
@property (nonatomic,strong) IBOutlet UITextView *txtViewInfo;
@property (nonatomic,strong) IBOutlet UIButton *btnTwitter;
@property (nonatomic,strong) IBOutlet UIButton *btnFacebook;

//MOPUB BANNER ADS
@property (nonatomic,strong) MPAdView *adView;
@property (nonatomic) BOOL boolCheckForAdInInfo;

@property (strong, nonatomic) IBOutlet UIButton *btnGetMore;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdates;
@property (strong, nonatomic) IBOutlet UIButton *btnActiveDownload;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewAppLogo;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewMALogo;


-(IBAction)otherAppsButtonPressed;
-(IBAction)btnFaqPressed;
-(IBAction)sendFeedBackButtonPressed;
-(IBAction)btnTwitterClicked;
-(IBAction)getMoreButtonPressed;
-(IBAction)getUpdatesButtonPressed;
-(IBAction)facebookButtonPressed;
-(IBAction)flipActiveDownloadAction:(id)sender;
-(IBAction)firstTimeInfoButtonTapped;
-(IBAction)infoViewEnableButtonTapped;
- (void)flipAction:(id)sender;

-(IBAction)btnDontShowAgainHelpScreenClicked;
-(IBAction)btnHelpScreenOkClicked;

-(void)changeViewForLandscapeMode;
-(void)changeViewForPortraitMode;

@end


