//
//  ProductWebRequest.h
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductItem.h"
#import "ActiveDownLoadDataCell.h"
#import "NSData+Base64.h"
#import "Reachability.h"

@protocol ProductWebRequestDelegate
-(void) downloadCompleted;
@end



@class AppDelegate;
@interface ProductWebRequest : UIViewController <NSURLConnectionDelegate,UIAlertViewDelegate>
{
	NSMutableData *updatedData;
	NSMutableArray *activeDownLoadArray;
	NSString *transactionID;
	ProductItem *item;
	NSString *uniqueDeviceIdentifier;
	NSString *productID;
	NSString *productType;
	NSString *productName;
	AppDelegate *appDelegate;
	NSInteger downLoadSize;
	float updatedDownLoadSize;
	NSMutableArray *ActiveDownLoadArray;
	ActiveDownload *activeDownloadObj;
	
	NSData *activeUserDefaults;
	
	NSString *filePath;
	NSString *totalSize;
	
	
	//Array needed to add item to user defaults
	NSMutableArray *narrations;
	NSMutableArray *displayLanguages;
	NSMutableArray *beadsArray;
	NSMutableArray *malasArray;
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;
	NSMutableArray *productIDArray;
	
}
//@property(nonatomic,retain) UIView *myView;
@property (nonatomic, strong) id <ProductWebRequestDelegate> delegate;
@property(nonatomic,strong) NSMutableData *updatedData;
@property(nonatomic,strong) NSMutableArray *activeDownLoadArray;
@property(nonatomic,strong) NSString *transactionID;
@property(nonatomic,strong) ProductItem *item;
@property(nonatomic,strong) NSString *uniqueDeviceIdentifier;
@property(nonatomic,strong) NSString *productID;
@property(nonatomic,strong) NSString *productType;
@property(nonatomic)        NSInteger downLoadSize;
@property(nonatomic,strong) NSMutableArray *ActiveDownLoadArray;
@property(nonatomic,strong)	ActiveDownload *activeDownloadObj;
@property(nonatomic,strong) NSString *productName;
@property(nonatomic,strong)NSData *activeUserDefaults;
@property (nonatomic ,strong)NSString *filePath;
@property (nonatomic )float updatedDownLoadSize;
@property (nonatomic ,strong)NSString *totalSize;

@property(nonatomic,strong)NSMutableArray *narrations;
@property(nonatomic,strong)NSMutableArray *displayLanguages;
@property(nonatomic,strong)NSMutableArray *beadsArray;
@property(nonatomic,strong)NSMutableArray *malasArray;
@property(nonatomic,strong)NSMutableArray *selectedAudioSettingArray;
@property(nonatomic,strong)NSMutableArray *numberOfTimesArray;
@property(nonatomic,strong)NSMutableArray *numberOfSecondArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,strong) UIAlertView *alertClearUnfinished;

-(void)getAndUnZipContent:(NSString *)path ;
- (void)removeFromActiveDownLoad;
- (void)sendAcknowledgement;

-(void) downloadDone;
-(void) unzipInBackground;
-(void)packageUnzippingDone;
-(void) cancelRequest;

//-(void) settingUserDefaultsForNewItem;

@end
