//
//  self.ActiveDownLoadController.m
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActiveDownLoadController.h"
#import "Constants_InApp.h"
//#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalValues_InApp.h"
//#import "GlobalValues_iLP.h"
#import "AlertConstants.h"


@implementation ActiveDownLoadController
@synthesize doneButton = _doneButton;
@synthesize activeDownLoadTable = activeDownLoadTable;
@synthesize ActiveDownLoadArray = _ActiveDownLoadArray;
@synthesize userDefaultsObj = _userDefaultsObj;
@synthesize tblcell = _tblcell;
@synthesize tableCellArray = _tableCellArray;
@synthesize downloadTimer = _downloadTimer;
@synthesize appDelagete= _appDelagete;
@synthesize timerArray = _timerArray;
@synthesize infoTextView = _infoTextView;
@synthesize activityIndicator = _activityIndicator;
@synthesize activeDownloadUserDefaltArray = _activeDownloadUserDefaltArray;
@synthesize imageViewBG = _imageViewBG;
@synthesize clearDownloadsAlert = _clearDownloadsAlert;
@synthesize clearButton = _clearButton;
@synthesize btnForRemovingPulse = _btnForRemovingPulse;
@synthesize btnPulse = _btnPulse;
@synthesize boolShowClearButton = _boolShowClearButton;
@synthesize productRequest = _productRequest;
@synthesize imgViewBackground = _imgViewBackground;
@synthesize txtViewDownload = _txtViewDownload;
@synthesize DoneBtnVisible;
GlobalValues_InApp *globalValues_InApp;
bool showPulse = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Downloads", @"Downloads");
       // self.tabBarItem.image = [UIImage imageNamed:@"downloadTab.png"];
        self.tabBarItem.title=@"Downloads";
        [  self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                                   [UIFont fontWithName:@"Helvetica" size:12.0], UITextAttributeFont, nil]
                                         forState:UIControlStateNormal];
    
        
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"downloadstab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"downloadstab.png"]];
    }
    return self;
}
#pragma mark -
#pragma mark TABLE DATASOURCE AND DELEGATE HANDLERS

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Came into noOfrows in Section");
    NSLog(@"ACTIVE ARR COUNT %d",[self.ActiveDownLoadArray count]);
    return [self.ActiveDownLoadArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSInteger row = [indexPath row];
	static NSString *activeDownloadCellIdentifier = @"activeDownloadCellIdentifier";
	
	
	self.tblcell = (ActiveDownLoadDataCell *)[tableView dequeueReusableCellWithIdentifier: activeDownloadCellIdentifier];
    
	if (self.tblcell == nil)
	{
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActiveDownLoadDataCell-iPad" owner:self options:nil];
            
            for (id oneObject in nib){
                
                
                if ([oneObject isKindOfClass:[ActiveDownLoadDataCell class]])
                    self.tblcell = (ActiveDownLoadDataCell *)oneObject;
                
                self.tblcell.backgroundColor = [UIColor clearColor];
                self.tblcell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        else
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActiveDownLoadDataCell" owner:self options:nil];
            
            for (id oneObject in nib){
                
                
                if ([oneObject isKindOfClass:[ActiveDownLoadDataCell class]])
                    self.tblcell = (ActiveDownLoadDataCell *)oneObject;
                
                self.tblcell.backgroundColor = [UIColor clearColor];
                self.tblcell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
	}
    
	// Configure the cell
    
    self.tblcell.objActiveDownload = [self.ActiveDownLoadArray objectAtIndex:row];
    
    [self.tblcell setCellData:row];
    [self.tableCellArray addObject:self.tblcell];
    
	return self.tblcell ;
}


#pragma mark -
#pragma mark VIEW LIFE CYCLE

-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"Active Download";
        
        //use whatever image you want and add it to your project
        //self.tabBarItem.image = [UIImage imageNamed:@"name_gray.png"];
        
        // set the long name shown in the navigation bar at the top
        self.navigationItem.title = @"Active Download";
    }
    return self;
    
}
-(void)clearUnfinishedDownloads{
    self.clearDownloadsAlert =[[UIAlertView alloc]initWithTitle:kAlertViewTitleAlert message:kAlertViewMessageForCancelActiveDownload delegate:self cancelButtonTitle:kAlertViewButtonYes otherButtonTitles:kAlertViewButtonNo, nil];
    [self.clearDownloadsAlert show];
}

- (void)viewDidLoad
{
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    
    globalValues_InApp = [GlobalValues_InApp sharedManager];
    
    self.productRequest = [MAProductRequest sharedInstance];
    
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.title = @"Downloads";
	//self.appDelagete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tableCellArray = [[NSMutableArray alloc] init];
	self.tblcell = [[ActiveDownLoadDataCell alloc] init];
	self.timerArray = [[NSMutableArray alloc]init];
    self.userDefaultsObj = [NSUserDefaults standardUserDefaults];
    
    self.imageViewBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG-LD-0106.png"]];
    
    
	self.infoTextView.layer.borderWidth = 0.3;
	self.infoTextView.layer.cornerRadius = 7;
    
    
    NSLog(@"ACTIVE DOWNLOAD %d",globalValues_InApp.activeDownLoadClicked);
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
//        {
//            [self changeViewForPortraitMode];
//        }
//        else
//        {
//            [self changeViewForLandscapeMode];
//        }
//        
//        
//        if(globalValues_InApp.activeDownLoadClicked == YES)
//        {
//            self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(langSettingButtonPressed:)];
//            self.doneButton.tintColor = [UIColor whiteColor];
//            self.navigationItem.rightBarButtonItem = self.doneButton;
//            
//            self.clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearUnfinishedDownloads)];
//            self.clearButton.tintColor = [UIColor whiteColor];
//            self.navigationItem.leftBarButtonItem = nil;
//            
//        }
//        else
//        {
//            //self.navigationItem.rightBarButtonItem = nil;
//            
//            self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(langSettingButtonPressed:)];
//            self.doneButton.tintColor = [UIColor whiteColor];
//            self.navigationItem.rightBarButtonItem = self.doneButton;
//            
//            self.clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearUnfinishedDownloads)];
//            self.clearButton.tintColor = [UIColor whiteColor];
//            self.navigationItem.leftBarButtonItem = nil;
//            
//        }
//    }
//    else
//    {
        self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(langSettingButtonPressed:)];
        self.doneButton.tintColor = [UIColor whiteColor];
    
        
        self.clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearUnfinishedDownloads)];
        self.navigationItem.leftBarButtonItem = nil;
    
    
    if ([DoneBtnVisible isEqualToString:@"yes"]) {
        self.navigationItem.rightBarButtonItem = self.doneButton;
        self.clearButton.tintColor = [UIColor whiteColor];
    }
    
//    }
    
	
	
	
	NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	self.ActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:array];
	//self.segmentedControl.hidden = YES;
	[self.activeDownLoadTable reloadData];
	
	
	
	
	self.activeDownLoadTable.backgroundColor = [UIColor clearColor];
	self.infoTextView.backgroundColor = [UIColor clearColor];
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDownloadpProgress) userInfo:nil repeats:YES];
    self.boolShowClearButton = YES;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
      //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
    }
    if(result.height == 568)
    {
        self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, self.imgViewBackground.frame.size.width, 568);
        
     //   self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
    }
}

-(void)updateDownloadpProgress
{
	
	if (globalValues_InApp.activeDownLoadBool == 1 && [self.ActiveDownLoadArray count]<1)
	{
		[self.activityIndicator startAnimating];
        //[self dismissModalViewControllerAnimated:YES];
	}else
	{
		[self.activityIndicator stopAnimating];
	}
	NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
    self.activeDownloadUserDefaltArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	self.ActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:self.activeDownloadUserDefaltArray];
    if ([self.ActiveDownLoadArray count]!=0) {
        if (self.boolShowClearButton) {
            self.boolShowClearButton = NO;
            self.navigationItem.leftBarButtonItem = self.clearButton;
      self.clearButton.tintColor = [UIColor whiteColor];
        }
    }
    else{
            self.navigationItem.leftBarButtonItem = nil;
    }
    [self.activeDownLoadTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.downloadTimer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
        //return YES;
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.doneButton = nil;
    self.activeDownLoadTable = nil;
    self.ActiveDownLoadArray = nil;
    self.tableCellArray = nil;
    self.timerArray = nil;
    self.userDefaultsObj = nil;
    self.tblcell = nil;
    self.downloadTimer = nil;
    self.activityIndicator = nil;
    self.infoTextView = nil;
    self.appDelagete = nil;
    self.activeDownloadUserDefaltArray = nil;
    
}



-(IBAction)langSettingButtonPressed:(id)sender
{
    NSLog(@"DONE CLICKED IN ACTIVE DOWNLOAD");
    [self dismissModalViewControllerAnimated:YES];
    
    globalValues_InApp.activeDownLoadClicked = NO;
}

#pragma mark - UIALERTVIEW DELEGATE METHODS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.clearDownloadsAlert)
    {
        if (buttonIndex==0) {
            NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
            self.activeDownloadUserDefaltArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            self.ActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:self.activeDownloadUserDefaltArray];
            if ([self.ActiveDownLoadArray count]!=0)
            {
                [self.productRequest clearUnfinishedDownloads];
                
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
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
    self.view.frame = CGRectMake(0, 0, 1024, 768);
    self.imageViewBG.frame = CGRectMake(0, 0, 1024, 768);
    
    NSString *img= @"Bg_Landscape";
    UIImage *image = [UIImage imageNamed:img];
    self.imageViewBG.image=image;
    
    self.txtViewDownload.frame = CGRectMake(60, 5, 800, 61);
}

-(void)changeViewForPortraitMode
{
    self.view.frame = CGRectMake(0, 0, 768, 1004);
    self.imageViewBG.frame = CGRectMake(0, 0, 768, 1004);
    
    NSString *img= @"Bg_Portrait";
    UIImage *image = [UIImage imageNamed:img];
    self.imageViewBG.image=image;
    
    self.txtViewDownload.frame = CGRectMake(10, 5, 749, 61);
}

@end
