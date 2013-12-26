//
//  MAStoreKit.m
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//
/*
NOTES
-REMEMBER to change URL for receipt verification to https://buy.itunes.apple.com/verifyReceipt before release.
-SANDBOX URL for receipt verification: https://sandbox.itunes.apple.com/verifyReceipt
*/


#import "MAStoreKit.h"
#import "MAWebRequest.h"
#import "Constants_InApp.h"

@implementation MAStoreKit

@synthesize delegate = _delegate;

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        marrProductList = [[NSMutableArray alloc]init];
        _bProdListReturnRequired = NO;
    }
    return self;

}

+(MAStoreKit *)sharedInstance
{
    static MAStoreKit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark INTERFACE METHODS

-(void)getProductDetailsFromAppStore: (NSArray*)arrProductID
{
    NSLog(@"getting product details from apple, arr = %@", arrProductID);
    NSMutableSet *setProducts = [[NSMutableSet alloc]initWithArray:arrProductID];
    _bProdListReturnRequired = YES; //To return details to delegate
    [_delegate storeDidUpdateMessage:@"Contacting App Store"];
    [self getProductDetails:setProducts];
}

-(void)buyProduct:(NSString *)strProductID
{
    [_delegate storeDidUpdateMessage:@"Sending purchase request"];
    currentProductID = strProductID;
    if ([SKPaymentQueue canMakePayments])
    {
        SKProduct *product;
        for (product in marrProductList)
        {
            if ([[product productIdentifier]isEqualToString:strProductID])
                break;
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        SKPayment *newPayment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:newPayment];
    }
    else
    {
        [self showPaymentDisabledAlert];
    }
}

-(void)restoreProduct:(NSString *)strProductID
{
    [_delegate storeDidUpdateMessage:@"Sending request for restore"];
    currentProductID = strProductID;
    if ([SKPaymentQueue canMakePayments])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    else
    {
        [self showPaymentDisabledAlert];
    }
}

#pragma mark SKPRODUCTSREQUEST DELEGATE METHOD

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [_delegate storeDidUpdateMessage:@"Receiving details"];
    NSLog(@"In didReceiveResponse from store");
    
	NSMutableArray *purchasableObjects = [[NSMutableArray alloc] init];
	[purchasableObjects addObjectsFromArray:response.products];
    
	NSLog(@"PURCHASABLE %d",[purchasableObjects count]);
	NSLog(@"Purchasable: %@", purchasableObjects);
	NSLog(@"Invalid Product Identifiers: %@", response.invalidProductIdentifiers);
    
    for(SKProduct *product in purchasableObjects) //for logging purpose, can be removed
	{
		NSLog(@"MA Feature: %@, Cost: %f, ID: %@, Desc: %@",[product localizedTitle],
              [[product price] doubleValue], [product productIdentifier], [product localizedDescription]);
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        NSLog(@"Localized price: %@", formattedString);
	}
    
    [self syncProductList:purchasableObjects];
    
    if (_bProdListReturnRequired)
    {
        _bProdListReturnRequired = FALSE;
        NSMutableArray *arrProducts = [[NSMutableArray alloc]init];
        for (SKProduct *product in purchasableObjects)
        {
            NSMutableDictionary *dicProduct = [[NSMutableDictionary alloc]init];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:product.priceLocale];
            NSString *formattedString = [numberFormatter stringFromNumber:product.price];
            
            [dicProduct setObject:[product productIdentifier] forKey:kProductIDKey];
            [dicProduct setObject:[product localizedTitle] forKey:kProductNameKey];
            [dicProduct setObject:[product localizedDescription] forKey:kProductDescriptionKey];
            [dicProduct setObject:kProductTypePaid forKey:kProductTypeKey];
            [dicProduct setObject:formattedString forKey:kProductPriceKey];
            
            [arrProducts addObject:dicProduct];
        }
        [_delegate storeDidRetrieveDetailsFromAppStore:arrProducts];
    }
}

#pragma mark PAYMENT OBSERVER METHODS
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"transaction updated");
    NSMutableArray *restoredTransactions = [[NSMutableArray alloc]init];
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"Updated for %@", transaction.payment.productIdentifier);
        NSLog(@"transactionstate: %d", transaction.transactionState);
        switch (transaction.transactionState)
        {
                NSLog(@"checking");
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [restoredTransactions addObject:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                [_delegate storeDidUpdateMessage:@"Processing purchase"];
                NSLog(@"purchasing");
                break;
            default:
                break;
        }
    }
    
    if ([restoredTransactions count] > 0)
    {
        [self restoreTransaction:restoredTransactions];
    }
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self showFailedTransactionAlert];
    [_delegate storePurchaseFailed:currentProductID];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"Restore completed transactions finished");
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"transaction(s) removed");
}


#pragma mark INTERNAL METHODS
-(void)getProductDetails:(NSSet*)setProducts
{
    NSLog(@"initialising request");
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:setProducts];
    productsRequest.delegate = self;
    [productsRequest start];
    NSLog(@"request sent");
}

-(void)syncProductList: (NSArray*)newProductList;
{
    NSLog(@"syncing...");
    SKProduct *existingProduct;
    BOOL _bAlreadyExists = FALSE;
    int i;
    
    for (SKProduct *newProduct in newProductList)
    {
        for (i = 0; i < [marrProductList count]; i++)
        {
            existingProduct = [marrProductList objectAtIndex:i];
            if ([[newProduct productIdentifier] isEqualToString:[existingProduct productIdentifier]])
            {
                NSLog(@"product already exists");
                _bAlreadyExists = TRUE;
                break;
            }
        }
        
        if (_bAlreadyExists)
        {
            [marrProductList replaceObjectAtIndex:i withObject:newProduct];
            _bAlreadyExists = FALSE;
        }
        else
            [marrProductList addObject:newProduct];
        
    }
    
    NSLog(@"Synced product list: %@", marrProductList);
    for(SKProduct *product in marrProductList) //for logging, can be removed
	{
		NSLog(@"MA Feature: %@, Cost: %f, ID: %@, Desc: %@",[product localizedTitle],
              [[product price] doubleValue], [product productIdentifier], [product localizedDescription]);
	}
}

-(void)showPaymentDisabledAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"In-App Purchase Disabled" message:@"Please check your parental control settings." delegate:nil cancelButtonTitle:KAlertOK otherButtonTitles:nil];
    [alert show];
}

-(void)showFailedTransactionAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cannot Complete Purchase" message:@"We could not complete the purchase process. Please try again later." delegate:nil cancelButtonTitle:KAlertOK otherButtonTitles:nil];
    [alert show];
}


-(void)completeTransaction: (SKPaymentTransaction *)transaction
{
    [_delegate storeDidUpdateMessage:@"Purchase successful"];
    
    currentProductID = transaction.payment.productIdentifier;
    
    
//    [_delegate storeDidCompletePurchase:currentProductID];
    [self verifyReceipt:transaction];
    
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

-(void)restoreTransaction: (NSArray *)transactions
{
    NSLog(@"%d transactions received to update", [transactions count]);
    BOOL _bProductFoundInList = FALSE;
    SKPaymentTransaction *transaction;
    
    
    if ([transactions count] > 0)
    {
        for (transaction in transactions)
        {
            if ([currentProductID isEqualToString:transaction.payment.productIdentifier])
            {
                _bProductFoundInList = TRUE;
                break;
            }
        }
    }
    
        
    if (_bProductFoundInList)
    {
        [_delegate storeDidUpdateMessage:@"Restore approved"];
        [_delegate storeDidApproveRestore:transaction.payment.productIdentifier];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Product Not Purchased" message:@"Only those products which have already been purchased can be restored. Please buy this product." delegate:nil cancelButtonTitle:KAlertOK otherButtonTitles: nil];
        [alert show];
        [_delegate storePurchaseFailed:currentProductID];
    }
    
    for (transaction in transactions)
    {
        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    }
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

-(void)failedTransaction: (SKPaymentTransaction *)transaction
{
    [_delegate storeDidUpdateMessage:@"Transaction failed"];
    [self showFailedTransactionAlert];
    [_delegate storePurchaseFailed:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}


#pragma mark RECEIPT VERIFICATION
-(void)verifyReceipt:(SKPaymentTransaction*)transaction
{
    NSLog(@"verifying receipt for: %@", transaction.payment.productIdentifier);
    [_delegate storeDidUpdateMessage:@"Verifying receipt"];
    
    MAWebRequest *request = [[MAWebRequest alloc]init];
    
    NSString *jsonObjectString = [self encodeBase64:(uint8_t *)transaction.transactionReceipt.bytes
                                             length:transaction.transactionReceipt.length];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}",
                         jsonObjectString];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verificationResponse:) name:@"responsefromverification" object:request];
    
    [request webRequestwithURL:kURLforAppStoreReceiptVerification withMessage:payload withNotificationNameOrNil:@"responsefromverification"];
}

-(void)verificationResponse:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"responsefromverification" object:nil];
    NSData *responseData = [[notification userInfo] objectForKey:kResponseKeyName];
        
    NSDictionary *verifiedReceiptDictionary = [self dictionaryFromJSONData:responseData];
    
    NSLog(@"receipt dictionary: %@", verifiedReceiptDictionary);
    
    int verified =  [[verifiedReceiptDictionary objectForKey:@"status"]integerValue];

    if (verified == 0) 
    {
        NSLog(@"verification successful");
        [_delegate storeDidUpdateMessage:@"Transaction verified"];
        [_delegate storeDidCompletePurchase:currentProductID];
    }
    else
    {
        NSLog(@"receipt cannot be verified");
        [_delegate storeDidUpdateMessage:@"Invalid transaction"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertTitleVerificationInvalid message:kAlertMessageVerificationInvalid delegate:nil cancelButtonTitle:KAlertOK otherButtonTitles:nil];
        [alert show];
        [_delegate storePurchaseFailed:currentProductID];
    }
}


- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSDictionary *)dictionaryFromJSONData:(NSData *)data
{
    NSError *error;
    NSDictionary *dictionaryParsed = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
    if (!dictionaryParsed)
    {
        if (error)
        {
            NSLog(@"Error parsing dictinary");
        }
        return nil;
    }
    return dictionaryParsed;
}



@end