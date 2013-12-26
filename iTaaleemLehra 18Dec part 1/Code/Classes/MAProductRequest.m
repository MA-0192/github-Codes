//
//  MAProductRequest.m
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//

#import "MAProductRequest.h"
#import "Reachability.h"
#import "Constants_InApp.h"
#import "PackageListXMLParser.h"
#import "iChantAppDelegate.h"
#import "BuyProductXMLParser.h"
#import "GlobalValues_InApp.h"
#import "ActiveDownload.h"
#import "ProductWebRequest.h"
//#import "ConstantInApps.h"
#import "AlertConstants.h"


GlobalValues_InApp *globalValues_InApp;

ProductWebRequest *productDownloader;

static MAProductRequest *sharedInstance = nil;

NSString *currProductID;

@implementation MAProductRequest

@synthesize delegate = _delegate;


-(id)init
{
    if (self = [super init])
    {
        marrProductItems = [[NSMutableArray alloc]init];
        globalValues_InApp = [GlobalValues_InApp sharedManager];
    }
    return self;
}

+(id)sharedInstance
{
    @synchronized (self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[super alloc]init];
        }
    }
    return sharedInstance;
}

#pragma mark INTERFACE METHODS

-(void)fetchProductListFromServer
{
    Reachability *reach = [[Reachability alloc]init];
    reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach currentReachabilityStatus] != NotReachable)
    {
        [_delegate productStatusUpdated:@"Looking for packages"];
        MAWebRequest *webRequest = [[MAWebRequest alloc]init];
        
        NSString *strBundleId = [[NSString alloc] initWithFormat:kDefaultBundleID];
        NSMutableString *strPostMessage = [[NSMutableString alloc] initWithFormat:kXMLForProductList, strBundleId];
        
        
        NSLog(@"strPostMessage = %@", strPostMessage);
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productListRetrieved:) name:@"productListRetrieved" object:webRequest];
        
        [webRequest webRequestwithURL:kGetXMLURL withMessage:strPostMessage withNotificationNameOrNil:@"productListRetrieved"];
    }
    else
    {
        [self showReachabilityWarning];
    }
}


-(void)fetchProductDetailsFromAppStore:(NSString*)product andType:(NSString*)type
{
    //send array of product ids and product type as defined in constants
    
    if ([type isEqualToString:kProductTypePaid] || [type isEqualToString:kProductTypeConsumable])
    {
        store = [MAStoreKit sharedInstance];
        store.delegate = self;
        NSArray *arrTemp = [NSArray arrayWithObject:product];
        [store getProductDetailsFromAppStore:arrTemp];
    }
    else if ([type isEqualToString:kProductTypeSample])
    {
        PackageListModalClass *selPackage;
        for (selPackage in marrProductItems)
        {
            if ([product isEqualToString:selPackage.strProductId])
                break;
        }
        
        NSMutableDictionary *dicProduct = [[NSMutableDictionary alloc]init];
        
        [dicProduct setObject:selPackage.strProductId forKey:kProductIDKey];
        [dicProduct setObject:selPackage.strName forKey:kProductNameKey];
        [dicProduct setObject:selPackage.strDescription forKey:kProductDescriptionKey];
        [dicProduct setObject:selPackage.strType forKey:kProductTypeKey];
        [dicProduct setObject:@"Free" forKey:kProductPriceKey];
        
        [_delegate productDetailsFromAppStoreRetrieved:dicProduct];
    }
    else 
    {
        NSLog(@"Error! Product ID not recognized");
        [_delegate productTransactionFailed];
    }
}

-(void)buyProductWithID:(NSString *)productID andType:(NSString*)type
{
    //Send product id and type as defined in constants
    if ([self canAddDownload:productID])
    {
        if ([type isEqualToString:kProductTypePaid]|| [type isEqualToString:kProductTypeConsumable])
        {
            store = [MAStoreKit sharedInstance];
            store.delegate = self;
            [store buyProduct:productID];
        }
        else if (([type isEqualToString:kProductTypeSample]) || ([type isEqualToString:@"f"]))
        {
            //Trigger download after fetch of URL
            [_delegate productPurchased:productID];
            [self fetchDownloadURLforProduct:productID];
        }
        else
        {
            NSLog(@"Error! Product ID not recognized");
            [_delegate productTransactionFailed];
        }
    }
    else
        [_delegate productTransactionFailed];

}


-(void)restoreProductWithID:(NSString *)productID
{
    NSLog(@"MAProductRequest Restore");
    if ([self canAddDownload:productID])
    {
        store = [MAStoreKit sharedInstance];
        store.delegate = self;
        [store restoreProduct:productID];
    }
    else
        [_delegate productTransactionFailed];
    
}

#pragma mark MAWebRequest NOTIFICATION CALLBACK METHODS
-(void)productListRetrieved:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"productListRetrieved" object:nil];
    
    NSData *responseData = [[notification userInfo] objectForKey:kResponseKeyName];
	
    BOOL success = NO;
	NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:responseData];
	PackageListXMLParser *parser;
	if(responseData != Nil)
	{
        parser = [[PackageListXMLParser alloc] initPackageListXMLParser];
		[xmlParser setDelegate:parser];
		success = [xmlParser parse];
	}
	
	if (success)
    {
        NSMutableArray *marrDataPackageList = [[NSMutableArray alloc] init];
        marrDataPackageList = [parser.marrData mutableCopy];
        
        NSMutableArray* marrDataPackageListNotContainingAudioPackages = [[NSMutableArray alloc]init];
        
        for (PackageListModalClass *obj in marrDataPackageList)
        {
            if (![obj.strType isEqualToString:@"f"])
            {
                [marrDataPackageListNotContainingAudioPackages addObject:obj];
            }
        }
        
        NSLog(@"parsed package list: %@", marrDataPackageList);
        int i = 0;
        for (PackageListModalClass *package in marrDataPackageListNotContainingAudioPackages)
        {       //For Logging purpose, can be removed
            i++;
            NSLog(@"PACKAGE %d", i);
            NSLog(@"Name: %@", package.strName);
            NSLog(@"Product Id: %@", package.strProductId);
            NSLog(@"Description: %@", package.strDescription);
            NSLog(@"Type: %@", package.strType);
            NSLog(@"Install Status: %@", package.strInstallStatus);
        }
        
        
        [self syncProductList:marrDataPackageListNotContainingAudioPackages];
        
        //return to calling class
        [_delegate productListRetrieved:marrDataPackageListNotContainingAudioPackages];
    }
}



#pragma mark MAStoreKit DELEGATE METHODS

-(void)storeDidRetrieveDetailsFromAppStore:(NSArray *)arrProductList
{

    
    NSLog(@"%@",arrProductList);
    
    [_delegate productDetailsFromAppStoreRetrieved:[arrProductList objectAtIndex:0 ]];
    
    
}

-(void)storeDidCompletePurchase:(NSString *)productID
{
    //trigger download after fetch of url
    [self fetchDownloadURLforProduct:productID];

    [_delegate productPurchased:productID];
}

-(void)storePurchaseFailed:(NSString *)productID
{
    NSLog(@"MAProductRequest Purchase failed");
    [_delegate productTransactionFailed];
}

-(void)storeDidApproveRestore:(NSString *)ProductID
{
    [self fetchDownloadURLforProduct:ProductID];
    [_delegate productRestored:ProductID];
}

-(void)storeDidUpdateMessage:(NSString *)message
{
    [_delegate productStatusUpdated:message];
}


#pragma mark INTERNAL METHODS

-(void)showReachabilityWarning
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)syncProductList:(NSArray*)newProductList
{
    PackageListModalClass *existingPackage;
    BOOL _bAlreadyExists = FALSE;
    int i;
    
    for (PackageListModalClass *newPackage in newProductList)
    {
        for (i = 0; i < [marrProductItems count]; i++)
        {
            if ([newPackage.strProductId isEqualToString:existingPackage.strProductId])
            {
                _bAlreadyExists = TRUE;
                break;
            }
        }
        if (_bAlreadyExists)
        {
            _bAlreadyExists = FALSE;
            [marrProductItems replaceObjectAtIndex:i withObject:newPackage];
        }
        else
            [marrProductItems addObject:newPackage];
    }
}



-(void)fetchDownloadURLforProduct:(NSString*)productID
{
    //Code to fetch URl/package follows
    [_delegate productStatusUpdated:@"Fetching package URL"];
    
    PackageListModalClass *package;
    BOOL _bFound = NO;
    for (package in marrProductItems)
    {
        if ([productID isEqualToString:package.strProductId])
        {
            _bFound = YES;
            break;
        }
    }
    
    if (_bFound)
    {
        
        MAWebRequest *request = [[MAWebRequest alloc]init];
        
        //NSString *uniqueIdentifier = @"";
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(packageDownload:) name:@"packagedownload" object:nil];
        
        
        if ([package.strType isEqualToString:kProductTypePaid])
        {
            NSString *requestMessage = [[NSString alloc]initWithFormat:kXMLforProductDownload,productID ];
            NSLog(@"Request string: %@", requestMessage);
            [request webRequestwithURL:kGetpaidProduct withMessage:requestMessage withNotificationNameOrNil:@"packagedownload"];
        }
        else
        {
            NSString *requestMessage = [[NSString alloc]initWithFormat:kXMLforFreeProduct,productID ];
            [request webRequestwithURL:kGetProductURL withMessage:requestMessage withNotificationNameOrNil:@"packagedownload"];
        }
        
        
    }
    else
    {
        [_delegate productTransactionFailed];
    }

    currProductID = productID;

}



-(void)packageDownload:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"packagedownload" object:nil];
    
    [_delegate productStatusUpdated:@"Package URL Fetched"];

    NSData *response = [[notification userInfo]objectForKey:kResponseKeyName];
    
    
    NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Response data: %@",str);
    //Code to transform NSData into String and extract
    
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:response];
	BOOL success;
	BuyProductXMLParser *parser = [[BuyProductXMLParser alloc] initBuyProductXMLParser];
	[xmlParser setDelegate:parser];
	success = [xmlParser parse];
	if(success)
	{
        NSLog(@"No Errors");
    }
	else
	{
        NSLog(@"Error Error Error!!!");
	}
    
    
	if ([parser.errorMessage isEqual:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This product does not exist"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[self.activityIndicator stopAnimating];
        [alert show];
        
    }
	else if ([parser.errorMessage isEqual:@"2"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device has reached the permissible download limit for this product."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[self.activityIndicator stopAnimating];
        [alert show];
    }
    else if ([parser.errorMessage isEqual:@"3"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Product does not exist"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//[self.activityIndicator stopAnimating];
		[alert show];
		
	}else if ([parser.errorMessage isEqual:@"4"])
	{
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@" Download limit has been reached. "  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//[self.activityIndicator stopAnimating];
		[alert show];
    }
    else if ([parser.errorMessage isEqual:@"5"])
	{
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Transaction Error!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//[self.activityIndicator stopAnimating];
		[alert show];
	}
    else
    {
        //save Active download
        //Saving download details in UserDefaults
        
        PackageListModalClass *package;
        
        for (package in marrProductItems)
        {
            if ([currProductID isEqualToString:package.strProductId])
                break;
        }
        
        ActiveDownload* objActiveDownloadModelClass = [[ActiveDownload alloc]init];
        objActiveDownloadModelClass.productID = package.strProductId;
        objActiveDownloadModelClass.productName = package.strName;
        objActiveDownloadModelClass.url = parser.url;
        objActiveDownloadModelClass.transactionID = parser.transactionId;
        objActiveDownloadModelClass.productType = package.strType;
        objActiveDownloadModelClass.urlArray = parser.urlArray;
        objActiveDownloadModelClass.urlCount = [NSString stringWithFormat:@"%d",0];
        objActiveDownloadModelClass.totalSize = parser.size;
        
        
        //get data from user defaults and save it to array
        NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
        
        NSMutableArray* activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
        
        if(activeDownLoadArray == nil)
            activeDownLoadArray = [[NSMutableArray alloc]init];
        [activeDownLoadArray addObject:objActiveDownloadModelClass];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
        
        
        globalValues_InApp.activeDownLoadBool = 1;
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *iLP_Path = [NSString stringWithFormat:@"%@/Caches", libraryPath];
        
        [self setPackageUnzipPath:iLP_Path createPathYesOrNo:NO];
        
        [_delegate productTriggerDownloadfromURL:nil];
        
        productDownloader  = [[ProductWebRequest alloc] init];
        productDownloader.delegate = self;
        productDownloader.productID = package.strProductId;
        //pr.productID =  [[notification userInfo] objectForKey:@"freeProductId"];
        productDownloader.productName = package.strName;
        productDownloader.productType = package.strType;
        productDownloader.transactionID = parser.transactionId;
        productDownloader.totalSize = parser.size;
        productDownloader.downLoadSize = [parser.size intValue]*1024;
        
        [productDownloader getAndUnZipContent:[parser.urlArray objectAtIndex:0]];
        NSLog(@"parser.urlarray : %@",[parser.urlArray objectAtIndex:0]);
        NSLog(@"self.urlpath : %@",parser.url);
        
        globalValues_InApp.activeDownLoadClicked = YES;
    }
    
    NSString *strURL = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    
    [_delegate productTriggerDownloadfromURL:strURL];
    
}

-(BOOL) setPackageUnzipPath:(NSString *)strPath createPathYesOrNo:(BOOL)createYesOrNo
{
    BOOL boolPathSet = NO;
	NSFileManager *fManager = [NSFileManager defaultManager];
	
    // CREATE DIRECTORY IF DOESN'T EXIST
	BOOL isDir;
	NSError *error = nil;
	
	NSString *directoryPath = [NSString stringWithFormat:@"%@", strPath];
	if (!([fManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir)){
        
        // CREATE DIRECTORY IF createYesOrNo = YES OR TRUE
        if (createYesOrNo){
            [fManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
            if (error != nil)
            {
                // ERROR CREATING DIRECTORY
                NSLog(@"ERROR CREATING DIRECTORY: %@", [error description]);
            }
            else{
                // DIRECTORY SUCCESSFULLY CREATED
                globalValues_InApp.strUnzipPackagePath = [[NSString alloc] initWithFormat:@"%@", directoryPath];
                boolPathSet = YES;
            }
        }
	}
    // DIRECTORY ALREADY EXISTS
	else{
		globalValues_InApp.strUnzipPackagePath = [[NSString alloc] initWithFormat:@"%@", directoryPath];
        NSLog(@"globalValues_InApp.strUnzipPackagePath = %@", globalValues_InApp.strUnzipPackagePath);
        boolPathSet = YES;
	}
    
    
    return boolPathSet;
}

-(BOOL)canAddDownload:(NSString*)productID
{
    NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
    
    NSMutableArray* activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    if ([activeDownLoadArray count])
    {
        for (ActiveDownload *currDownload in activeDownLoadArray)
        {
            NSLog(@"%@ is currently downloading", currDownload.productID);
            if ([currDownload.productID isEqualToString:productID])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Download in Progress" message:@"This package is already being downloaded!" delegate:self cancelButtonTitle:KAlertOK otherButtonTitles:@"Clear Unfinished",nil];
                [alert show];
                return NO;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Download in Progress" message:@"Another package is being downloaded at the moment. Please try again after it has finished." delegate:self cancelButtonTitle:KAlertOK otherButtonTitles:@"Clear Unfinished",nil];
        [alert show];
        return  NO;

    }
    else
    {
        return YES;
    }
}

-(void) clearUnfinishedDownloads
{
    //CANCEL DOWNLOADING REQUEST AND EMPTY MUTABLE ARRAYS
    [productDownloader cancelRequest];
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
    NSLog(@"activeD count = %d", [activeD count]);
    
    //REMOVE PARTIALLY DOWNLOADED ZIP FILES
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *iLP_Path = [[NSString alloc] init];
	iLP_Path = [NSString stringWithFormat:@"%@/Caches/", libraryPath];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:iLP_Path error:nil];
	NSArray *onlyZip = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.zip'"]];
    NSFileManager *fManager = [NSFileManager defaultManager];
    
    for (NSString *s in onlyZip)
    {
        NSMutableString *strPath = [[NSMutableString alloc] initWithString:s];
        strPath = [NSMutableString stringWithFormat:@"%@", [strPath substringToIndex:([strPath length] - 4)]];
        NSLog(@"strPath = %@", strPath);
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.zip", iLP_Path, strPath];
        NSLog(@"path = %@", path);
        [fManager removeItemAtPath:path error:NULL];
    }

}

#pragma mark PRODUCT WEB REQUEST DELEGATE

-(void)downloadCompleted
{
    
}

#pragma mark UIALERTVIEW DELEGATE METHODS

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Download in Progress"] && buttonIndex == 1)
    {
        [self clearUnfinishedDownloads];
    }
}

@end
