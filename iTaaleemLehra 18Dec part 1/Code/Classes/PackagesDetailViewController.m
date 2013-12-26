//
//  PackagesDetailViewController.m
//  iCityPediaUniversal
//
//  Created by User on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PackagesDetailViewController.h"
#import "WebRequest.h"
#import "Reachability.h"
#import "NSData+Base64.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ActiveDownLoadController.h"
#import "ImageWebRequest.h"
#import "AlertConstants.h"
#import "Constants_InApp.h"

@interface PackagesDetailViewController ()

@end

@implementation PackagesDetailViewController
@synthesize objProductReq = _objProductReq;
@synthesize product = _product;
@synthesize btnBuy = _btnBuy;
@synthesize imageViewBG = _imageViewBG;
@synthesize imageViewPackageIcon = _imageViewPackageIcon;
@synthesize lblNameText = _lblNameText;
@synthesize lblPrice = _lblPrice;
@synthesize txtViewDescription = _txtViewDescription;
@synthesize marrDataPackageList = _marrDataPackageList;
@synthesize spinner = _spinner;
@synthesize lblPriceText = _lblPriceText;
@synthesize lblDescription = _lblDescription;
@synthesize btnRestorePurchase = _btnRestorePurchase;
@synthesize btnClearUnfinished = _btnClearUnfinished;
@synthesize viewWait = _viewWait;
@synthesize barButtonItemBack=_barButtonItemBack;
@synthesize barButtonItemHomeScreen=_barButtonItemHomeScreen;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize alertBuyPackage =_alertBuyPackage;
@synthesize alertRestorePackage = _alertRestorePackage;
@synthesize alertClearUnfinished = _alertClearUnfinished;
@synthesize boolButtonBuyClicked = _boolButtonBuyClicked;
@synthesize alertNetNotAvailable = _alertNetNotAvailable;
@synthesize item = _item;

@synthesize borderLabelforPrice = _borderLabelforPrice;
@synthesize borderLabelforDescription = _borderLabelforDescription;
@synthesize lblRemoveAdvertisments = _lblRemoveAdvertisments;
@synthesize lblWait = _lblWait;
@synthesize imgViewBackground = _imgViewBackground;

NSString *strSelectedBundleIdToPurchase;
NSString *strSelectedBundleIdToPurchaseInitializingObjInapps;

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Get More", @"Get More");
        self.tabBarItem.image = [UIImage imageNamed:@"home.png"];
        self.tabBarItem.title=@"Get More";
        
        
        
    }
    return self;
}

-(IBAction) barButtonBackClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(IBAction) barButtonHomeScreenClicked{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    
       self.btnBuy.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:135.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
    
//self.btnRestorePurchase.backgroundColor=[UIColor colorWithRed:187.0f/255.0f green:75.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
    
      self.btnRestorePurchase.backgroundColor=[UIColor colorWithRed:214.0f/255.0f green:97.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
    
    self.title= @"Package Detail";
    
    self.lblWait.text = @"Loading Package";
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
     //   [self.btnBuy setImage:[UIImage imageNamed:@"bttn_buy.png"] forState:UIControlStateNormal];
    //    [self.btnRestorePurchase setImage:[UIImage imageNamed:@"bttn_restore.png"] forState:UIControlStateNormal];
        
        self.lblRemoveAdvertisments.frame = CGRectMake(self.lblRemoveAdvertisments.frame.origin.x, 380, self.lblRemoveAdvertisments.frame.size.width, self.lblRemoveAdvertisments.frame.size.height);
        
    //    self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
        
    }
    if(result.height == 568)
    {
        self.viewWait.frame = CGRectMake(self.viewWait.frame.origin.x, self.viewWait.frame.origin.y, self.viewWait.frame.size.width, 568);
        
    //    self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
        
        self.btnBuy.frame = CGRectMake(self.btnBuy.frame.origin.x, 370, 100, 39);
        self.btnRestorePurchase.frame = CGRectMake(self.btnRestorePurchase.frame.origin.x, 370, 100, 39);
        
        self.borderLabelforDescription.frame = CGRectMake(self.borderLabelforDescription.frame.origin.x, 110, self.borderLabelforDescription.frame.size.width, self.borderLabelforDescription.frame.size.height);

     //   [self.btnBuy setImage:[UIImage imageNamed:@"bttn_buy_iPod.png"] forState:UIControlStateNormal];
     //   [self.btnRestorePurchase setImage:[UIImage imageNamed:@"bttn_restore_iPod.png"] forState:UIControlStateNormal];
    
        self.lblRemoveAdvertisments.frame = CGRectMake(self.lblRemoveAdvertisments.frame.origin.x, 450, self.lblRemoveAdvertisments.frame.size.width, self.lblRemoveAdvertisments.frame.size.height);
        
        self.lblDescription.frame = CGRectMake(self.lblDescription.frame.origin.x, 120, self.lblDescription.frame.size.width, self.lblDescription.frame.size.height);
        
        self.txtViewDescription.frame = CGRectMake(self.txtViewDescription.frame.origin.x, 155, self.txtViewDescription.frame.size.width, self.txtViewDescription.frame.size.height);


    }
    
    self.navigationController.navigationBar.barStyle =  UIBarStyleBlackOpaque;
    
    self.borderLabelforPrice.layer.borderWidth = 1;
	self.borderLabelforPrice.layer.cornerRadius = 8;
	self.borderLabelforDescription.layer.borderWidth = 1;
	self.borderLabelforDescription.layer.cornerRadius = 8;
    
    
    // FOR BACK
    self.barButtonItemBack=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(barButtonBackClicked)];
    
    UIView *viewBtn3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnBack setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(barButtonBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBtn3 addSubview:btnBack];
    
    self.barButtonItemBack.customView = viewBtn3;
    
    /*self.barButtonItemHomeScreen=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HomeScreen", @"homeScreen") style:UIBarButtonItemStylePlain target:self action:@selector(barButtonHomeScreenClicked)];
    
    UIView *viewBtn4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIButton *btnHomeScreen = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnHomeScreen setImage:[UIImage imageNamed:@"LD-Logo30.png"] forState:UIControlStateNormal];
    [btnHomeScreen addTarget:self action:@selector(barButtonHomeScreenClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBtn4 addSubview:btnHomeScreen];
    
    self.barButtonItemHomeScreen.customView = viewBtn4;*/
    // Do any additional setup after loading the view from its nib.
    
    
    //NSArray *arr1 = [[NSArray alloc]initWithObjects:self.barButtonItemBack,self.barButtonItemHomeScreen, nil];
//    self.navigationItem.leftBarButtonItems=arr1;
    
    //self.imageViewBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG-LD-0106.png"]];
    
    self.lblNameText.hidden = YES;
    self.lblPrice.hidden = YES;
    self.lblPriceText.hidden = YES;
    self.lblDescription.hidden = YES;
    self.txtViewDescription.hidden = YES;
    self.btnBuy.hidden = YES;
    self.btnRestorePurchase.hidden = YES;
    
    
    self.objProductReq = [MAProductRequest sharedInstance];
    self.objProductReq.delegate = self;
    
    /*if (self.objInApps == nil){
        self.objInApps = [[InAppsRequestClass alloc]init];
        self.objInApps.delegate = self;
        
        // LIBRARY PATH
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //  LISTING ALL FOLDERS IN LIBRARY/iLP_UserData DIRECTORY
        NSString *iLP_Path = [NSString stringWithFormat:@"%@/Caches/", libraryPath];
        [self.objInApps setPackageUnzipPath:iLP_Path createPathYesOrNo:NO];*/
    
        //[self.objProductReq setPackageUnzipPath:iLP_Path createPathYesOrNo:NO];
    
        strSelectedBundleIdToPurchaseInitializingObjInapps  = [[NSString alloc]initWithString:self.item.strProductId];
   // }
    
    
//    NSLog(@"STR TYPE %@",self.objPackageList.strType);
//    NSLog(@"STR BUNDLE ID %@",self.objPackageList.strProductId);
//    NSLog(@"IMAGE %@",self.objPackageList.strIconimage);
    
    if ([self.item.strType isEqual:@"f"])
	{
        self.lblNameText.hidden = NO;
        self.lblPrice.hidden = NO;
        self.lblPriceText.hidden = NO;
        self.lblDescription.hidden = NO;
        self.txtViewDescription.hidden = NO;
        self.btnBuy.hidden = NO;
        
        //self.btnBuy.frame = CGRectMake(100, 340, 100, 30);
        self.btnRestorePurchase.frame = CGRectMake(150, 340, 100, 30);
        
    //    [self.btnBuy setImage:[UIImage imageNamed:@"bttn_getfree.png"] forState:UIControlStateNormal];
        [self.btnBuy setTitle:@"Free" forState:UIControlStateNormal];
        
        self.lblNameText.text = [NSString stringWithFormat:@"%@", self.item.strName];
        self.lblPriceText.text = @"FREE";
        self.txtViewDescription.text = [NSString stringWithFormat:@"%@", self.item.description];
    }
    else if([self.item.strType isEqualToString:kProductTypePaid])
    {
        //self.btnBuy.frame = CGRectMake(35, 340, 100, 30);
        //self.btnRestorePurchase.frame = CGRectMake(170, 340, 100, 30);
        self.btnBuy.hidden = YES;
        //[self.btnBuy setImage:[UIImage imageNamed:@"bttn_buy.png"] forState:UIControlStateNormal];
        
        Reachability *hostReach = [Reachability reachabilityForInternetConnection];
        if ([hostReach currentReachabilityStatus] != NotReachable){
            //[self.objInApps getProductDetailsFromAppStore:[NSString stringWithFormat:@"%@", self.item.strProductId] itemTypePaidOrFree:@"p"];
            [self.objProductReq fetchProductDetailsFromAppStore:[NSString stringWithFormat:@"%@", self.item.strProductId] andType:kProductTypePaid];
            [self.navigationController.navigationBar addSubview:self.viewWait];
        }
        else{
            self.alertNetNotAvailable = [[UIAlertView alloc] initWithTitle:kAlertViewTitleNoNetworkAvailable message:kAlertViewMessageForNoNetwork delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
            [self.alertNetNotAvailable show];

        }
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIBarButtonItem *activeDownloads = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_activedownload"] style:UIBarButtonItemStyleBordered target:self action:@selector(activeDownloadsClicked)];
    self.navigationItem.rightBarButtonItem = activeDownloads;
    
    // RESTORE LOGIC
    /*strSelectedBundleIdToPurchase = [[NSString alloc]initWithString:self.item.strProductId];
    //[self checkItemPurchased];*/
    [self.activityIndicatorView startAnimating];
    [self displayProductImage];
    
    
    //    self.btnBuy.hidden = YES;
}
/*-(void) removeWaitView{
    [self.viewWait removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RemoveWaitView" object:nil];
}
-(void)checkItemPurchased
{
    if ([self.objInApps.marrPurchasedItemArray count] > 0){
        bool boolItemFound = NO;
        for(int i = 0;i<[self.objInApps.marrPurchasedItemArray count];i++)
        {
            if (![strSelectedBundleIdToPurchase caseInsensitiveCompare:[self.objInApps.marrPurchasedItemArray objectAtIndex:i]]){
                boolItemFound = YES;
                break;
            }
        }
        
        if (boolItemFound){
            self.btnRestorePurchase.hidden = NO;
            self.btnBuy.hidden = YES;
        }
        
        else {
            self.btnRestorePurchase.hidden = YES;
            self.btnBuy.hidden = NO;
        }
    }
    else {
        if (![strSelectedBundleIdToPurchaseInitializingObjInapps caseInsensitiveCompare:strSelectedBundleIdToPurchase]){
            self.btnRestorePurchase.hidden = YES;
            self.btnBuy.hidden = NO;
        }
        else {
            self.btnRestorePurchase.hidden = YES;
            self.btnBuy.hidden = NO;
        }
    }
}*/



-(void)displayProductImage
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(callNextStep:) name:self.item.strIconimage object:nil];
    ImageWebRequest *imgReq = [[ImageWebRequest alloc]init];
    [imgReq webRequestURL:self.item.strIconimage];
}

#pragma mark - INAPPS DELEGATE HAMDLERS

-(void)productDetailsFromAppStore:(SKProduct *)product
{
    self.lblNameText.hidden = NO;
    self.lblPrice.hidden = NO;
    self.lblPriceText.hidden = NO;
    self.lblDescription.hidden = NO;
    self.txtViewDescription.hidden = NO;
    self.btnRestorePurchase.hidden = NO;
    self.btnBuy.hidden = NO;
    
    NSLog(@"PRODUCT NAME APP STORE %@",[product localizedDescription]);
    self.lblNameText.text = [product localizedTitle];
    self.txtViewDescription.text = [product localizedDescription];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    
    self.lblPriceText.text =  formattedString;
    
    [self.viewWait removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}

-(void)productDetailsFromAppStoreRetrieved:(NSDictionary *)productDetails
{
    self.lblNameText.hidden = NO;
    self.lblPrice.hidden = NO;
    self.lblPriceText.hidden = NO;
    self.lblDescription.hidden = NO;
    self.txtViewDescription.hidden = NO;
    self.btnRestorePurchase.hidden = NO;
    self.btnBuy.hidden = NO;
    
    self.lblNameText.text = [productDetails objectForKey:kProductNameKey];
    self.txtViewDescription.text = [productDetails objectForKey:kProductDescriptionKey];
    self.lblPriceText.text =  [productDetails objectForKey:kProductPriceKey];
    [self.viewWait removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}


- (void)viewDidUnload
{
    [self setImageViewPackageIcon:nil];
    [self setLblNameText:nil];
    [self setLblPriceText:nil];
    [self setTxtViewDescription:nil];
    [self setBtnBuy:nil];
    [self setImageViewBG:nil];
    [self setBtnClearUnfinished:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)presentActiveDownloadPageForiPhone{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PresentActiveDownloadPage" object:nil];
    ActiveDownLoadController *objActiveDownloadController = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];
    objActiveDownloadController.DoneBtnVisible=@"yes";
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:objActiveDownloadController];
    
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark -  BUTTON EVENT HANDLERS

/*- (IBAction)btnBuyButtonClicked:(id)sender
{
    self.boolButtonBuyClicked = YES;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PresentActiveDownloadPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentActiveDownloadPageForiPhone) name:@"PresentActiveDownloadPage" object:nil];
    
    // CHECK FOR ONE DOWNLOAD ONLY
    NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:@"kuserDefKeyForActiveDownLoad"] mutableCopy];
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	NSMutableArray *marrActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:array];
    
    
    if ([marrActiveDownLoadArray count] > 0){
        self.alertClearUnfinished = [[UIAlertView alloc] initWithTitle:kAlertViewTitlePackageDownloadInProgress message:kAlertViewMessageForPackageDownloadInProgress delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear, nil];
        [self.alertClearUnfinished show];
    }
    
    // CHECK DONE
    
    
    else {
        
        strSelectedBundleIdToPurchaseInitializingObjInapps  = [[NSString alloc]initWithString:self.item.strProductId];
        //            [self.objInApps checkPackageAlreadyBoughtOrNot];
        
        [self buyPackage];
        
    }
}*/

- (IBAction)btnBuyButtonClicked:(id)sender
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable)
    {
        [self.view addSubview:self.viewWait];
        
        [self.activityIndicatorView startAnimating];
        
        self.objProductReq = [MAProductRequest sharedInstance];
        self.objProductReq.delegate = self;
        
        [self.objProductReq buyProductWithID:self.item.strProductId andType:self.item.strType];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.delegate = self;
		[alert show];
    }

}

/*- (IBAction)btnClearUnfinishedClicked:(id)sender {
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kuserDefKeyForActiveDownLoad"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.objInApps clearUnfinishedDownloads];
    //self.navigationItem.rightBarButtonItem = nil;
    //globalValues_iLP.navControllerActiveDownloads = nil;
    //self.objInApps = [[InAppsRequestClass alloc] init];
}*/

-(IBAction)restorePurchaseButtonClicked
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    if ([hostReach currentReachabilityStatus] != NotReachable)
    {
        [self.view addSubview:self.viewWait];
        [self.activityIndicatorView startAnimating];
        //[self hideHomeButton];
        
        self.objProductReq = [MAProductRequest sharedInstance];
        self.objProductReq.delegate = self;
        
        [self.objProductReq restoreProductWithID:self.item.strProductId];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OK" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }

}

/*-(IBAction)restorePurchaseButtonClicked
{
 
    self.boolButtonBuyClicked = NO;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PresentActiveDownloadPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentActiveDownloadPageForiPhone) name:@"PresentActiveDownloadPage" object:nil];
    // CHECK FOR ONE DOWNLOAD ONLY
    
    NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:@"kuserDefKeyForActiveDownLoad"] mutableCopy];
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	NSMutableArray *marrActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:array];
    
    
    if ([marrActiveDownLoadArray count] > 0){
        self.alertClearUnfinished = [[UIAlertView alloc] initWithTitle:kAlertViewTitlePackageDownloadInProgress message:kAlertViewMessageForPackageDownloadInProgress delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear, nil];
        [self.alertClearUnfinished show];
    }
    
    // CHECK DONE
    
    
    else {
        if ([self.item.strType isEqualToString:@"f"]) {
            self.objInApps.item.strProductId = self.item.strProductId;
            self.objInApps.item.strType = self.item.strType;
            self.objInApps.item.strName = self.item.strName;
            self.objInApps.item.strDescription = self.item.strDescription;
            self.objInApps.item.strIconimage = self.item.strIconimage;
            self.objInApps.item.strInstallStatus = self.item.strInstallStatus;
            //[self.objInApps buyPaidOrFreeProduct:@"f" productIdOrBundleId:self.item.strProductId];
            [self.objProductReq restoreProductWithID:self.item.strProductId];
        }
        else if([self.item.strType isEqualToString:kProductTypePaid]){
            strSelectedBundleIdToPurchaseInitializingObjInapps  = [[NSString alloc]initWithString:self.item.strProductId];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeWaitView) name:@"RemoveWaitView" object:nil];
            [self.navigationController.navigationBar addSubview:self.viewWait];
            //[self.objInApps checkPackageAlreadyBoughtOrNot];
            [self.objProductReq restoreProductWithID:self.item.strProductId];
            
        }
        
    }
}*/

-(void)presentActiveDownLoadControllerForiPhone:(UINavigationController *)naviPhone
{
    [self presentModalViewController:naviPhone animated:YES];
}

#pragma mark - OTHER FUNCTIONS

-(void)callNextStep:(NSNotification *)notification
{
	NSData *responseData = [[notification userInfo] objectForKey:kResponseKey];
    
	if (responseData == nil)
	{
		UIImage *defaultImage = [UIImage imageNamed:@"freee.png"];
		self.imageViewPackageIcon.image = defaultImage;
        
	}
	else
	{
		UIImage *image = [[UIImage alloc] initWithData:responseData];
		self.imageViewPackageIcon.image = image;
	}
	//[activityIndicatorForProductImage stopAnimating];
	//[self.activityIndicator stopAnimating];
	NSLog(@"In Call Next step");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:self.item.strIconimage object:nil];
}

- (void)activeDownloadsClicked
{
    ActiveDownLoadController* activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];
     activeDownLoadObj1.DoneBtnVisible=@"yes";
	[self presentModalViewController:navigationController animated:YES];
}

-(void) designUI{
    UIImage *img1 = [[UIImage imageNamed:@"Button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    
    // RESIZE btnRestorePurchase
    self.btnRestorePurchase.frame = CGRectMake(self.btnRestorePurchase.frame.origin.x, self.btnRestorePurchase.frame.origin.y, self.btnRestorePurchase.frame.size.width, 30);
    [self.btnRestorePurchase setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btnRestorePurchase setTitle:@"Restore Purchase" forState:UIControlStateNormal];
    [self.btnRestorePurchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRestorePurchase setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnRestorePurchase.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    // RESIZE btnClearUnfinished
    self.btnClearUnfinished.frame = CGRectMake(self.btnClearUnfinished.frame.origin.x, self.btnClearUnfinished.frame.origin.y, self.btnClearUnfinished.frame.size.width, 30);
    [self.btnClearUnfinished setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btnClearUnfinished setTitle:@"Clear Unfinished" forState:UIControlStateNormal];
    [self.btnClearUnfinished setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClearUnfinished setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnClearUnfinished.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
}

#pragma mark - INAPP FUNCTIONS

/*-(void)listOfItemsPurchased
{
    NSLog(@"listOfItemsPurchased function called");
    NSLog(@"%@ = %@", strSelectedBundleIdToPurchaseInitializingObjInapps, strSelectedBundleIdToPurchase);
    if (self.boolButtonBuyClicked) {
        if (![strSelectedBundleIdToPurchaseInitializingObjInapps caseInsensitiveCompare:strSelectedBundleIdToPurchase]){
            strSelectedBundleIdToPurchaseInitializingObjInapps = @"";
            if ([self.objInApps.marrPurchasedItemArray count] > 0){
                bool boolItemFound = NO;
                for(int i = 0;i<[self.objInApps.marrPurchasedItemArray count];i++)
                {
                    if (![strSelectedBundleIdToPurchase caseInsensitiveCompare:[self.objInApps.marrPurchasedItemArray objectAtIndex:i]]){
                        boolItemFound = YES;
                        break;
                    }
                }
                
                if (boolItemFound){
                    //                self.btnRestorePurchase.hidden = NO;
                    //                self.btnBuy.hidden = YES;
                    self.alertBuyPackage = [[UIAlertView alloc] initWithTitle:kAlertViewTitleAlert message:kAlertViewMessageForRestorePackage delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
                    [self.alertBuyPackage show];
                    
                }
                
                else {
                    //                self.btnRestorePurchase.hidden = YES;
                    //                self.btnBuy.hidden = NO;
                    //                self.alertBuyPackage = [[UIAlertView alloc] initWithTitle:kAlertMessage message:@"You haven't purchased this package yet!\n\nDo you want to proceed with shopping?" delegate:self cancelButtonTitle:kAlertButtonYes otherButtonTitles:kAlertButtonNo, nil];
                    //                [self.alertBuyPackage show];
                    [self buyPackage];
                }
            }
            else {
                //            self.btnRestorePurchase.hidden = YES;
                //            self.btnBuy.hidden = NO;
                //            self.alertBuyPackage = [[UIAlertView alloc] initWithTitle:kAlertMessage message:@"You haven't purchased this package yet!\n\nDo you want to proceed with shopping?" delegate:self cancelButtonTitle:kAlertButtonYes otherButtonTitles:kAlertButtonNo, nil];
                //            [self.alertBuyPackage show];
                [self buyPackage];
            }
            
        }
        
        else {
            //            [self checkItemPurchased];
        }
        
    }
    else if(!self.boolButtonBuyClicked){
        if (![strSelectedBundleIdToPurchaseInitializingObjInapps caseInsensitiveCompare:strSelectedBundleIdToPurchase]){
            strSelectedBundleIdToPurchaseInitializingObjInapps = @"";
            if ([self.objInApps.marrPurchasedItemArray count] > 0){
                bool boolItemFound = NO;
                for(int i = 0;i<[self.objInApps.marrPurchasedItemArray count];i++)
                {
                    if (![strSelectedBundleIdToPurchase caseInsensitiveCompare:[self.objInApps.marrPurchasedItemArray objectAtIndex:i]]){
                        boolItemFound = YES;
                        break;
                    }
                }
                
                if (boolItemFound){
                    //                self.btnRestorePurchase.hidden = NO;
                    //                self.btnBuy.hidden = YES;
                    [self.objInApps restorePuchase:strSelectedBundleIdToPurchase];
                    
                }
                
                else {
                    //                self.btnRestorePurchase.hidden = YES;
                    //                self.btnBuy.hidden = NO;
                    self.alertBuyPackage = [[UIAlertView alloc] initWithTitle:kAlertViewTitleAlert message:kAlertViewMessageForBuyPackage delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
                    [self.alertBuyPackage show];
                    //                    [self buyPackage];
                }
            }
            else {
                //            self.btnRestorePurchase.hidden = YES;
                //            self.btnBuy.hidden = NO;
                self.alertBuyPackage = [[UIAlertView alloc] initWithTitle:kAlertViewTitleAlert message:kAlertViewMessageForBuyPackage delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
                [self.alertBuyPackage show];
                //                [self buyPackage];
            }
            
        }
        
        else {
            //            [self checkItemPurchased];
        }
        
        
    }
    
}*/
/*-(void)buyPackage{
    self.objInApps.item.strProductId = self.item.strProductId;
    self.objInApps.item.strType = self.item.strType;
    self.objInApps.item.strName = self.item.strName;
    self.objInApps.item.strDescription = self.item.strDescription;
    self.objInApps.item.strIconimage = self.item.strIconimage;
    self.objInApps.item.strInstallStatus = self.item.strInstallStatus;
    
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable){
        if([self.item.strType isEqualToString:@"f"])
        {
            //[self.objInApps buyPaidOrFreeProduct:@"f" productIdOrBundleId:self.item.strProductId];
            [self.objProductReq buyProductWithID:self.item.strProductId andType:@"f"];
        }
        else if([self.item.strType isEqualToString:kProductTypePaid])
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeWaitView) name:@"RemoveWaitView" object:nil];
            [self.navigationController.navigationBar addSubview:self.viewWait];
            //[self.objInApps buyPaidOrFreeProduct:@"p" productIdOrBundleId:self.item.strProductId];
            [self.objProductReq buyProductWithID:self.item.strProductId andType:kProductTypePaid];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleNoNetworkAvailable message:kAlertViewMessageForNoNetwork delegate:nil cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
		[alert show];
    }
}*/
#pragma mark - ALERT VIEW DELEGATE HANDLERS

/*-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"ALERT buttonIndex = %d", buttonIndex);
    if (alertView == self.alertClearUnfinished) {
        if (buttonIndex == 1) {
            [self.objInApps clearUnfinishedDownloads];
        }
    }
    if (alertView == self.alertNetNotAvailable) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}*/

#pragma mark -  DELEGATE HANDLERS
-(void)productStatusUpdated
{
    
}

-(void)productPurchased:(NSString*)productID{
    
    self.objProductReq = [MAProductRequest sharedInstance];
    self.objProductReq.delegate = self;
//    [self.objProductReq fetchDownloadURLforProduct:productID];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"canShowPurchaseAlert"];

}
-(void)productRestored:(NSString*)productID
{
    self.objProductReq = [MAProductRequest sharedInstance];
    self.objProductReq.delegate = self;
//    [self.objProductReq fetchDownloadURLforProduct:productID];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"canShowPurchaseAlert"];
   
}
-(void)productTransactionFailed
{
    [self.viewWait removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
}

-(void)productStatusUpdated:(NSString *)message
{
    self.lblWait.text = message;
}


-(void)productTriggerDownloadfromURL:(NSString*)URL
{
    [self.viewWait removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
    [self presentActiveDownloadPageForiPhone];
}




@end
