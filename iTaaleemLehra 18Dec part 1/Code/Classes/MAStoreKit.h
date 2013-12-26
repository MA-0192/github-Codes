//
//  MAStoreKit.h
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol MAStoreKitDelegate

@optional
-(void)storeDidRetrieveDetailsFromAppStore:(NSArray*)arrProductList;
-(void)storeDidCompletePurchase:(NSString*)productID;
-(void)storeDidApproveRestore:(NSString*)restorableProductID;
-(void)storePurchaseFailed:(NSString*)productID;
-(void)storeDidUpdateMessage:(NSString*)message;
@end

@interface MAStoreKit : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>
{
    NSMutableArray *marrProductList; //Used to maintain list of SKProduct elements
    BOOL _bProdListReturnRequired;  //Used to check whether product details are needed to be sent back to delegate;
    NSString *currentProductID;     //used to keep track of current transaction
    MAStoreKit *sharedInstance;     //used to refer to shared instance
}

@property (strong, nonatomic) id <MAStoreKitDelegate> delegate;


+(MAStoreKit*)sharedInstance;

//Get product details from app store
-(void)getProductDetailsFromAppStore:(NSArray*)arrProductID;

//Purchase product with productID
-(void)buyProduct: (NSString*)strProductID;

//restore product with productID
-(void)restoreProduct: (NSString*)strProductID;

@end
