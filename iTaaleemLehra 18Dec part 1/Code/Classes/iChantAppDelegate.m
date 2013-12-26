//
//  iChantAppDelegate.m
//  iChant
//
//  Created by iPhone Developer on 9/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iChantAppDelegate.h"
#import "iChantViewController.h"
#import "vunglepub.h"
#import "Flurry.h"
#import "Appirater.h"
#import "GetPackageListViewController.h"
#import "UpdateProduectViewController.h"
#import "ActiveDownLoadController.h"
#import "MoreViewController.h"
#import "ActiveDownLoadController.h"
#define kSampleAppId @"52563093e96bc3151b000008vvvv"

@implementation iChantAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize mNavigationController;
@synthesize playingItem;

@synthesize updateInfoViewNumber;

@synthesize activeDownLoadBool;
@synthesize productArray;
@synthesize productRequestArray;
@synthesize updatesProductArray;
@synthesize progressValueArray;
@synthesize updatedDownLoadSizeArray;
@synthesize totalSizeArray;
@synthesize remainingDownloadArray;

@synthesize narrations;
@synthesize displayLanguages;
@synthesize beadsArray;
@synthesize malasArray;
@synthesize selectedAudioSettingArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;
@synthesize productIDArray;
@synthesize updateHelpScreenNumber;
@synthesize tabBarController;

-(void)vungleStart
{
    VGUserData*  data  = [VGUserData defaultUserData];
    NSString*    appID = kSampleAppId;
    
    // set up config data
    data.age             = 23;
    data.gender          = VGGenderMale;
    data.adOrientation   = VGAdOrientationPortrait;
    data.locationEnabled = TRUE;
    [VGVunglePub allowAutoRotate:YES];
    // start vungle publisher library
    [VGVunglePub startWithPubAppID:appID userData:data];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
    
    NSLog(@"%@",playingItem);
    
    
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    // Override point for customization after application launch.
    UIViewController *viewController1;
    
  
    UIViewController *viewController2 ;
     UIViewController *viewController4;
    UIViewController *viewController3;
 UIViewController *viewController5;
    
       if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
    
    viewController1 = [[iChantViewController alloc] initWithNibName:@"iChantViewController-iPad" bundle:nil];
           
//   viewController2 = [[GetPackageListViewController alloc] initWithNibName:@"GetPackageListViewController-iPad" bundle:nil] ;
    viewController4= [[ActiveDownLoadController alloc] initWithNibName:@"ActiveDownloadController-iPad" bundle:nil] ;
    viewController3 = [[UpdateProduectViewController alloc] initWithNibName:@"UpdateProduectViewController-iPad" bundle:nil] ;
              viewController5 = [[MoreViewController alloc] initWithNibName:@"MoreViewController-iPad" bundle:nil] ;
       }else
       {
            viewController1 = [[iChantViewController alloc] initWithNibName:@"iChantViewController" bundle:nil];
//             viewController2 = [[GetPackageListViewController alloc] initWithNibName:@"GetPackageListViewController" bundle:nil] ;
             viewController4= [[ActiveDownLoadController alloc] initWithNibName:@"ActiveDownLoadController" bundle:nil] ;
            viewController3 = [[UpdateProduectViewController alloc] initWithNibName:@"UpdateProduectViewController" bundle:nil] ;
             viewController5 = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil] ;
       }
    
    //    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //    if (screenBounds.size.height == 568)
    //    {
    //        viewController4=[[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    //    }
    //    else
    //    {
    //        viewController4 = [[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    //   }
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
          [self.tabBarController.tabBar setTranslucent:NO];
      
     
        [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:65.0f/255.0f green:135.0f/255.0f blue:104.0f/255.0f alpha:1.0f]];
  
    }
    self.tabBarController.viewControllers =[NSArray arrayWithObjects:[[UINavigationController alloc] initWithRootViewController:viewController1],[[UINavigationController alloc] initWithRootViewController:viewController3],[[UINavigationController alloc] initWithRootViewController:viewController4],[[UINavigationController alloc] initWithRootViewController:viewController5],nil];
   // self.tabBarController.viewControllers = @[ ,  , , ,];
    self.tabBarController.navigationController.navigationBar.hidden=YES;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
 //   return YES;
    
	////////////  For applying new setting  in application when app is updated from app stroe //////////////
	
	NSString*	versionSaved = [[[NSUserDefaults standardUserDefaults] objectForKey:kAppUpdateUserDefaultString] mutableCopy];
	NSString*   versionFromInfoPlist = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	NSLog(@"Saved Version : %@",[[[NSUserDefaults standardUserDefaults] objectForKey:kAppUpdateUserDefaultString] mutableCopy]);
	NSLog(@"Version From Info-Plist : %@",versionFromInfoPlist);
	
	if ([versionSaved isEqualToString:versionFromInfoPlist])
	{
		NSLog(@"Saved Version matched with version From Plist");
	}
	else 
	{
		[[NSUserDefaults standardUserDefaults] setObject:versionFromInfoPlist forKey:kAppUpdateUserDefaultString];  
		[[NSUserDefaults standardUserDefaults] synchronize];
		// DO NEW CODE FOR NEW SETTING IF NECESORRY ///
		
	}
	NSFileManager *fManager=[NSFileManager defaultManager];
	//NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *directory=[paths objectAtIndex:0];
	
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
    NSString *cachesPath = [NSString stringWithFormat:@"%@/Caches/",libraryPath];
	
	NSString *xmlPath =[NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:[NSString stringWithFormat:@"%@/Caches/%@/",libraryPath,kDefaultChantName]];
	
	if (xmlPath == nil) 
	{
		
		NSString *path = [[NSBundle mainBundle] pathForResource:kDefaultChantName ofType:@"zip"];
		if (path != nil) 
		{
			
			// unzip free content
       
			 NSString* filePath = [NSString stringWithFormat:@"%@/Caches/%@.zip", libraryPath,kDefaultChantName];
            
        //     NSString* filePath = [NSString stringWithFormat:@"%@/Caches/%@.zip", libraryPath,@"freesampler"];
            
            NSLog(@"%@",filePath);
            
			NSData *data = [NSData dataWithContentsOfFile:path];
			[fManager createFileAtPath:filePath contents:data attributes:nil];
			
	        ZipArchive *zipArchive = [[ZipArchive alloc] init];
			
			if([zipArchive UnzipOpenFile:filePath]) 
			{
				
				if ([zipArchive UnzipFileTo:cachesPath overWrite:YES]) {
					
					
					NSLog(@"Archive  unzip Success");
					[self createUserDefualtForSampleItem];
					[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAddBannerKey];
					[[NSUserDefaults standardUserDefaults] synchronize];
					[fManager removeItemAtPath:filePath error:NULL];
					
					
				}
				else 
					NSLog(@"Failure   Unzip Archive");
			}
			else	
				NSLog(@"Failure  Open Archive");
			
			
		}
		
	}
	else 
		NSLog(@"Already unzipped");
	
		
	
	
	//check for remaning downlaod...
	NSData *data4 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	self.remainingDownloadArray =  [NSKeyedUnarchiver unarchiveObjectWithData:data4];
	if (remainingDownloadArray != nil )
	{
		
		for(int i=0;i<[remainingDownloadArray count];i++)
		{
			
			
			ActiveDownload *objAD = [remainingDownloadArray objectAtIndex:i];
			#ifdef DEBUG
			NSLog(@"transac ID : %@",objAD.transactionID);
			NSLog(@"Prod ID : %@",objAD.productID);
			NSLog(@"Prod Name : %@",objAD.productName);
			NSLog(@"URL : %@",objAD.url);
			NSLog(@"product type :%@",objAD.productType);
			#endif
			
			ProductWebRequest *pr = [[ProductWebRequest alloc] init];
			pr.productType = objAD.productType;
			pr.productID = objAD.productID;
			pr.productName =  objAD.productName;
			pr.transactionID = objAD.transactionID;
			pr.downLoadSize = [objAD.totalSize intValue]*1024;
			//pr.urlCount = [pr.urlArray count];
			[pr getAndUnZipContent:[objAD.urlArray objectAtIndex:0]];
			//[pr release];
		}
	}
    
    
    /*if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        UINavigationController *tempController=[[UINavigationController alloc] initWithRootViewController:viewController];
        tempController.navigationBar.tintColor=[UIColor blackColor];
        self.mNavigationController=tempController;
        [window addSubview:mNavigationController.view];
    }
	else{
        self.viewController = [[iChantViewController alloc] initWithNibName:@"iChantViewController-iPad" bundle:nil];
        UINavigationController *tempController=[[UINavigationController alloc] initWithRootViewController:viewController];
        tempController.navigationBar.tintColor=[UIColor blackColor];
        self.mNavigationController=tempController;
        [window addSubview:mNavigationController.view];
        
    }*/
	
	 
	[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [window makeKeyAndVisible];
	
//    [Appirater setAppId:@"393501381"];
//    
//    [Appirater setDaysUntilPrompt:5];
//    [Appirater setUsesUntilPrompt:10];
//    [Appirater setSignificantEventsUntilPrompt:0];
//    [Appirater setTimeBeforeReminding:2];
//    //[Appirater setDebug:YES];
    
    
    [Appirater setAppId:@"418108039"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
    
    //Flurry Initialise
    [Flurry startSession:@"F4ZVRM97G92JZGFNSHV2"];
    
    [self vungleStart];
	

    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
                                          UIRemoteNotificationTypeSound)];

    [self clearNotifications];
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *str = [NSString
                     stringWithFormat:@"%@",devToken];
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"device_token"];
    
    

    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://notifications.ipooja.com/iPoojaNotifier/devicetokenupdate?platform=ios&appid=3&token=%@&dev=dev",str] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    
    
    
  NSURLConnection  *connectionPost  = [[NSURLConnection alloc] initWithRequest:theRequest delegate:nil] ;
    connectionPost=nil;
    
    NSLog(@"%@",[[NSString stringWithFormat:@"http://notifications.ipooja.com/iPoojaNotifier/devicetokenupdate?platform=ios&appid=3&token=%@&dev=dev",str] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // Place your code for what to do when the ios device receives notification
    NSLog(@"The user info: %@", userInfo);
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"badges"])
    {
          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[NSUserDefaults standardUserDefaults] objectForKey:@"badges"] integerValue]+1];
    }else
    {
          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"badges"];
    }
    
  
    
    
   
    
//    [[NSUserDefaults standardUserDefaults]setObject:[[userInfo objectForKey:@"aps"]objectForKey:@"badge"] forKey:@"badge"];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber=application.applicationIconBadgeNumber;
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
- (void)application:(UIApplication *) didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    // Place your code for what to do when the registration fails
    NSLog(@"Registration Error: %@", err);
}

-(void) createUserDefualtForSampleItem
{
	userDefaults=[NSUserDefaults standardUserDefaults];
	narrations=[[[NSUserDefaults standardUserDefaults]objectForKey:kNarration] mutableCopy];
	displayLanguages=[[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages] mutableCopy];
	beadsArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kBeadsArray] mutableCopy];
	malasArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kMalaArray] mutableCopy];
	selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
	numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
	numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
	productIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
	
	
		narrations=[[NSMutableArray alloc] init];
		displayLanguages=[[NSMutableArray alloc] init];
		beadsArray=[[NSMutableArray alloc] init];
		malasArray=[[NSMutableArray alloc] init];
		selectedAudioSettingArray=[[NSMutableArray alloc] init];
		numberOfTimesArray=[[NSMutableArray alloc] init];
		numberOfSecondArray=[[NSMutableArray alloc]init];
		productIDArray=[[NSMutableArray alloc]init];
		
		
     NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	
	NSFileManager *fManager=[NSFileManager defaultManager];
	NSArray *fileArray=[fManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Caches/%@/",libraryPath,kDefaultChantName] error:nil];
	NSLog(@"Sub-Directory array is:%@",fileArray);
	NSString *chantOrderPlistPath=[NSBundle pathForResource:kChantOrderPlist ofType:@"plist" inDirectory:[NSString stringWithFormat:@"%@/Caches/%@/",libraryPath,kDefaultChantName]];
    
    
    
	NSArray *itemOrderArray=[[NSArray alloc] initWithContentsOfFile:chantOrderPlistPath];
	NSLog(@"item order array count is:%d",[itemOrderArray count]);
	for (int i=0; i<[itemOrderArray count]; i++)
	{
		NSString *s; 
		for (s in fileArray) 
		{
			NSString *plistPath=[NSBundle pathForResource:kChantPlist ofType:@"plist" inDirectory:[[NSString stringWithFormat:@"%@/Caches/%@/",libraryPath,kDefaultChantName] stringByAppendingString:s]];
			if (plistPath!=nil)
			{
				NSLog(@"Plist path : %@",plistPath);
				NSArray *chantDetailArray=[[NSArray alloc] initWithContentsOfFile:plistPath];
				NSLog(@"chantDetailArray :%@",chantDetailArray);
				NSLog(@"chantDetailArrayobjectAtIndex:2] : %@",[chantDetailArray objectAtIndex:2]);
				NSLog(@"[itemOrderArray objectAtIndex:i] : %@",[itemOrderArray objectAtIndex:i]);
				
				if ([[itemOrderArray objectAtIndex:i] isEqualToString:[chantDetailArray objectAtIndex:2]]) 
				{
						NSLog(@"YES product id finds equal");
					
						[narrations addObject:@"0"];
						[displayLanguages addObject:@"0"];
						[beadsArray addObject:@"0"];
						[malasArray addObject:@"0"];
						[selectedAudioSettingArray addObject:@"0"];
						[numberOfTimesArray addObject:@"1"];
						[numberOfSecondArray addObject:@"60"];
						[productIDArray addObject:[chantDetailArray objectAtIndex:2]];
                        NSLog(@"PRODUCT ID ARRAY %@",productIDArray);
						break;
				}
			}
		}
	}
	
		[userDefaults setObject:narrations forKey:kNarration];
		[userDefaults setObject:displayLanguages forKey:kDisplayLanguages];
		[userDefaults setObject:beadsArray forKey:kBeadsArray];
		[userDefaults setObject:malasArray forKey:kMalaArray];
		[userDefaults setObject:selectedAudioSettingArray forKey:kSelectedAudioSetting];
		[userDefaults setObject:numberOfTimesArray forKey:kNumberOfTimesArray];
		[userDefaults setObject:numberOfSecondArray forKey:kNumberOfSecondsArray];
		[userDefaults setObject:productIDArray forKey:kChantProductID];
	
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
     [self clearNotifications];
    
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    
    
    
    

}

@end
