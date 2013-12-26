//
//  iChantViewController.m
//  iChant
//
//  Created by iPhone Developer on 9/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iChantViewController.h"
#import "Constants.h"
#import "InfoViewController.h"
#import "GetPackageListViewController.h"
#import "CBAutoScrollLabel.h"
//#import "CustomImageUrl.h"
#import "UIImageView+WebCache.h"
#import "HelpScreenViewController.h"
@implementation iChantViewController

@synthesize banner;
@synthesize addBannerActivity;
@synthesize mTableView;
@synthesize instructionsView;
@synthesize narrations;
@synthesize displayLanguages;
@synthesize beadsArray;
@synthesize malasArray;
@synthesize selectedAudioSettingArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;
@synthesize productIDArray;
@synthesize done;
@synthesize editing;

@synthesize chantNameArray;
@synthesize chantIconArray;
@synthesize chantDirectoryArray;
//@synthesize displayProductOrderArray;

@synthesize infoViewYESorNo;
@synthesize firstTimeInfoView;
@synthesize infoViewEnableButton;
@synthesize firstInfoTextView;
@synthesize userDefaultObj;
@synthesize addBannerWebView;
@synthesize activityIndicator;

@synthesize btnFirstTimeHelpScreen;
@synthesize btnDontShowAgainHelpScreen;
@synthesize lblDontShowAgain;
@synthesize viewFirstTimeHelpView;
@synthesize boolHelpScreen;

@synthesize lblCopyright = _lblCopyright;
@synthesize btnOtherApps = _btnOtherApps;
@synthesize btnFaq = _btnFaq;
@synthesize btnFeedback = _btnFeedback;
@synthesize txtViewInfo = _txtViewInfo;
@synthesize flipButton = _flipButton;
@synthesize btnTwitter = _btnTwitter;
@synthesize btnFacebook = _btnFacebook;
@synthesize imgViewAppLogo = _imgViewAppLogo;
@synthesize imgViewMALogo = _imgViewMALogo;

//MOPUB
@synthesize adView = _adView;
@synthesize imgViewBackground;
@synthesize imgViewHelpScreen;
@synthesize imageViewHelpRestore;
@synthesize boolCheckForAdInInfo = _boolCheckForAdInInfo;

@synthesize btnGetMore = _btnGetMore;
@synthesize btnUpdates = _btnUpdates;
@synthesize btnActiveDownload = _btnActiveDownload;
@synthesize imgViewBG = _imgViewBG;
@synthesize fbObject;
@synthesize item = _item;
@synthesize productReq ;


//#define kSampleAdUnitIDForiPhone @"be96b0jyj8ae9a0sffdsfsdfsdf4ff5b40fc44950f01418"
//#define kSampleAdUnitIDForiPad @"aceeaaddsghfhf4994sdfsfdsfsf181979aa5af6f5e292a"

#define kSampleAdUnitIDForiPhone @"be96b08ae9a04ff5b40fc44950f01418"
#define kSampleAdUnitIDForiPad @"aceeaaddf4994181979aa5af6f5e292a"

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
    //    self.tabBarItem.image = [UIImage imageNamed:@"hometab.png"];
        self.tabBarItem.title=@"Home";
        
    [  self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor whiteColor], UITextAttributeTextColor,
                                                [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                                [UIFont fontWithName:@"Helvetica" size:12.0], UITextAttributeFont, nil]
                                      forState:UIControlStateNormal];
        
       
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"hometab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"hometab.png"]];
        
        
          
        
       productReq = [MAProductRequest sharedInstance];
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.viewFirstTimeHelpView removeFromSuperview];
    
    [appdel.window addSubview:self.viewFirstTimeHelpView];
}
- (void)viewDidLoad 
{
    GetmoreButton.hidden=NO;
    self.viewFirstTimeHelpView.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    
    GetmoreButton.backgroundColor=[UIColor colorWithRed:214.0f/255.0f green:97.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
    

if (![[ [NSUserDefaults standardUserDefaults] objectForKey:@"help" ] isEqualToString:@"yes"]) {
    HelpScreenViewController  *addController1;
    
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        
        addController1 = [[HelpScreenViewController alloc]initWithNibName:@"HelpScreenViewController-iPhone" bundle:nil];
        
    }else
    {
        addController1 = [[HelpScreenViewController alloc]initWithNibName:@"HelpScreenViewController" bundle:nil];
    }
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
    [self presentModalViewController:navigationController animated:NO];
    }
    
    fbObject=[Facebook alloc];
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        
        self.navigationController.navigationBar.translucent=NO;
           self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        
        
        //GetmoreButton.barTintColor=[UIColor whiteColor];
    }

	NSLog(@"In viewDidLoad in player view");
	UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = kViewTitle;
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor whiteColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:25.0];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        bigLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    else
        bigLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    [bigLabel sizeToFit];
    self.navigationItem.titleView = bigLabel;
    
	mTableView.backgroundColor=[UIColor clearColor];
	mTableView.rowHeight=60;
	
	appdel=[[UIApplication sharedApplication] delegate];
	userDefaultObj=[NSUserDefaults standardUserDefaults];
	
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
	//Checking if don't show button is checked already
	appdel.updateInfoViewNumber = [[self.userDefaultObj objectForKey:@"updateinfoviewnumber"]intValue];
	if ([self.userDefaultObj objectForKey:@"updateinfoviewnumber"] == nil)
		appdel.updateInfoViewNumber = 1;
	if (appdel.updateInfoViewNumber < 2)
		[self.view addSubview:self.firstTimeInfoView];
		
    
    //Checking if don't show button in Help Screen is checked already
	appdel.updateHelpScreenNumber = [[self.userDefaultObj objectForKey:@"updatehelpscreennumber"]intValue];
	if ([self.userDefaultObj objectForKey:@"updatehelpscreennumber"] == nil)
		appdel.updateHelpScreenNumber = 1;
	if (appdel.updateHelpScreenNumber < 2)
		[self.view addSubview:self.viewFirstTimeHelpView];
	
				
	//showing the info and edit button
	// add our custom flip button as the nav bar's custom right view
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(flipAction:) forControlEvents:UIControlEventTouchUpInside];
  
	self.flipButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.leftBarButtonItem = self.flipButton;
    
	editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
  
    
    
    if ( isAtLeast7 ) {
        infoButton.tintColor=[UIColor whiteColor];
        self.flipButton.tintColor=[UIColor whiteColor];
        editButton.tintColor=[UIColor whiteColor];
    }
    
	self.navigationItem.rightBarButtonItem = self.flipButton;
	self.navigationItem.leftBarButtonItem = editButton;
	
    self.boolCheckForAdInInfo = TRUE;
    
    
    UISwipeGestureRecognizer *showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [mTableView addGestureRecognizer:showExtrasSwipe];

    
  
 
//    Reachability *reach = [[Reachability alloc]init];
//    reach = [Reachability reachabilityForInternetConnection];
//    if ([reach currentReachabilityStatus] != NotReachable)
//    {
//        self.item = [[PackageListModalClass alloc] init];
//        productReq.delegate = self;
//        [productReq fetchProductListFromServer];
//    }
	[super viewDidLoad];
}
-(void)productListRetrieved:(NSArray *)arrProductList
{
    NSLog(@"%d",arrProductList.count);
    NSLog(@"%@",[[arrProductList  objectAtIndex:1] strName]);
    NSLog(@"%@",[[arrProductList  objectAtIndex:1] strIconimage]);
    NSLog(@"%@",[[arrProductList  objectAtIndex:1] strDescription]);
    NSLog(@"%@",[[arrProductList  objectAtIndex:1] strInstallStatus]);
    
    int r = arc4random_uniform(arrProductList.count-1);
    NSLog(@"%d",r);

    
    self.tabBarController.tabBar.hidden=YES;
    
    popupview=[[UIView alloc]init];
    [self.navigationController.view addSubview:popupview];
    popupview.backgroundColor=[UIColor blackColor];
    popupview.frame=CGRectMake(0, 568, 320, 568);
  
    
    imageView=[[UIImageView alloc]init];
    [imageView setImageWithURL:[NSURL URLWithString:[[arrProductList  objectAtIndex:r] strIconimage] ] placeholderImage:[UIImage imageNamed:@"box@2x.png"]];

    [popupview addSubview:imageView];
  
    
    
    TimerLbl=[[UILabel alloc]init];
    TimerLbl.textColor=[UIColor whiteColor];
    TimerLbl.textAlignment=NSTextAlignmentCenter;
    TimerLbl.font=[UIFont boldSystemFontOfSize:24];
    TimerLbl.numberOfLines=1;
    TimerLbl.backgroundColor=[UIColor clearColor];
    TimerLbl.text=remainCountTimer;
    [popupview addSubview:TimerLbl];
    
    
    PopLbl=[[UILabel alloc]init];
    PopLbl.textColor=[UIColor whiteColor];
    PopLbl.textAlignment=NSTextAlignmentCenter;
  
    PopLbl.numberOfLines=4;
    PopLbl.text=[NSString stringWithFormat:@"Have You Checked Newly Released '%@' In The Store ?",[[arrProductList  objectAtIndex:r] strName]];
      PopLbl.backgroundColor=[UIColor clearColor];
    [popupview addSubview:PopLbl];
    
    
    
    goBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn addTarget:self action:@selector(goBtnAction) forControlEvents:UIControlEventTouchUpInside ];
    [goBtn setBackgroundColor:[UIColor clearColor]];
    [goBtn setTitle:@"Take me to the store" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popupview addSubview:goBtn];
    goBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
  
    [self updateProductList];
            if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                bgpopimg.frame=CGRectMake(30, 10, 260, 300);
                imageView.frame=CGRectMake(120, 90, 80, 80);
                TimerLbl.frame=CGRectMake(250, 40, 40, 40);
                PopLbl.frame=CGRectMake(60, 200, 200, 90);
                goBtn.frame=CGRectMake(55, 300, 210, 50);

            }else
            {
                 bgpopimg.frame=CGRectMake(30, 30, 260, 360);
                imageView.frame=CGRectMake(110, 100, 100, 100);
                TimerLbl.frame=CGRectMake(250, 40, 40, 40);
                PopLbl.frame=CGRectMake(60, 220, 200, 90);
                goBtn.frame=CGRectMake(55, 360, 210, 50);

            }
    
    [UIView beginAnimations:@"your text" context:nil];
    [UIView setAnimationDuration:0.6]; //Your animation duration
    [UIView setAnimationDelegate:self];
    //
    popupview.frame=CGRectMake(0, 0, 320, 568);
    //
    [UIView commitAnimations];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        goBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        TimerLbl.font=[UIFont boldSystemFontOfSize:38];
        PopLbl.font=[UIFont boldSystemFontOfSize:30];
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
        }
        else
        {
            [self changeViewForLandscapeMode];
        }
    }
    if (timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(handleTimer)
                                               userInfo:nil
                                                repeats:YES];
        k=9;
    }
    else
    {
        if (timer != nil)
        {
            [timer invalidate];
            timer = nil;
        }
    }
}
-(void)goBtnAction
{
    popupview.hidden=YES;
    [popupview removeFromSuperview];
      self.tabBarController.tabBar.hidden=NO;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
	
}
-(void)handleTimer
{
    k=k-1;
    
    TimerLbl.text= [NSString stringWithFormat:@"%d", k];

    if ([TimerLbl.text isEqualToString:@"0"]) {
        popupview.hidden=YES;
        [popupview removeFromSuperview];
        self.tabBarController.tabBar.hidden=NO;
     [timer invalidate];
   }
}
-(void)productStatusUpdated:(NSString *)message
{
}
-(void) updateProductList
{
    NSLog(@"%@",packagesArray);
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
       self.tabBarController.tabBar.hidden=NO;
    
    [self.mTableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePackageList) name:@"updateTable" object:nil];
    
    if(self.boolCheckForAdInInfo){
        [self.adView removeFromSuperview];
        self.adView.delegate = nil;
    }
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
        }
        else
        {
            [self changeViewForLandscapeMode];
        }
    }
    
    [popupview removeFromSuperview];
   
}

-(void)updatePackageList {
	if(chantNameArray!=nil)
	{
		chantNameArray=nil;
		chantDirectoryArray=nil; //This array contains the path of each item's directory
		chantIconArray=nil;
        
	}
	chantNameArray = [[NSMutableArray alloc] init];
	chantDirectoryArray = [[NSMutableArray alloc] init];
	chantIconArray=[[NSMutableArray alloc] init];
	
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachesPath = [NSString stringWithFormat:@"%@/Caches",libraryPath];
	
	
	// for getting all subdirectories those are in Documents Directory
	//NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths1 objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *fileListArray =  [manager contentsOfDirectoryAtPath:cachesPath error:nil];
	NSMutableArray  *fileList = [[NSMutableArray alloc] initWithArray:fileListArray];
    
	NSString *s;
	
	for (s in fileList)
	{
		NSString *folderPath = [NSString stringWithFormat:@"%@/%@/",cachesPath,s];
		chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:folderPath];
        
        
        NSLog(@"%@",folderPath);
        
        if (chantDetailPath != NULL)
			[chantDirectoryArray addObject:[NSString stringWithFormat:@"%@/%@/",cachesPath,s]];
	}
    
	NSArray *detailArray;
	for (int i=0; i<[chantDirectoryArray count]; i++)
	{
		chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:[chantDirectoryArray objectAtIndex:i]];
		if (chantDetailPath != nil)
		{
			detailArray = [[NSArray alloc] initWithContentsOfFile:chantDetailPath];
			[chantNameArray addObject:[detailArray objectAtIndex:0]];
			[chantIconArray addObject:[detailArray objectAtIndex:1]];
			detailArray=nil;
			
		}
	}
	
	[mTableView reloadData];

        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
//                if(self.boolCheckForAdInInfo)
//                {
//                    if (appdel.updateHelpScreenNumber < 2)
//                    {
//                        
//                    }
//                    else{
                        self.adView.hidden = YES;
                        self.adView = nil;
                        self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad                                                     size:MOPUB_LEADERBOARD_SIZE];
                        self.adView.delegate = self;
                        self.adView.frame = CGRectMake(0, 800,728, 90);
                        self.adView.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:self.adView];
                        [self.adView loadAd];
                //    }
                    
                    /*self.viewFirstTimeHelpView.frame = CGRectMake(0, 0, 768, 1024);
                    self.imgViewHelpScreen.frame = CGRectMake(0, 0, 768, 1024);
                    self.imgViewHelpScreen.image = [UIImage imageNamed:@"Bg_Portrait.png"];*/
           //     }
            }
            else
            {
//                if(self.boolCheckForAdInInfo)
//                {
//                    if (appdel.updateHelpScreenNumber < 2)
//                    {
//                        
//                    }
//                    else{
                        self.adView.hidden=YES;
                        self.adView = nil;
                        self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad
                                                                    size:MOPUB_LEADERBOARD_SIZE];
                        self.adView.delegate = self;
                        self.adView.frame = CGRectMake(0, 570,1024, 90);
                        self.adView.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:self.adView];
                        [self.adView loadAd];
//                    }
//                    
//                }
            }
        }
        else {
//            if(self.boolCheckForAdInInfo)
//            {
//                if (appdel.updateHelpScreenNumber < 2)
//                {
//                    
//                }
//                else{
                    self.adView.hidden = YES;
                    self.adView = nil;
                    self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPhone
                                                                size:MOPUB_BANNER_SIZE];
                    self.adView.delegate = self;
                      self.adView.backgroundColor = [UIColor clearColor];
            
    if([[UIScreen mainScreen] bounds].size.height == 480)
            {
        self.adView.frame = CGRectMake(0, 272,MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        }else
        {
                   self.adView.frame = CGRectMake(0, 363,MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        }
                    [self.view addSubview:self.adView];
                    [self.adView loadAd];
//                }
//            }
            
            if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                
          //      GetmoreButton.barTintColor=[UIColor blackColor];
                
                
                self.viewFirstTimeHelpView.frame = CGRectMake(self.viewFirstTimeHelpView.frame.origin.x, self.viewFirstTimeHelpView.frame.origin.y, self.viewFirstTimeHelpView.frame.size.width, 480);
                self.btnDontShowAgainHelpScreen.frame = CGRectMake(76, 355, self.btnDontShowAgainHelpScreen.frame.size.width, self.btnDontShowAgainHelpScreen.frame.size.height);
                self.lblDontShowAgain.frame = CGRectMake(self.lblDontShowAgain.frame.origin.x, 355, self.lblDontShowAgain.frame.size.width, self.lblDontShowAgain.frame.size.height);
                self.btnHelpScreenOk.frame = CGRectMake(self.btnHelpScreenOk.frame.origin.x, 380, self.btnHelpScreenOk.frame.size.width, self.btnHelpScreenOk.frame.size.height);
                self.firstInfoTextView.frame = CGRectMake(self.firstInfoTextView.frame.origin.x, self.firstInfoTextView.frame.origin.y, self.firstInfoTextView.frame.size.width, 330);

                
        //        self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
                //self.imgViewHelpScreen.image = [UIImage imageNamed:@"Bg_iPhone.png"];
                GetmoreButton.frame = CGRectMake(GetmoreButton.frame.origin.x, 327, GetmoreButton.frame.size.width, GetmoreButton.frame.size.height);
                self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 321);
                
                
               
                
            }
            if([[UIScreen mainScreen] bounds].size.height == 568)
            {
                self.imgViewBackground.frame = CGRectMake(0, 0, 320, 568);
                self.viewFirstTimeHelpView.frame = CGRectMake(self.viewFirstTimeHelpView.frame.origin.x, self.viewFirstTimeHelpView.frame.origin.y, self.viewFirstTimeHelpView.frame.size.width, 568);
                self.imageViewHelpRestore.frame = CGRectMake(self.imageViewHelpRestore.frame.origin.x, self.imageViewHelpRestore.frame.origin.y, self.imageViewHelpRestore.frame.size.width, 568);
                self.imgViewHelpScreen.frame = CGRectMake(self.imgViewHelpScreen.frame.origin.x, self.imgViewHelpScreen.frame.origin.y, self.imgViewHelpScreen.frame.size.width, 568);
                
                self.btnDontShowAgainHelpScreen.frame  = CGRectMake(self.btnDontShowAgainHelpScreen.frame.origin.x, 400, self.btnDontShowAgainHelpScreen.frame.size.width, self.btnDontShowAgainHelpScreen.frame.size.height);
                self.lblDontShowAgain.frame = CGRectMake(self.lblDontShowAgain.frame.origin.x, 400, self.lblDontShowAgain.frame.size.width, self.lblDontShowAgain.frame.size.height);
                self.btnHelpScreenOk.frame = CGRectMake(self.btnHelpScreenOk.frame.origin.x, 450, self.btnHelpScreenOk.frame.size.width, self.btnHelpScreenOk.frame.size.height);
                self.firstInfoTextView.frame = CGRectMake(self.firstInfoTextView.frame.origin.x, self.firstInfoTextView.frame.origin.y, self.firstInfoTextView.frame.size.width, 400);
                
                //self.imageViewHelpRestore.image = [UIImage imageNamed:@"helpscreen_ipod.png"];
          //      self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
                //self.imgViewHelpScreen.image = [UIImage imageNamed:@"Bg_iPod.png"];
                
                GetmoreButton.frame = CGRectMake(GetmoreButton.frame.origin.x, 413, GetmoreButton.frame.size.width, GetmoreButton.frame.size.height);
                
                self.instructionsView.frame = CGRectMake(self.instructionsView.frame.origin.x, self.instructionsView.frame.origin.y, self.instructionsView.frame.size.width, 568);
                
                self.lblCopyright.frame = CGRectMake(self.lblCopyright.frame.origin.x, 450, self.lblCopyright.frame.size.width, self.lblCopyright.frame.size.height);
                self.btnOtherApps.frame = CGRectMake(self.btnOtherApps.frame.origin.x, 410, self.btnOtherApps.frame.size.width, self.btnOtherApps.frame.size.height);
                self.btnFaq.frame = CGRectMake(self.btnFaq.frame.origin.x, 410, self.btnFaq.frame.size.width, self.btnFaq.frame.size.height);
                self.btnFeedback.frame = CGRectMake(self.btnFeedback.frame.origin.x, 410, self.btnFeedback.frame.size.width, self.btnFeedback.frame.size.height);
                
                self.txtViewInfo.frame = CGRectMake(self.txtViewInfo.frame.origin.x, self.txtViewInfo.frame.origin.y, self.txtViewInfo.frame.size.width, 320);
                
            }
        }
    
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
    {
        [self.adView removeFromSuperview];
        self.adView.hidden = YES;
        self.adView.delegate = nil;
        
        
        
    }

}


- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		self.editing=NO;
		[mTableView setEditing:NO animated:NO];
		[mTableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		self.editing=YES;
		[mTableView setEditing:YES animated:YES];
		[mTableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)flipAction:(id)sender
{
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:animationIDfinished:finished:context:)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:([self.view superview] ?
									UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
						   forView:self.view cache:YES];
	
	if ([self.instructionsView superview]){
		[self.instructionsView removeFromSuperview];
     self.tabBarController.tabBar.hidden = NO;
    }
    
	else
    {
        [self.view addSubview:self.instructionsView];
         self.boolCheckForAdInInfo = FALSE;
         self.tabBarController.tabBar.hidden = YES;
    }
			
	[UIView commitAnimations];

	
	// adjust our done/info buttons accordingly
	if ([self.instructionsView superview] == self.view)
    {
        self.flipButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(flipAction:)];
        self.navigationItem.rightBarButtonItem = self.flipButton;
        
        UILabel *bigLabel = [[UILabel alloc] init];
        bigLabel.text = kInfoViewTitle;
        bigLabel.backgroundColor = [UIColor clearColor];
        bigLabel.textColor = [UIColor whiteColor];
        bigLabel.font = [UIFont boldSystemFontOfSize:25.0];
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            bigLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        else
            bigLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        
        [bigLabel sizeToFit];
        self.navigationItem.titleView = bigLabel;
        
        UIImage* imgTellFriend = [UIImage imageNamed:@"tell_a_friend.png"];
        CGRect frameimg = CGRectMake(0, 0, imgTellFriend.size.width, imgTellFriend.size.height);
        UIButton *btnTellFriend = [[UIButton alloc] initWithFrame:frameimg];
        [btnTellFriend setBackgroundImage:imgTellFriend forState:UIControlStateNormal];
        [btnTellFriend addTarget:self action:@selector(tellFriendClicked)
                forControlEvents:UIControlEventTouchUpInside];
   //     btnTellFriend = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [btnTellFriend setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *barButtonTellFriend =[[UIBarButtonItem alloc] initWithCustomView:btnTellFriend];
        self.navigationItem.leftBarButtonItem = barButtonTellFriend;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                [self changeViewForPortraitMode];
            } else {
                [self changeViewForLandscapeMode];
            }
        }
        else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
          
            if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                
            }
            if([[UIScreen mainScreen] bounds].size.height == 568)
            {
                self.instructionsView.frame = CGRectMake(self.instructionsView.frame.origin.x, self.instructionsView.frame.origin.y, self.instructionsView.frame.size.width, 540);
                self.lblCopyright.frame = CGRectMake(75, 450, self.lblCopyright.frame.size.width, self.lblCopyright.frame.size.height);
                self.btnFacebook.frame = CGRectMake(self.btnFacebook.frame.origin.x, 410, self.btnFacebook.frame.size.width, self.btnFacebook.frame.size.height);
                self.btnTwitter.frame = CGRectMake(self.btnTwitter.frame.origin.x, 410, self.btnTwitter.frame.size.width, self.btnTwitter.frame.size.height);
                self.btnFeedback.frame = CGRectMake(self.btnFeedback.frame.origin.x, 410, self.btnFeedback.frame.size.width, self.btnFeedback.frame.size.height);
                self.txtViewInfo.frame = CGRectMake(self.txtViewInfo.frame.origin.x, self.txtViewInfo.frame.origin.y, self.txtViewInfo.frame.size.width, 320);
                self.btnFaq.frame = CGRectMake(self.btnFaq.frame.origin.x, 410, self.btnFaq.frame.size.width, self.btnFaq.frame.size.height);
            }
        }
    }
	else
    {
        UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoButton addTarget:self action:@selector(flipAction:) forControlEvents:UIControlEventTouchUpInside];
           infoButton.tintColor=[UIColor whiteColor];
        self.flipButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        self.navigationItem.rightBarButtonItem = self.flipButton;
        self.flipButton.tintColor=[UIColor whiteColor];
        
        
        UILabel *bigLabel = [[UILabel alloc] init];
        bigLabel.text = kViewTitle;
        bigLabel.backgroundColor = [UIColor clearColor];
        bigLabel.textColor = [UIColor whiteColor];
        bigLabel.font = [UIFont boldSystemFontOfSize:25.0];
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            bigLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        else
            bigLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        
        [bigLabel sizeToFit];
        self.navigationItem.titleView = bigLabel;
        
        self.navigationItem.leftBarButtonItem = editButton;
        self.boolCheckForAdInInfo = TRUE;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                [self changeViewForPortraitMode];
            }
            else
            {
                [self changeViewForLandscapeMode];
            }
        }

    }
}

-(void)tellFriendClicked
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:kFriendSubject];
            
            // Set up recipients
            NSArray *toRecipients = [NSArray arrayWithObject:@""];
            [picker setToRecipients:toRecipients];
            
            // Fill out the email body text
            NSString *emailBody = kFriendsBody;
            [picker setMessageBody:emailBody isHTML:YES];
            
            [self presentModalViewController:picker animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"Please Login to Your Mail !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}


#pragma mark -
#pragma mark BUTTON EVENT HANDLERS

-(IBAction)getMoreButtonPressed
{
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
	
}


-(IBAction)getUpdatesButtonPressed
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        UpdateProduectViewController *updateProductViewObj = [[UpdateProduectViewController alloc]initWithNibName:@"UpdateProduectViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:updateProductViewObj];
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        UpdateProduectViewController *updateProductViewObj = [[UpdateProduectViewController alloc]initWithNibName:@"UpdateProduectViewController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:updateProductViewObj];
        [self presentModalViewController:navigationController animated:YES];
    }
    
	
}

- (IBAction)flipActiveDownloadAction:(id)sender
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        ActiveDownLoadController *activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownloadController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        ActiveDownLoadController *activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];
        [self presentModalViewController:navigationController animated:YES];
    }
	
}

-(IBAction)otherAppsButtonPressed
{
	NSString *urlString = @"http://itunes.com/apps/zenagestudios";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	
}

-(IBAction)btnFaqPressed
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        InfoViewController *objInfoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
        UINavigationController *mNavigationController = [[UINavigationController alloc] initWithRootViewController:objInfoViewController];
        [self presentModalViewController:mNavigationController animated:YES];
    }
    else{
        InfoViewController *objInfoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController-iPad" bundle:nil];
        UINavigationController *mNavigationController = [[UINavigationController alloc] initWithRootViewController:objInfoViewController];
        [self presentModalViewController:mNavigationController animated:YES];
    }
}

-(IBAction)sendFeedBackButtonPressed
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"Feedback! - iTaaleem Lehra iOS"];
            
            // Set up recipients
            NSArray *toRecipients = [NSArray arrayWithObject:@"ipooja@mediaagility.com"];
            [picker setToRecipients:toRecipients];
            
            // Fill out the email body text
            NSString *emailBody = @"";
            [picker setMessageBody:emailBody isHTML:YES];
            
            [self presentModalViewController:picker animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"Please Login to Your Mail !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
        {
			NSLog(@"mail sending cancaled");
        }
			break;
		case MFMailComposeResultSaved:
        {
            NSLog(@"mail results saved");

        }
            break;
		case MFMailComposeResultSent:
        {
            NSLog(@"mail sent sucessfully");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Mail sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
          break;
		case MFMailComposeResultFailed:
        {
            NSLog(@"mail results failed");

        }
            break;
		default:

			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)facebookButtonPressed
{
    //    [self  loginBtnAction];
    
    NSString *urlString = @"https://www.facebook.com/iPoojaMobileApps";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
-(IBAction)btnTwitterClicked
{
    NSString *urlString = @"https://twitter.com/iPooja";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}

#pragma mark firstTime info view methods


-(IBAction)firstTimeInfoButtonTapped
{
	[self.firstTimeInfoView removeFromSuperview];
}

-(IBAction)infoViewEnableButtonTapped
{
	if (infoViewYESorNo == 0)
	{
		[self.infoViewEnableButton setImage :[UIImage imageNamed:@"checkbox_border.png"] forState:UIControlStateNormal];
		appdel.updateInfoViewNumber = 2;
		NSString *UpdateInfoViewNumberString = [NSString stringWithFormat:@"%d",appdel.updateInfoViewNumber];
		[self.userDefaultObj setObject:UpdateInfoViewNumberString forKey:@"updateinfoviewnumber"];
		NSLog(@"value : %@",UpdateInfoViewNumberString);
		infoViewYESorNo = 1;
		
	}
	else if (infoViewYESorNo == 1)
	{
		
		[self.infoViewEnableButton setImage:[UIImage imageNamed:@"borders.png"] forState:UIControlStateNormal];
		appdel.updateInfoViewNumber = 1;
		NSString *UpdateInfoViewNumberString = [NSString stringWithFormat:@"%d",appdel.updateInfoViewNumber];
		[self.userDefaultObj setObject:UpdateInfoViewNumberString forKey:@"updateinfoviewnumber"];
		NSLog(@"value : %@",UpdateInfoViewNumberString);
		infoViewYESorNo = 0;
		
	}
}


-(IBAction)btnHelpScreenOkClicked
{
    
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
        }
        else
        {
            [self changeViewForLandscapeMode];
        }
    }
	[self.viewFirstTimeHelpView removeFromSuperview];
    //[self.view addSubview:firstTimeInfoView];
}


-(IBAction)btnDontShowAgainHelpScreenClicked
{
	if (boolHelpScreen == 0)
	{
		[self.btnDontShowAgainHelpScreen setImage :[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
		appdel.updateHelpScreenNumber = 2;
		NSString *strUpdateHelpScreenNumber = [NSString stringWithFormat:@"%d",appdel.updateHelpScreenNumber];
		[self.userDefaultObj setObject:strUpdateHelpScreenNumber forKey:@"updatehelpscreennumber"];
		NSLog(@"value : %@",strUpdateHelpScreenNumber);
		boolHelpScreen = 1;
	}
	else if (boolHelpScreen == 1)
	{
		
		[self.btnDontShowAgainHelpScreen setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
		appdel.updateHelpScreenNumber = 1;
		NSString *strUpdateHelpScreenNumber = [NSString stringWithFormat:@"%d",appdel.updateHelpScreenNumber];
		[self.userDefaultObj setObject:strUpdateHelpScreenNumber forKey:@"updatehelpscreennumber"];
		NSLog(@"value : %@",strUpdateHelpScreenNumber);
		boolHelpScreen = 0;
		
	}
}

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:mTableView];
    NSIndexPath *swipedIndexPath = [mTableView indexPathForRowAtPoint:location];
    
    //   NSLog(@"%@",swipedCell);
    NSLog(@"%d",swipedIndexPath.row);
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        iChantDetailViewController *temp=[[iChantDetailViewController alloc] initWithNibName:@"iChantDetailViewController-iPad" bundle:[NSBundle mainBundle]];
        temp.title = [chantNameArray objectAtIndex:swipedIndexPath.row];
         [temp setFbObject:fbObject];
        temp.directoryPath=[chantDirectoryArray objectAtIndex:swipedIndexPath.row];
        [self.navigationController pushViewController:temp animated:YES];
        
    }
    else{
        iChantDetailViewController *temp=[[iChantDetailViewController alloc] initWithNibName:@"iChantDetailViewController" bundle:[NSBundle mainBundle]];
        
        temp.title=[chantNameArray objectAtIndex:swipedIndexPath.row];
         [temp setFbObject:fbObject];
        temp.directoryPath=[chantDirectoryArray objectAtIndex:swipedIndexPath.row];
        [self.navigationController pushViewController:temp animated:YES];
    }
  //  [self.mTableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark Table view methods

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	viewFooter.backgroundColor = [UIColor clearColor];
	return viewFooter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	
	return [chantNameArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

    
    UITableViewCell *cell=nil;
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
          cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
	
	NSString *path=[NSBundle pathForResource:[chantIconArray objectAtIndex:indexPath.row] ofType:@"png" inDirectory:[chantDirectoryArray objectAtIndex:indexPath.row]];
	
   //
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
 cell.textLabel.text = [chantNameArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 2;
        //    }
    	cell.textLabel.text = [chantNameArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//  /  cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellEditingStyleNone;

	if(path!=nil)
		cell.imageView.image=[UIImage imageWithContentsOfFile:path];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        iChantDetailViewController *temp=[[iChantDetailViewController alloc] initWithNibName:@"iChantDetailViewController-iPad" bundle:[NSBundle mainBundle]];
        temp.title = [chantNameArray objectAtIndex:indexPath.row];;
        temp.directoryPath=[chantDirectoryArray objectAtIndex:indexPath.row];
        [temp setFbObject:fbObject];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else{
        iChantDetailViewController *temp=[[iChantDetailViewController alloc] initWithNibName:@"iChantDetailViewController" bundle:[NSBundle mainBundle]];
        
        temp.title=[chantNameArray objectAtIndex:indexPath.row];
         [temp setFbObject:fbObject];
        temp.directoryPath=[chantDirectoryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:temp animated:YES];
    }
    [self.mTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Counter" message:@"Do You Want To Delete This Package" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
        IndexPath=indexPath.row;
		//Getting all the array from user default those are going to be update
	
	} 
	
	
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([[chantNameArray objectAtIndex:indexPath.row] isEqualToString:@"Free Sampler"])
		return UITableViewCellEditingStyleNone;
	else {
		return UITableViewCellEditingStyleDelete;
	}

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
		narrations=[[[NSUserDefaults standardUserDefaults]objectForKey:kNarration] mutableCopy];
		displayLanguages=[[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages] mutableCopy];
		beadsArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kBeadsArray] mutableCopy];
		malasArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kMalaArray] mutableCopy];
		selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
		numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
		numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
		productIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
		
		
		
		
		
		
		//Cleaning the user default for the all chants within that pack
		NSFileManager *fManager=[NSFileManager defaultManager];
		NSArray *fileArray=[fManager contentsOfDirectoryAtPath:[chantDirectoryArray objectAtIndex:IndexPath] error:nil];
		NSLog(@"Sub-Directory array is:%@",fileArray);
		NSString *str;
		for (str in fileArray)
		{
			NSString *plistPath=[NSBundle pathForResource:kChantPlist ofType:@"plist" inDirectory:[[chantDirectoryArray objectAtIndex:IndexPath] stringByAppendingString:
																								   [NSString stringWithFormat:@"%@/",str]]];
			if (plistPath!=nil)
			{
				NSArray *chantDetailArray=[[NSArray alloc] initWithContentsOfFile:plistPath];
				NSString *pID=[chantDetailArray objectAtIndex:2];
				NSLog(@"Product Id is:%@",pID);
				NSInteger existingItemIndex=[productIDArray indexOfObject:pID];
				
				if (existingItemIndex!=NSNotFound) //If the item does exist and one wants to overwrite
					//Then cleaning all the user defaults for that item
				{
					
					[narrations removeObjectAtIndex:existingItemIndex];
					[displayLanguages removeObjectAtIndex:existingItemIndex];
					[beadsArray removeObjectAtIndex:existingItemIndex];
					[malasArray removeObjectAtIndex:existingItemIndex];
					[selectedAudioSettingArray removeObjectAtIndex:existingItemIndex];
					[numberOfTimesArray removeObjectAtIndex:existingItemIndex];
					[numberOfSecondArray removeObjectAtIndex:existingItemIndex];
					[productIDArray removeObjectAtIndex:existingItemIndex];
				}
				
			}
		}
		
		
		
		//Removing the pack directory and updating local arrays
		[fManager removeItemAtPath:[chantDirectoryArray objectAtIndex:IndexPath] error:nil];
		[chantNameArray removeObjectAtIndex:IndexPath];
		[chantDirectoryArray removeObjectAtIndex:IndexPath];
		
        
		//Saving the array back to userdefault
		[userDefault setObject:narrations forKey:kNarration];
		[userDefault setObject:displayLanguages forKey:kDisplayLanguages];
		[userDefault setObject:beadsArray forKey:kBeadsArray];
		[userDefault setObject:malasArray forKey:kMalaArray];
		[userDefault setObject:selectedAudioSettingArray forKey:kSelectedAudioSetting];
		[userDefault setObject:numberOfTimesArray forKey:kNumberOfTimesArray];
		[userDefault setObject:numberOfSecondArray forKey:kNumberOfSecondsArray];
		[userDefault setObject:productIDArray forKey:kChantProductID];
		[mTableView reloadData];
        
      
	}
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma web delegate methods
-(void)webViewDidStartLoad:(UIWebView *) portal 
{
	[activityIndicator startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *) portal
{
	[activityIndicator stopAnimating];
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


- (void)adViewDidLoadAd:(MPAdView *)view
{
}
-(void)adViewDidFailToLoadAd:(MPAdView *)view
{
    
    self.adView.hidden = YES;
    self.adView = nil;
  
    
}

#pragma mark - AUTOROTATE

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            NSLog(@"LANDSCAPE");
            
            [self changeViewForLandscapeMode];
            
        }
        else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            NSLog(@"PORTRAIT");
            
            [self changeViewForPortraitMode];
        }
    }
    else{
        
    }
}


-(void)changeViewForLandscapeMode
{
    
    bgpopimg.frame=CGRectMake(214, 60, 600, 500);
    imageView.frame=CGRectMake(438, 150, 150, 150);
    TimerLbl.frame=CGRectMake(680, 90, 200, 40);
    PopLbl.frame=CGRectMake(310, 300, 420, 150);
    goBtn.frame=CGRectMake(365, 450, 300, 50);
    

    
    
    self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, 1024, 768);
  //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Landscape.png"];
    
    self.imgViewBG.frame = CGRectMake(0, 655, 1024, 49);
    self.btnGetMore.frame = CGRectMake(self.btnGetMore.frame.origin.x, 659, self.btnGetMore.frame.size.width, self.btnGetMore.frame.size.height);
    self.btnUpdates.frame = CGRectMake(450, 659, self.btnUpdates.frame.size.width, self.btnUpdates.frame.size.height);
    self.btnActiveDownload.frame = CGRectMake(900, 659, self.btnActiveDownload.frame.size.width, self.btnActiveDownload.frame.size.height);
    
    if(self.boolCheckForAdInInfo)
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
        {
            [self.adView removeFromSuperview];
            self.adView.hidden = YES;
            self.adView.delegate = nil;
            
            self.imgViewBG.frame = CGRectMake(0, 655, 1024, 49);
            self.btnGetMore.frame = CGRectMake(self.btnGetMore.frame.origin.x, 659, self.btnGetMore.frame.size.width, self.btnGetMore.frame.size.height);
            self.btnUpdates.frame = CGRectMake(450, 659, self.btnUpdates.frame.size.width, self.btnUpdates.frame.size.height);
            self.btnActiveDownload.frame = CGRectMake(900, 659, self.btnActiveDownload.frame.size.width, self.btnActiveDownload.frame.size.height);
            
        }
        else{
            if (appdel.updateHelpScreenNumber < 2)
            {
                
            }
            else{
                self.adView.hidden=YES;
                self.adView = nil;
                self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad
                                                            size:MOPUB_LEADERBOARD_SIZE];
                self.adView.delegate = self;
                self.adView.frame = CGRectMake(0, 588,1024, 90);
                //self.adView.backgroundColor = [UIColor blackColor];
                [self.view addSubview:self.adView];
                [self.adView loadAd];
            }
            
            
            
            self.imgViewBG.frame = CGRectMake(0, 570, 1024, 49);
            self.btnGetMore.frame = CGRectMake(self.btnGetMore.frame.origin.x, 575, self.btnGetMore.frame.size.width, self.btnGetMore.frame.size.height);
            self.btnUpdates.frame = CGRectMake(450, 575, self.btnUpdates.frame.size.width, self.btnUpdates.frame.size.height);
            self.btnActiveDownload.frame = CGRectMake(900, 575, self.btnActiveDownload.frame.size.width, self.btnActiveDownload.frame.size.height);

        }
        
    }
    
    self.viewFirstTimeHelpView.frame = CGRectMake(0, 0, 1024, 768);
    self.imgViewHelpScreen.frame = CGRectMake(0, 0, 1024, 768);
    self.btnDontShowAgainHelpScreen.frame = CGRectMake(380, 500, 50, 50);
    self.lblDontShowAgain.frame = CGRectMake(430, 510, 170, 27);
    self.btnHelpScreenOk.frame = CGRectMake(450, 550, 78, 35);
    
    self.instructionsView.frame = CGRectMake(self.instructionsView.frame.origin.x, self.instructionsView.frame.origin.y, 1024, 800);
    self.imgViewMALogo.frame = CGRectMake(self.imgViewMALogo.frame.origin.x, self.imgViewMALogo.frame.origin.y, 60, 60);
    self.imgViewAppLogo.frame = CGRectMake(900, self.imgViewAppLogo.frame.origin.y, self.imgViewAppLogo.frame.size.width, self.imgViewAppLogo.frame.size.height);
    self.firstInfoTextView.frame = CGRectMake(self.firstInfoTextView.frame.origin.x, self.firstInfoTextView.frame.origin.y, 950, 700);
    self.btnFacebook.frame = CGRectMake(self.btnFacebook.frame.origin.x, 610, self.btnFacebook.frame.size.width, self.btnFacebook.frame.size.height);
    self.btnTwitter.frame = CGRectMake(360, 600, self.btnTwitter.frame.size.width, self.btnTwitter.frame.size.height);
    self.btnFeedback.frame = CGRectMake(650, 600, self.btnFeedback.frame.size.width, self.btnFeedback.frame.size.height);
    self.btnFaq.frame = CGRectMake(910, 600, self.btnFaq.frame.size.width, self.btnFaq.frame.size.height);
    self.lblCopyright.frame = CGRectMake(460,660 , self.lblCopyright.frame.size.width, self.lblCopyright.frame.size.height);
    self.txtViewInfo.frame = CGRectMake(self.txtViewInfo.frame.origin.x, 119, 900, 470);

    
}

-(void)changeViewForPortraitMode
{
  
   
        bgpopimg.frame=CGRectMake(84, 162, 600, 600);
        imageView.frame=CGRectMake(308, 250, 150, 150);
        TimerLbl.frame=CGRectMake(520, 190, 200, 40);
        PopLbl.frame=CGRectMake(180, 450, 420, 150);
        goBtn.frame=CGRectMake(235, 650, 300, 50);
        
    
    
    
    
    
    self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, 768 , 1004);
  //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Portrait.png"];
    
    self.viewFirstTimeHelpView.frame = CGRectMake(0, 0, 768, 1004);
    self.imgViewHelpScreen.frame = CGRectMake(0, 0, 768, 1004);
    self.btnDontShowAgainHelpScreen.frame = CGRectMake(262, 713, 50, 50);
    self.lblDontShowAgain.frame = CGRectMake(320, 724, 170, 27);
    self.btnHelpScreenOk.frame = CGRectMake(333, 759, 78, 35);
    
    if(self.boolCheckForAdInInfo)
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
        {
            [self.adView removeFromSuperview];
            self.adView.hidden = YES;
            self.adView.delegate = nil;
            
            self.imgViewBG.frame = CGRectMake(self.imgViewBG.frame.origin.x, 950, self.imgViewBG.frame.size.width, self.imgViewBG.frame.size.height);
            self.btnGetMore.frame = CGRectMake(self.btnGetMore.frame.origin.x, 917, self.btnGetMore.frame.size.width, self.btnGetMore.frame.size.height);
            self.btnUpdates.frame = CGRectMake(337, 917, self.btnUpdates.frame.size.width, self.btnUpdates.frame.size.height);
            self.btnActiveDownload.frame = CGRectMake(663, 917, self.btnActiveDownload.frame.size.width, self.btnActiveDownload.frame.size.height);
        }
        else
        {
            if (appdel.updateHelpScreenNumber < 2)
            {
                
            }
            else{
                self.adView.hidden = YES;
                self.adView = nil;
                self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad                                                     size:MOPUB_LEADERBOARD_SIZE];
                self.adView.delegate = self;
                self.adView.frame = CGRectMake(0, 870,768, 90);
                //self.adView.backgroundColor = [UIColor blackColor];
                [self.view addSubview:self.adView];
                [self.adView loadAd];
            }
            
            
            self.imgViewBG.frame = CGRectMake(self.imgViewBG.frame.origin.x, 950, self.imgViewBG.frame.size.width, self.imgViewBG.frame.size.height);
            self.btnGetMore.frame = CGRectMake(self.btnGetMore.frame.origin.x, 827, self.btnGetMore.frame.size.width, self.btnGetMore.frame.size.height);
            self.btnUpdates.frame = CGRectMake(337, 827, self.btnUpdates.frame.size.width, self.btnUpdates.frame.size.height);
            self.btnActiveDownload.frame = CGRectMake(663, 827, self.btnActiveDownload.frame.size.width, self.btnActiveDownload.frame.size.height);

        }
        
    }
    
    self.instructionsView.frame = CGRectMake(self.instructionsView.frame.origin.x, self.instructionsView.frame.origin.y, 768, 1004);
    self.imgViewMALogo.frame = CGRectMake(self.imgViewMALogo.frame.origin.x, self.imgViewMALogo.frame.origin.y, 60, 60);
    self.imgViewAppLogo.frame = CGRectMake(654 ,self.imgViewAppLogo.frame.origin.y, self.imgViewAppLogo.frame.size.width, self.imgViewAppLogo.frame.size.height);
    self.firstInfoTextView.frame = CGRectMake(self.firstInfoTextView.frame.origin.x, self.firstInfoTextView.frame.origin.y, 718 , 741);
    self.btnFacebook.frame = CGRectMake(self.btnFacebook.frame.origin.x, 822, self.btnFacebook.frame.size.width, self.btnFacebook.frame.size.height);
    self.btnTwitter.frame = CGRectMake(257, 822, self.btnTwitter.frame.size.width, self.btnTwitter.frame.size.height);
    self.btnFeedback.frame = CGRectMake(467, 822, self.btnFeedback.frame.size.width, self.btnFeedback.frame.size.height);
    self.btnFaq.frame = CGRectMake(647, 822, self.btnFaq.frame.size.width, self.btnFaq.frame.size.height);
    
    self.lblCopyright.frame = CGRectMake(326,890 , self.lblCopyright.frame.size.width, self.lblCopyright.frame.size.height);
    self.txtViewInfo.frame = CGRectMake(self.txtViewInfo.frame.origin.x, 119, 718, 659);
}

@end
