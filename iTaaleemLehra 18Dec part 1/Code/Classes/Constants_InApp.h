//
//  Constants_InApp.h
//
//  Created by Akash Gupta on 4/30/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//


//WEB SERVER REQUEST URLs
//Add or modify your URLs here

//Sandbox
/*#define kGetXMLURL @"http://inapp.mediaagility.com/api/getproducts.php"
#define kURL_ProductListFromServer @"http://inapp.mediaagility.com/api/getproducts.php"
#define kGetProductURL @"http://inapp.mediaagility.com/api/buyfreeproducts.php"
#define kfreeAcknowledgementURL @"http://inapp.mediaagility.com/api/acknowledgementfreeproduct.php"
#define kGetpaidProduct @"http://inapp.mediaagility.com/api/buypaidproduct.php"
#define kpaidAcknowledgementURL @"http://inapp.mediaagility.com/api/acknowledgementpaidproduct.php"
#define kgetUpdatesOfProductURL @"http://inapp.mediaagility.com/api/upgradeProducts.php"
#define kgetUpdatesAcknowledgementURL @"http://inapp.mediaagility.com/api/acknowledgementProduct.php"*/

//Production
#define kGetXMLURL @"http://inapp.zenagestudios.com/api/getproducts.php"
#define kURL_ProductListFromServer @"http://inapp.zenagestudios.com/api/getproducts.php"
#define kGetProductURL @"http://inapp.zenagestudios.com/api/buyfreeproducts.php"
#define kfreeAcknowledgementURL @"http://inapp.zenagestudios.com/api/acknowledgementfreeproduct.php"
#define kGetpaidProduct @"http://inapp.zenagestudios.com/api/buypaidproduct.php"
#define kpaidAcknowledgementURL @"http://inapp.zenagestudios.com/api/acknowledgementpaidproduct.php"
#define kgetUpdatesOfProductURL @"http://inapp.zenagestudios.com/api/upgradeProducts.php"
#define kgetUpdatesAcknowledgementURL @"http://inapp.zenagestudios.com/api/acknowledgementProduct.php"


#define kURLforPackageDownload @""

//Transaction receipt Verification URL
//#define kURLforAppStoreReceiptVerification @"https://buy.itunes.apple.com/verifyReceipt" //Production
#define kURLforAppStoreReceiptVerification @"https://sandbox.itunes.apple.com/verifyReceipt" //Sandbox


//WEB SERVER REQUEST XML MESSAGES
//Add or modify your XML body content here
#define kXMLForProductList @"productRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><requestProduct><bundleID>%@</bundleID><platform>iphone</platform></requestProduct>"
#define kXMLforFreeProduct @"buyFreeProductRequest=<?xml version=\"1.0\" encoding=\"UTF-8\"?><buyProduct><productID>%@</productID></buyProduct>"
#define kXMLforProductDownload @"platform=iphone&productid=%@&purchasestatus=1"

//AUTHENTICATION KEYS
//Add or modify authentication keys here
#define kDeveloperAuthenticationKey @"mediaagility:m0d10ag1l1ty"
#define kDeveloperAuthenticationID @"mediaagility"
#define kDeveloperAuthenticationPassword @"m0d10ag1l1ty"



//POST VARIABLES
#define kPV_ProductListFromServer @"Product List From Server POST VARIABLE REQUEST"
///////////FREE PRODUCT
#define kPV_getFreeProductDetailsFromServer @"Free Product"

///////PAID PRODUCT
#define kPV_getPaidProductDetailsFromAppStore @"Paid Product"

///FREE ACKNOWLEDGEMENT URL
#define kPV_freeAcknowledgementURL @"Free Acknowledgement"

////////PAID ACKNOWLEDGEMENT URL
#define kPV_paidAcknowledgementURL @"Paid Acknowledgement"

////////UPDATES ACK URL
#define kPV_getUpdatesAcknowledgementURl @"Update Acknowledgement"
#define kPV_getAudioPackageFromServer @"Audio Package"




//KEY TAGS FOR DICTIONARIES
#define kResponseKeyName @"response"  //Key name required for accessing NSNotification data
#define kProductIDKey @"productID"  //key name for accessing product id
#define kProductNameKey @"productName"
#define kProductDescriptionKey @"productDesc"
#define kProductPriceKey @"productPrice"
#define kResponseKey @"kResponseKey"
#define kResponseDictionaryKey1 @"kResponseKey1"
#define kResponseDictionaryKey2 @"kResponseKey2"
#define kuserDefKeyForActiveDownLoad @"kuserDefKeyForActiveDownLoad"
#define kProductTypeKey @"productType"


//BUNDLE IDENTIFIERS
//Add or modify your bundle identifiers here
#define kDefaultBundleID @"com.zenagestudios.itaaleemlehra"


//ALERTVIEW TITLES AND MESSAGES

#define KAlertOK @"OK"

#define kAlertTitleVerificationInvalid @"Invalid Transaction"
#define kAlertMessageVerificationInvalid @"This transaction is invalid. Please try again."


//PRODUCT TYPE IDENTIFIERS
#define kProductTypePaid @"p"
#define kProductTypeSample @"s"
#define kProductTypeConsumable @"c"
