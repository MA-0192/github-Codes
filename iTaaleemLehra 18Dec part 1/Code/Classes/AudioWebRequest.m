//
//  AudioWebRequest.m
//  iCityPediaUniversal
//
//  Created by Gopesh Kumar Gupta on 11/10/12.
//
//

#import "AudioWebRequest.h"
#import "ZipArchive.h"
#import "ConstantInApps.h"
#import "ActiveDownload.h"
#import "WebRequest_InApp.h"
//#import "AppDelegate.h"
#import "NSData+Base64.h"
#import "ActiveDownLoadController.h"
#import "GlobalValues_InApp.h"
#import "Reachability.h"
#import "DBConn.h"
#import "Constants.h"
#import "GlobalValues_iLP.h"
#import "AlertConstants.h"

@implementation AudioWebRequest

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
@synthesize bgTask;
@synthesize connection = _connection;
@synthesize alertClearUnfinished = _alertClearUnfinished;

GlobalValues_InApp *globalValues_InApp;


bool boolAlertShown;

- (id) init
{
    MyLog(@"init");
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
    MyLog(@"doBackground");
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
    MyLog(@"product id in unzip content = %@",self.productID);
    globalValues_InApp = [GlobalValues_InApp sharedManager];
    
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable)
	{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([globalValues_InApp.strUnzipPackagePath length]<5){
            NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
            @throw myException;
        }
        else {
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
        }
        
		[fileManager createFileAtPath:filePath contents:nil attributes:nil];
        ActiveDownLoadArray = [[NSMutableArray alloc] init];
        globalValues_InApp.totalSizeArray = [[NSMutableArray alloc]init];
        globalValues_InApp.updatedDownLoadSizeArray = [[NSMutableArray alloc]init];
        globalValues_InApp.progressValueArray = [[NSMutableArray alloc]init];
        
        activeUserDefaults = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
        ActiveDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:activeUserDefaults];
        self.uniqueDeviceIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"POST"];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        // DEVELOPER AUTHENTICATION
        NSString *strCredentials = kDeveloperAuthenticationKey;
        NSData *dataCredentials = [NSData alloc];
        dataCredentials = [strCredentials dataUsingEncoding: NSUTF8StringEncoding];
        NSString *encodedString = [dataCredentials base64EncodedString];
        NSString *str = [NSString stringWithFormat:@"Basic %@",encodedString];
        [request setValue:str forHTTPHeaderField:@"Authorization"];
        
        
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet Connection not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    
}



#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	MyLog(@"didReceiveResponse");
	[updatedData setLength:0];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
    

    
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the updatedData.
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	
	activeUserDefaults = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
	ActiveDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:activeUserDefaults];
    
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
            }
            
            
//			updatedDownLoadSize = updatedDownLoadSize +(float)( [data length]/(1024.0*1024.0));
            //			NSString *str1 = [NSString stringWithFormat:@"%f",updatedDownLoadSize];
            //			[globalValues_InApp.updatedDownLoadSizeArray replaceObjectAtIndex:i withObject:str1];
            
            //			float ds =downLoadSize/(1024.0*1024.0);
			
            //            NSString *str2 = [NSString stringWithFormat:@"%f",ds];
            //			[globalValues_InApp.totalSizeArray replaceObjectAtIndex:i withObject:str2	];
            
			
			
            //			NSString *str3 = [NSString stringWithFormat:@"%f",((float) updatedDownLoadSize /(float) ds) ];
            
            //			[globalValues_InApp.progressValueArray replaceObjectAtIndex:i withObject:str3];
            
		}
        
	}
    
    
    
    if ([globalValues_InApp.strUnzipPackagePath length]<5){
        NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
        @throw myException;
    }
    else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
    }
    
    
	
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:data];
	//[data release];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    MyLog(@"didFinishLoading");
    
#ifdef DEBUG
    //MyLog(@"connection finished loading successfully");
#endif
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downloadDone) userInfo:nil repeats:NO];
    
}

-(void) downloadDone{
    MyLog(@"downloadDone");
    @autoreleasepool {
        [self performSelectorInBackground:@selector(unzipInBackground) withObject:nil];
    }
    
}

-(void) unzipInBackground{
    
    MyLog(@"unzipInBackground");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([globalValues_InApp.strUnzipPackagePath length]<5){
        NSException *myException = [[NSException alloc] initWithName:@"InApp_FilePathException" reason:@"Unzip Package Path Not Set." userInfo:nil];
        @throw myException;
    }
    else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [NSString stringWithFormat:@"%@/%@.zip", globalValues_InApp.strUnzipPackagePath, self.productID];
        
        
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if([zipArchive UnzipOpenFile:filePath])
        {
            MyLog(@"globalValues_InApp.strUnzipPacakgePath = %@",globalValues_InApp.strUnzipPackagePath);
            if ([zipArchive UnzipFileTo:[NSString stringWithFormat:@"%@/voice/", globalValues_InApp.strUnzipPackagePath] overWrite:YES]) {
                
                [fileManager removeItemAtPath:filePath error:NULL];
                NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
                activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
                int i;
                for(i=0;i<[activeDownLoadArray count];i++)
                {
                    ActiveDownload *objAD = [activeDownLoadArray objectAtIndex:i];
                    if([objAD.productID isEqualToString:self.productID])
                    {
                        NSInteger urlCountInt = [objAD.urlCount intValue];
                        urlCountInt ++;
                        
                        if (urlCountInt <[objAD.urlArray count])
                        {
                            
                            objAD.urlCount = [NSString stringWithFormat:@"%d",urlCountInt];
                            [self getAndUnZipContent:[objAD.urlArray objectAtIndex:urlCountInt]];
                        }
                        else
                        {
                            
                            GlobalValues_iLP *objGlobalValues_iLP = [GlobalValues_iLP sharedManager];
                            NSMutableArray *arrArg = [[NSMutableArray alloc] init];
                            [arrArg addObject:objGlobalValues_iLP.strSelectedAudioPackageForDownload];
                            [arrArg addObject:@"1.0"];
                            [arrArg addObject:@"1"];
                            
                            MyLog(@"strSelectedAudioPackageForDownload = %@",objGlobalValues_iLP.strSelectedAudioPackageForDownload);
                                                
                            [objGlobalValues_iLP.dbConn openDB:objGlobalValues_iLP.strUserDB dbFilePath:objGlobalValues_iLP.strUserDB_DBPath];
                            
                            [objGlobalValues_iLP.dbConn insertIntoTable:kTable_languageAudioPackageStatus arrayOfArguments:arrArg queryName:nil];
                            
                            [activeDownLoadArray removeObjectAtIndex:i];
                            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                            [self performSelectorOnMainThread:@selector(packageUnzippingDone) withObject:self waitUntilDone:NO];
                            [self sendAcknowledgement];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

                        }
                        break;
                    }
                }
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoadForAudio];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }
            else
            {
                self.alertClearUnfinished = [[UIAlertView alloc]initWithTitle:kAlertViewTitleForPackageNotDownloaded message:kAlertViewMessageForPackageNotDownloaded delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear,nil];
                [self.alertClearUnfinished show];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

#ifdef DEBUG
                //MyLog(@"Failure To Unzip Archive");
#endif
                
            }
            
        }
        else {
            self.alertClearUnfinished = [[UIAlertView alloc]initWithTitle:kAlertViewTitleForPackageNotDownloaded message:kAlertViewMessageForPackageNotDownloaded delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:kAlertViewButtonClear,nil];
            [self.alertClearUnfinished show];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

            
#ifdef DEBUG
            //MyLog(@"Failure To Open Archive");
#endif
            
        }
        
    }
    
    
    
	//}
}


- (void)removeFromActiveDownLoad
{
    MyLog(@"removeFromActiveDownload");
    //MyLog(@"Removed from Active download");
	NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
	activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	int i;
	for(i=0;i<[activeDownLoadArray count];i++)
	{
		ActiveDownload *objAD = [activeDownLoadArray objectAtIndex:i];
		
		
		
		if([objAD.productID isEqualToString:self.productID])
		{
			[activeDownLoadArray removeObjectAtIndex:i];
            //			globalValues_InApp.activeDownLoadBool = 0;
			
			break;
		}
	}
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoadForAudio];
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	NSArray *array = [[NSArray alloc] init];
	NSData *data123 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
	array = [NSKeyedUnarchiver unarchiveObjectWithData:data123];
	for(int i=0;i<[array count];i++)
	{
        
        //		ActiveDownload *objAD = [array objectAtIndex:i];
		//MyLog(@"transac ID : %@",objAD.transactionID);
		//MyLog(@"Prod ID : %@",objAD.productID);
		//MyLog(@"Prod Name : %@",objAD.productName);
		//MyLog(@"URL : %@",objAD.url);
        
	}
	
}

- (void)sendAcknowledgement
{
    MyLog(@"sendAcknowledgement");
	if ([self.productType isEqual:@"p"])
	{
		NSString *str = [NSString stringWithFormat:@"acknowledgementPaidProductRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><UUID>%@</UUID><productID>%@</productID></downloadSuccess>",self.transactionID,self.uniqueDeviceIdentifier,self.productID];
#ifdef DEBUG
		//MyLog(@"Acknowledgement request = %@",str);
#endif
		
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];
        
        [wr webRequestURL:kpaidAcknowledgementURL withXMLMessage:str withPostVariable:kPV_paidAcknowledgementURL];
		
	}else if ([self.productType isEqual:@"f"])
	{
		NSString *str = [NSString stringWithFormat:@"acknowledgementFreeProductRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><UUID>%@</UUID><productID>%@</productID></downloadSuccess>",self.transactionID,self.uniqueDeviceIdentifier,self.productID];
#ifdef DEBUG
		//MyLog(@"Acknowledgement request = %@",str);
#endif
		
		
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];
        
        [wr webRequestURL:kfreeAcknowledgementURL withXMLMessage:str withPostVariable:kPV_freeAcknowledgementURL];
	}
	else if ([self.productType isEqual:@"up"])
	{
		NSString *str = [NSString stringWithFormat:@"productUpgradeAcknowledgementRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><downloadSuccess><transactionID>%@</transactionID><UUID>%@</UUID><productID>%@</productID></downloadSuccess>",self.transactionID,self.uniqueDeviceIdentifier,self.productID];
#ifdef DEBUG
		//MyLog(@"Acknowledgement request = %@",str);
#endif
		WebRequest_InApp *wr = [[WebRequest_InApp alloc] init];
        
        [wr webRequestURL:kgetUpdatesAcknowledgementURL withXMLMessage:str withPostVariable:kPV_getUpdatesAcknowledgementURl];
	}
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //MyLog(@"ProductWebRequest ERROR = %@", [error localizedDescription] );
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleInternetConnectionFailed message:kAlertViewMessageForInternetConnectionFailedWhileDownloading delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
    [alert show];
    GlobalValues_iLP *objGlobalValues_iLP = [GlobalValues_iLP sharedManager];
    objGlobalValues_iLP.strSelectedAudioPackageForDownload = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kuserDefKeyForActiveDownLoadForAudio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	
}

-(void) cancelRequest{
    
    MyLog(@"cancelRequest");
    [self.connection cancel];
    self.connection = Nil;
}

-(void)packageUnzippingDone{
    GlobalValues_iLP *objGlobalValues_iLP = [GlobalValues_iLP sharedManager];
    
    
    NSMutableArray *arr = [[objGlobalValues_iLP.mdictResultFromDB objectForKey:kTable_language_InternationalLanguage] mutableCopy];
    
    NSMutableArray *marrAllLanguages = [[NSMutableArray alloc]init];
    
    for (int i=0; i<arr.count; i++) {
        [marrAllLanguages addObject:[[arr objectAtIndex:i] objectAtIndex:1]];
    }
    [objGlobalValues_iLP.dbConn openDB:objGlobalValues_iLP.strUserDB dbFilePath:objGlobalValues_iLP.strUserDB_DBPath];
    NSMutableArray *installedLanguages = [[objGlobalValues_iLP.dbConn getAllRowsFromTableNamed:kTable_languageAudioPackageStatus arrayOfArguments:nil] mutableCopy];
    int checkCountOfInstalledLanguagesAndPackageLanguages=0;
    
    for (int i=0; i<[installedLanguages count]; i++) {
        for (int j=0; j<[marrAllLanguages count]; j++) {
            if ([[[marrAllLanguages objectAtIndex:j]lowercaseString] isEqualToString:[[installedLanguages objectAtIndex:i] objectAtIndex:1]]) {
                checkCountOfInstalledLanguagesAndPackageLanguages++;
            }
        }
    }
    if (checkCountOfInstalledLanguagesAndPackageLanguages == [marrAllLanguages count]) {
        UIAlertView *alertView  = [[UIAlertView alloc]initWithTitle:kAlertViewTitleCongratulations message:kAlertViewMessageAfterDownloadingAllAudioPacks delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
        
        [alertView show];
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleThankYou message:[NSString stringWithFormat:kAlertViewMessageAfterDownloadingOneAudioPack,[objGlobalValues_iLP.strSelectedAudioPackageForDownload capitalizedString]] delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark - UIALERTVIEW DELEGATE HANDLERS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.alertClearUnfinished) {
        if (buttonIndex == 1) {
            GlobalValues_iLP *globalValues_iLP = [GlobalValues_iLP sharedManager];
            NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
            NSArray *activeDownloadUserDefaltArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            NSMutableArray *ActiveDownloadArray = [[NSMutableArray alloc] initWithArray:activeDownloadUserDefaltArray];
            if ([ActiveDownloadArray count]!=0) {
                globalValues_iLP.strSelectedAudioPackageForDownload = @"";
                NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoadForAudio] mutableCopy];
                
                NSMutableArray *activeD = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
                [activeD removeAllObjects];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeD];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoadForAudio];
                
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserDefKeyForActiveDownLoadForAudio];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
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
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAlertViewTitleAlert message:kAlertViewMessageForNoActiveDownload delegate:self cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
                [alertView show];
                
            }

        }
    }
}

@end
