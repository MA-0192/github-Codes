//
//  AudioWebRequest.h
//  iCityPediaUniversal
//
//  Created by Gopesh Kumar Gupta on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import "ActiveDownload.h"
#import "ProductItem.h"

@interface AudioWebRequest : NSObject<NSURLConnectionDelegate>{
    NSMutableData *updatedData;
	NSMutableArray *activeDownLoadArray;
	NSString *transactionID;
	ProductItem *item;
	NSString *uniqueDeviceIdentifier;
	NSString *productID;
	NSString *productType;
	NSString *productName;
	//AppDelegate *appDelegate;
	NSInteger downLoadSize;
	float updatedDownLoadSize;
	NSMutableArray *ActiveDownLoadArray;
	ActiveDownload *activeDownloadObj;
	
	NSData *activeUserDefaults;
	
	NSString *filePath;
	NSString *totalSize;
}

//@property(nonatomic,retain) UIView *myView;
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
@property(nonatomic,strong)NSURLConnection *connection;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic,retain) UIAlertView *alertClearUnfinished;

-(void)getAndUnZipContent:(NSString *)path ;
- (void)removeFromActiveDownLoad;
- (void)sendAcknowledgement;

-(void) downloadDone;
-(void) unzipInBackground;

-(void) cancelRequest;
-(void)packageUnzippingDone;

@end
