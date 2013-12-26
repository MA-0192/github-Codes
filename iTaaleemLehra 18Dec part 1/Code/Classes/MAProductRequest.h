//
//  MAProductRequest.h
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAWebRequest.h"
#import "MAStoreKit.h"
#import "PackageListModalClass.h"
#import "ProductWebRequest.h"



@protocol MAProductRequestDelegate 

@optional

-(void)productListRetrieved:(NSArray*)arrProductList;
-(void)productDetailsFromAppStoreRetrieved:(NSDictionary*)productDetails;

-(void)productPurchased:(NSString*)productID;
-(void)productRestored:(NSString*)productID;
-(void)productTransactionFailed;

-(void)productStatusUpdated:(NSString*)message;

-(void)productTriggerDownloadfromURL:(NSString*)URL;

@end

@interface MAProductRequest : NSObject <MAStoreKitDelegate, ProductWebRequestDelegate, UIAlertViewDelegate>
{
    MAStoreKit *store;
    NSMutableArray *marrProductItems;
}

@property (strong, nonatomic) id <MAProductRequestDelegate> delegate;


+(id)sharedInstance;


//To get list of downloadable products from server
//Implement delegate function productListRetrieved
-(void)fetchProductListFromServer;

//For getting details of product(s) from app store
//Implement delegate function productDetailsFromAppStoreRetrieved 
-(void)fetchProductDetailsFromAppStore:(NSString*)product andType:(NSString*)type;

//For product transactions

-(void)buyProductWithID:(NSString *)productID andType:(NSString*)type;

-(void)restoreProductWithID:(NSString*)productID;

//Fetching URL of product and triggering download
//Requires callback from delegate -> productPurchased/productRestored
//Returns to delegate method productTriggerDownloadfromURL
-(void)fetchDownloadURLforProduct:(NSString*)productID;

-(void)clearUnfinishedDownloads;

@end
