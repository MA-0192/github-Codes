//
//  ProductWebRequest.m
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProductWebRequest.h"
#import "ZipArchive.h"
#import "ConstantInApps.h"
#import "ActiveDownload.h"
#import "WebRequest_InApp.h"
//#import "AppDelegate.h"
#import "ActiveDownLoadController.h" 
#import "GlobalValues_InApp.h"
#import "AlertConstants.h"
#import "Constants.h"
#import "Constants_InApp.h"


@implementation ProductWebRequest
@synthesize delegate = _delegate;
@synthesize updatedData;
@synthesize activeDownLoadArray;
@synthesize transactionID;
@synthesize item;
@synthesize uniqueDeviceIdentifier;
@synthesize productID;
@synthesize productType;
@synthesize downLoadSize;
@synthesize ActiveDownLoadArray;
@synthesize activeDownloadObj;
@synthesize productName;
@synthesize activeUserDefaults;
@synthesize filePath;
@synthesize updatedDownLoadSize;
@synthesize totalSize;
@synthesize narrations;
@synthesize displayLanguages;
@synthesize beadsArray;
@synthesize malasArray;
@synthesize selectedAudioSettingArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;
@synthesize productIDArray;
@synthesize bgTask;
@synthesize alertClearUnfinished = _alertClearUnfinished;
@synthesize connection = _connection;

GlobalValues_InApp *globalValues_InApp;


bool boolAlertShown;

- (id) init
{
    self = [super init];
    boolAlertShown = NO;
    
    if (self != nil) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
            self.bgTask = UIBackgroundTaskInvalid;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(doBackground:)
                                                         name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
        
    }
    
    return self;
}

- (void) doBackground:(NSNotification *)aNotification {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]){
        
        UIApplication *app = [UIApplication sharedApplication];
        
        if ([app respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]) {
            self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
                // Synchronize the cleanup call on the main thread in case
                // the task actually finishes at around the same time.
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.bgTask != UIBackgroundTaskInvalid)
                    {
                        [app endBackgroundTask:self.bgTask];
                        self.bgTask = UIBackgroundTaskInvalid;
                    }
                });
            }];
        }
        
    }
    
}


// END OF - TO KEEP DOWNLOADING IN BACKGROUND STATE


- (void)getAndUnZipContent:(NSString *)path 
{
	
    globalValues_InApp = [GlobalValues_InApp sharedManager];
    
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{
			
		MyLog(@"total size : %@",self.totalSize);
		MyLog(@"total download size1 :%d",self.downLoadSize);
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//		NSString *documentsDir = [paths objectAtIndex:0];
		NSFileManager *fileManager = [NSFileManager defaultManager];
//		filePath = [NSString stringWithFormat:@"%@/%@.zip", documentsDir,self.productID];
        
        NSLog(@"globalValues_InApp.strUnzipPackagePath = %@", globalValues_InApp.strUnzipPackagePath);
        if ([globalValues_InApp.strUnzipPackagePath length]<5){
            NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
            @throw myException;
        }
        else {
            filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
            
           NSLog(@"FILE PATH %@",filePath);
        }
        
		//NSData *data;
		[fileManager createFileAtPath:filePath contents:nil attributes:nil];
		
			ActiveDownLoadArray = [[NSMutableArray alloc] init];
			//appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
			globalValues_InApp.totalSizeArray = [[NSMutableArray alloc]init];
			globalValues_InApp.updatedDownLoadSizeArray = [[NSMutableArray alloc]init];
			globalValues_InApp.progressValueArray = [[NSMutableArray alloc]init];
			
			activeUserDefaults = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
			ActiveDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:activeUserDefaults];
			//ActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:array];
			//self.uniqueDeviceIdentifier = @"";
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
			[request setURL:[NSURL URLWithString:path]];
			[request setHTTPMethod:@"POST"];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
			// Developer Authentication
			
			NSString *strCredentials = kDeveloperAuthenticationKey;
			NSData *dataCredentials = [NSData alloc];
			dataCredentials = [strCredentials dataUsingEncoding: NSUTF8StringEncoding];
			NSString *encodedString = [dataCredentials base64EncodedString];
			
			NSString *str = [NSString stringWithFormat:@"Basic %@",encodedString];

			[request setValue:str forHTTPHeaderField:@"Authorization"];
		
			
        #ifdef DEBUG
		        MyLog(@"encoded string %@", encodedString);
				MyLog(@"%@",str);
		       MyLog(@"request after aplying aunthentication:%@",request ); 
        #endif
			
			
			//NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: path]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
		    self.connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
			NSMutableData *data = [[NSMutableData alloc] init];
			updatedData = data;
			if (self.connection == nil) 
			{
                
			}
			else
			{
				for (int i=0; i<[ActiveDownLoadArray count]; i++)
				{
					activeDownloadObj = [ActiveDownLoadArray objectAtIndex:i];
					[globalValues_InApp.updatedDownLoadSizeArray addObject:@"0"];
					[globalValues_InApp.totalSizeArray addObject:@"0"];
					[globalValues_InApp.progressValueArray addObject:@"0"];
					
				}
			}
	}else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleNoNetworkAvailable message:kAlertViewMessageForNoNetwork delegate:nil cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
		[alert show];
	}

  }



#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	[updatedData setLength:0];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];

	#ifdef DEBUG
//	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
//		int responseCode = [httpResponse statusCode];
		//MyLog(@"content-length: %f bytes",[NSNumber numberWithLongLong:[response expectedContentLength]]);
//		MyLog(@"Response Code : %d",responseCode);
	#endif
	
	//downLoadSize = [response expectedContentLength];
	MyLog(@"total download size2:%lld",[response expectedContentLength]);
	
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the updatedData.
		[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	
	activeUserDefaults = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	ActiveDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:activeUserDefaults];
	
	//[updatedData appendData:data];
	#ifdef DEBUG
		//MyLog(@"getting data file downloading %d",[ActiveDownLoadArray count]);
	#endif
	
	if ([ActiveDownLoadArray count]==0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.connection cancel];
    }

	
	for (int i=0; i<[ActiveDownLoadArray count]; i++)
	{
		activeDownloadObj = [ActiveDownLoadArray objectAtIndex:i];

		if ([self.productID isEqual:activeDownloadObj.productID])
		{
			
            if (!boolAlertShown){
                boolAlertShown = YES;
                
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"After downloading the package, the package will be extracted and this will freeze your app for a while. Please be patient while your package content gets extracted and is ready to use." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //[alert show];
            }
            
            
			updatedDownLoadSize = updatedDownLoadSize +(float)( [data length]/(1024.0*1024.0));
			NSString *str1 = [NSString stringWithFormat:@"%f",updatedDownLoadSize];
			MyLog(@"downloading : %f",updatedDownLoadSize);
			MyLog(@"downloaded data :%d",[data length]);
			[globalValues_InApp.updatedDownLoadSizeArray replaceObjectAtIndex:i withObject:str1];

			float ds =downLoadSize/(1024.0*1024.0);
			
            NSString *str2 = [NSString stringWithFormat:@"%f",ds];
			[globalValues_InApp.totalSizeArray replaceObjectAtIndex:i withObject:str2	];
		
			
			//NSString *str3 = [NSString stringWithFormat:@"%f",((float) [updatedData length] / (float) downLoadSize)];
			NSString *str3 = [NSString stringWithFormat:@"%f",((float) updatedDownLoadSize /(float) ds) ];
			MyLog(@"updated download:%f",updatedDownLoadSize);
			MyLog(@"total size :%d",downLoadSize);
			MyLog(@"string 3:%@",str3);
			[globalValues_InApp.progressValueArray replaceObjectAtIndex:i withObject:str3];
		
		}

	}
		
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//	NSString *documentsDir = [paths objectAtIndex:0];
//	//NSFileManager *fileManager = [NSFileManager defaultManager];
//    filePath = [NSString stringWithFormat:@"%@/%@.zip", documentsDir,self.productID];
//    
    
    
    if ([globalValues_InApp.strUnzipPackagePath length]<5){
        NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
        @throw myException;
    }
    else {
        filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
    }
    
    
	
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:data];
	//[data release];

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection 

{

    
#ifdef DEBUG
    MyLog(@"connection finished loading successfully");
#endif
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downloadDone) userInfo:nil repeats:NO];

}

-(void) downloadDone{

    @autoreleasepool {
        [self performSelectorInBackground:@selector(unzipInBackground) withObject:nil];
    }

}

-(void) unzipInBackground{

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    MyLog(@"strUnzipPackagePath = %@", globalValues_InApp.strUnzipPackagePath);
    if ([globalValues_InApp.strUnzipPackagePath length]<5){
        NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
        @throw myException;
    }
    else {
        filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
        MyLog(@"filePath = %@", filePath);
        
        /*
         [fileManager createFileAtPath:filePath contents:updatedData attributes:nil];
         */
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        
        if([zipArchive UnzipOpenFile:filePath]) 
        {
            
            if ([zipArchive UnzipFileTo:globalValues_InApp.strUnzipPackagePath overWrite:YES]) {
                //unzipped successfully
#ifdef DEBUG
                MyLog(@"Archive unzip Success");
#endif
                
                [fileManager removeItemAtPath:filePath error:NULL];
                
                //[self.activityIndicator stopAnimating];
                
                
                NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
                activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
                int i;
                for(i=0;i<[activeDownLoadArray count];i++)
                {
                    ActiveDownload *objAD = [activeDownLoadArray objectAtIndex:i];
                    
                    
                    
                    if([objAD.productID isEqualToString:self.productID])
                    {
                        NSInteger urlCountInt = [objAD.urlCount intValue];
                        MyLog(@"after conversion url count :%d",urlCountInt);
                        urlCountInt ++;
                        MyLog(@"after increement URL Count :%d",urlCountInt);
                        
                        if (urlCountInt <[objAD.urlArray count])
                        //if ([objAD.urlArray count])
                        {
                            
                            objAD.urlCount = [NSString stringWithFormat:@"%d",urlCountInt];
                            MyLog(@"after increement urlcount :%@",objAD.urlCount);
                            [self getAndUnZipContent:[objAD.urlArray objectAtIndex:urlCountInt]];
                        }else
                        {
                            [activeDownLoadArray removeObjectAtIndex:i];
                            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                            [self performSelectorOnMainThread:@selector(packageUnzippingDone) withObject:self waitUntilDone:NO];
                            [self sendAcknowledgement];
                            [self settingUserDefaultsForNewItem];
                            
                            [_delegate downloadCompleted];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

                        }
                        
                        break;
                    }
                }
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                self.alertClearUnfinished = [[UIAlertView alloc]initWithTitle:kAlertViewTitleForPackageNotDownloaded message:kAlertViewMessageForPackageNotDownloaded delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear,nil];
                [self.alertClearUnfinished show];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

#ifdef DEBUG
                MyLog(@"Failure To Unzip Archive");				
#endif
                
            }
            
        } 
        else {
            self.alertClearUnfinished = [[UIAlertView alloc]initWithTitle:kAlertViewTitleForPackageNotDownloaded message:kAlertViewMessageForPackageNotDownloaded delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear,nil];
            [self.alertClearUnfinished show];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

#ifdef DEBUG
            MyLog(@"Failure To Open Archive");
#endif
            
        }
        
    }
    
    
    
	//}
}

-(void) settingUserDefaultsForNewItem
{
	NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
	narrations=[[[NSUserDefaults standardUserDefaults]objectForKey:kNarration] mutableCopy];
	displayLanguages=[[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages] mutableCopy];
	beadsArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kBeadsArray] mutableCopy];
	malasArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kMalaArray] mutableCopy];
	selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
	numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
	numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
	productIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
	
	
    for (int i=0; i<[productIDArray count]; i++) {
        NSLog(@"Product ID:%@",[productIDArray objectAtIndex:i]);
    }
	
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachesPath = [NSString stringWithFormat:@"%@/Caches",libraryPath];
	
	NSString *newDirectory;//Name of new directory in /Document directory of app
	//NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths1 objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
    //NSArray *fileListArray =  [manager directoryContentsAtPath:documentsDirectory];
	NSArray *fileListArray =  [manager contentsOfDirectoryAtPath:cachesPath error:nil];
	NSString *s;
	
	for (s in fileListArray)//This is for knowing the new downloaded directory
	{
		NSString *folderPath = [NSString stringWithFormat:@"%@/%@/",cachesPath,s];
		NSString *chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:folderPath];
        if (chantDetailPath != NULL)
		{
			NSArray *plistContent=[[NSArray alloc] initWithContentsOfFile:chantDetailPath];
			if ([[plistContent objectAtIndex:2] isEqualToString:self.productID])
			{
				
				newDirectory=s;
				NSLog(@"NEW DIRECTORY:%@",newDirectory);
				NSLog(@"Product ID:%@",self.productID);
				break;
			}
		}
	}
	
	
	NSFileManager *fManager=[NSFileManager defaultManager];
	NSArray *fileArray=[fManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/",cachesPath,newDirectory] error:nil];
	NSLog(@"Sub-Directory array is:%@",fileArray);
	NSString *str;
	for (str in fileArray)
	{
		NSString *plistPath=[NSBundle pathForResource:kChantPlist ofType:@"plist" inDirectory:[[NSString stringWithFormat:@"%@/%@/",cachesPath,newDirectory] stringByAppendingString:[NSString stringWithFormat:@"%@/",str]]];
		if (plistPath!=nil)
		{
			NSArray *chantDetailArray=[[NSArray alloc] initWithContentsOfFile:plistPath];
			NSString *pID=[chantDetailArray objectAtIndex:2];
			NSLog(@"Product Id is:%@",pID);
			NSInteger existingItemIndex=[productIDArray indexOfObject:pID];
			
			if (existingItemIndex!=NSNotFound) //If the item does exist and one wants to overwrite
                //Then cleaning all the user defaults for that item
			{
				NSLog(@"PRODUCT IDS EXIST ALREADY");
				[narrations removeObjectAtIndex:existingItemIndex];
				[displayLanguages removeObjectAtIndex:existingItemIndex];
				[beadsArray removeObjectAtIndex:existingItemIndex];
				[malasArray removeObjectAtIndex:existingItemIndex];
				[selectedAudioSettingArray removeObjectAtIndex:existingItemIndex];
				[numberOfTimesArray removeObjectAtIndex:existingItemIndex];
				[numberOfSecondArray removeObjectAtIndex:existingItemIndex];
				[productIDArray removeObjectAtIndex:existingItemIndex];
			}
			
			
			[narrations addObject:@"0"];
			[displayLanguages addObject:@"0"];
			[beadsArray addObject:@"0"];
			[malasArray addObject:@"0"];
			[selectedAudioSettingArray addObject:@"0"];
			[numberOfTimesArray addObject:@"1"];
			[numberOfSecondArray addObject:@"60"];
			[productIDArray addObject:[chantDetailArray objectAtIndex:2]];
			
			
		}
	}
	
	int val=[[[NSUserDefaults standardUserDefaults] objectForKey:kAddBannerKey] intValue];
	if (val==-1);
	else
	{
		Class c=NSClassFromString(@"ADBannerView");
		if(c)
		{
			[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddBannerKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	
	
	//NSLog(@"Product ID is:%@",self.productID);
	[userDefaults setObject:narrations forKey:kNarration];
	[userDefaults setObject:displayLanguages forKey:kDisplayLanguages];
	[userDefaults setObject:beadsArray forKey:kBeadsArray];
	[userDefaults setObject:malasArray forKey:kMalaArray];
	[userDefaults setObject:selectedAudioSettingArray forKey:kSelectedAudioSetting];
	[userDefaults setObject:numberOfTimesArray forKey:kNumberOfTimesArray];
	[userDefaults setObject:numberOfSecondArray forKey:kNumberOfSecondsArray];
	[userDefaults setObject:productIDArray forKey:kChantProductID];
	
	
}
- (void)removeFromActiveDownLoad
{
    MyLog(@"Removed from Active download");
	NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	int i;
	for(i=0;i<[activeDownLoadArray count];i++)
	{
		ActiveDownload *objAD = [activeDownLoadArray objectAtIndex:i];
		if([objAD.productID isEqualToString:self.productID])
		{
			[activeDownLoadArray removeObjectAtIndex:i];
			globalValues_InApp.activeDownLoadBool = 0;
			break;
		}
	}
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	NSArray *array = [[NSArray alloc] init];
	NSData *data123 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	array = [NSKeyedUnarchiver unarchiveObjectWithData:data123];
	for(int i=0;i<[array count];i++)
	{
	
//		ActiveDownload *objAD = [array objectAtIndex:i];
//		MyLog(@"transac ID : %@",objAD.transactionID);
//		MyLog(@"Prod ID : %@",objAD.productID);
//		MyLog(@"Prod Name : %@",objAD.productName);
//		MyLog(@"URL : %@",objAD.url);		
    
	}
	
}

- (void)sendAcknowledgement
{
	if ([self.productType isEqual:@"p"])
	{
		NSString *str = [NSString stringWithFormat:@"acknowledgementPaidProductRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><productID>%@</productID></downloadSuccess>",self.transactionID,self.productID];
#ifdef DEBUG
		MyLog(@"Acknowledgement request = %@",str);
#endif
		
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];

        [wr webRequestURL:kpaidAcknowledgementURL withXMLMessage:str withPostVariable:kPV_paidAcknowledgementURL];
		
	}else if ([self.productType isEqual:@"f"]) 
	{
		NSString *str = [NSString stringWithFormat:@"acknowledgementFreeProductRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><productID>%@</productID></downloadSuccess>",self.transactionID,self.productID];
#ifdef DEBUG
		MyLog(@"Acknowledgement request = %@",str);
#endif
		
		
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];
        
        [wr webRequestURL:kfreeAcknowledgementURL withXMLMessage:str withPostVariable:kPV_freeAcknowledgementURL];
	}
	else if ([self.productType isEqual:@"up"]) 
	{
		NSString *str = [NSString stringWithFormat:@"productUpgradeAcknowledgementRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><productID>%@</productID></downloadSuccess>",self.transactionID,self.productID];	
#ifdef DEBUG
		MyLog(@"Acknowledgement request = %@",str);
#endif
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];
        
        [wr webRequestURL:kgetUpdatesAcknowledgementURL withXMLMessage:str withPostVariable:kPV_getUpdatesAcknowledgementURl];
	}
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    MyLog(@"ProductWebRequest ERROR = %@", [error localizedDescription] );
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleInternetConnectionFailed message:kAlertViewMessageForInternetConnectionFailedWhileDownloading delegate:nil cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
    [alert show];
    
    globalValues_InApp.activeDownLoadBool = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kuserDefKeyForActiveDownLoad"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    /*
    NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:@"kuserDefKeyForActiveDownLoad"] mutableCopy];
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	NSMutableArray *marrActiveDownLoadArray = [[NSMutableArray alloc] initWithArray:array];
    
    
    [marrActiveDownLoadArray removeAllObjects];
     */
	
}
-(void)packageUnzippingDone{
    globalValues_InApp.activeDownLoadBool = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleThankYou message:kAlertViewMessageForPackageSuccessfullyInstalled delegate:nil cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
    [alert show];
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"packagePurchasedOrNot"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];

}

-(void) cancelRequest{
    
    
    [self.connection cancel];
}

#pragma mark - UIALERTVIEW DELEGATE HANDLERS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.alertClearUnfinished) {
        if (buttonIndex == 1) {
            [globalValues_InApp.updatedDownLoadSizeArray removeAllObjects];
            [globalValues_InApp.totalSizeArray removeAllObjects];
            [globalValues_InApp.progressValueArray removeAllObjects];
            globalValues_InApp.activeDownLoadBool = 0;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            //REMOVE ACTIVE DOWNLOAD DATA FROM NSUSERDEFAULTS
            NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
            NSMutableArray *activeD = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            [activeD removeAllObjects];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeD];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserDefKeyForActiveDownLoad];
            [[NSUserDefaults standardUserDefaults] synchronize];
            MyLog(@"activeD count = %d", [activeD count]);
            
            //REMOVE PARTIALLY DOWNLOADED ZIP FILES
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *iLP_Path = [[NSString alloc] init];
            iLP_Path = [NSString stringWithFormat:@"%@/Caches/iLP_UserData", libraryPath];
            NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:iLP_Path error:nil];
            NSArray *onlyZip = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.zip'"]];
            NSFileManager *fManager = [NSFileManager defaultManager];
            
            for (NSString *s in onlyZip){
                NSMutableString *strPath = [[NSMutableString alloc] initWithString:s];
                strPath = [NSMutableString stringWithFormat:@"%@", [strPath substringToIndex:([strPath length] - 4)]];
                MyLog(@"strPath = %@", strPath);
                
                NSString *path = [NSString stringWithFormat:@"%@/%@.zip", iLP_Path, strPath];
                MyLog(@"path = %@", path);
                [fManager removeItemAtPath:path error:NULL];
            }

        }
    }
}

@end
