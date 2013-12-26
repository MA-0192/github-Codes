//
//  WebRequest_InApp.m
//  iPadInApps
//
//  Created by User on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebRequest_InApp.h"
#import "NSData+Base64.h"
#import "Reachability.h"
#import "ConstantInApps.h"
#import "AlertConstants.h"
#import "Constants_InApp.h"

@implementation WebRequest_InApp

@synthesize receivedData = _receivedData;
@synthesize strURL = _strURL;
@synthesize strPostVariable = _strPostVariable;
@synthesize productID = _productID;
@synthesize strBundleIdFreeItemDownload;

-(void)webRequestURL:(NSString *) url withXMLMessage: (NSString *) requestMessage withPostVariable: (NSString*) postVariable
{
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{
		self.strURL = url;
		self.strPostVariable = postVariable;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		
		NSData *dataRequest = [NSData alloc];
		dataRequest = [requestMessage dataUsingEncoding: NSUTF8StringEncoding];
		
		
		
		NSString *postLength=[NSString stringWithFormat:@"%d", [dataRequest length]];
#ifdef DEBUG
		MyLog(@"post length : %@",postLength);
#endif
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:[requestMessage dataUsingEncoding:NSUTF8StringEncoding]];
		
        // Developer Authentication
		NSString *strCredentials = kDeveloperAuthenticationKey;
		NSData *dataCredentials = [NSData alloc];
		dataCredentials = [strCredentials dataUsingEncoding: NSUTF8StringEncoding];
		NSString *encodedString = [dataCredentials base64EncodedString];
		
		
		NSString *str = [NSString stringWithFormat:@"Basic %@",encodedString];
		
		
#ifdef DEBUG
		MyLog(@"encoded string %@", encodedString);
		MyLog(@"%@",str);
#endif
		
		[request setValue:str forHTTPHeaderField:@"Authorization"];
		
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (conn)
		{
			
			NSMutableData *data = [[NSMutableData alloc] init];
			self.receivedData = data;
#ifdef DEBUG
			MyLog(@"received data = %@",self.receivedData);
#endif
			
		}
		else
		{
#ifdef DEBUG
			MyLog(@"could not retrive data");
#endif
			
		}
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTitleNoNetworkAvailable message:kAlertViewMessageForNoNetwork delegate:nil cancelButtonTitle:kAlertViewButtonOk otherButtonTitles:nil];
		[alert show];        //return;
		
        //		if(strURL == kGetXMLURL)
        //		{
        //			[[NSNotificationCenter defaultCenter] postNotificationName:@"productDataRetrived" object: self];
        //		}
        if (self.strURL == kGetProductURL)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freeproductDataRetrived" object: self ];
        }
        else if (self.strURL == kGetpaidProduct) 
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"paidproductDataRetrived" object: self ];	
			
		}
        //		else if(strURL == kgetUpdatesOfProductURL){
        //			
        //			[[NSNotificationCenter defaultCenter] postNotificationName:@"updateProductdataRetrived" object: self ];	
        //			
        //		}
		[self sendNotification];
	}
}



-(void)sendNotification
{
	/*
	 if(strURL == kSearchURL)
	 [[NSNotificationCenter defaultCenter] postNotificationName:@"searchDataRetrived" object: self];
	 if([strURL caseInsensitiveCompare:kSearchLocationURL]==0)
	 [[NSNotificationCenter defaultCenter] postNotificationName:@"locationDataRetrived" object: self];
	 */
	if ([self.strURL length] > 1)
    {
		MyLog(@"sendNotification of WebRequest.m strURL = %@, strPostVariable = %@", self.strURL, self.strPostVariable);
		if([self.strURL caseInsensitiveCompare:kURL_ProductListFromServer]==0 && [self.strPostVariable caseInsensitiveCompare:kPV_ProductListFromServer]==0)
		{
			NSMutableDictionary * values;
			values = [NSMutableDictionary dictionaryWithObject:self.receivedData forKey:kResponseKey];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"productListFromServerRetrived" object: self userInfo:values];
            
			
		}
        else if([self.strURL caseInsensitiveCompare:kGetProductURL]==0 && [self.strPostVariable caseInsensitiveCompare:kPV_getFreeProductDetailsFromServer]==0)
        {
            NSMutableDictionary * values;
            values = [NSMutableDictionary dictionaryWithObject:self.receivedData forKey:kResponseDictionaryKey1];
            //[values setObject:self.productID forKey:@"freeProductId"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freeproductDataRetrived" object: self userInfo:values];
        }
        else if([self.strURL caseInsensitiveCompare:kGetpaidProduct]==0 && [self.strPostVariable caseInsensitiveCompare:kPV_getPaidProductDetailsFromAppStore]==0)
        {
            NSMutableDictionary * values;
            
            
            NSArray *array1 = [[NSArray alloc] initWithObjects:self.receivedData,self.productID,nil];
            NSArray *array2 = [[NSArray alloc] initWithObjects:kResponseDictionaryKey1,kResponseDictionaryKey2, nil];
            values = [NSMutableDictionary dictionaryWithObjects:array1 forKeys:array2];
            
            MyLog(@"in web request = %@",[NSString stringWithFormat:@"paidproductDataRetrived%@",self.productID]);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"paidproductDataRetrived%@",self.productID] object: self userInfo:values];
        }
        
        else if([self.strURL caseInsensitiveCompare:kGetpaidProduct]==0 && [self.strPostVariable caseInsensitiveCompare:kPV_getAudioPackageFromServer]==0)
        {
            NSMutableDictionary * values;
            
            
            NSArray *array1 = [[NSArray alloc] initWithObjects:self.receivedData,self.productID,nil];
            NSArray *array2 = [[NSArray alloc] initWithObjects:kResponseDictionaryKey1,kResponseDictionaryKey2, nil];
            values = [NSMutableDictionary dictionaryWithObjects:array1 forKeys:array2];
            
            //MyLog(@"in web request = %@",[NSString stringWithFormat:@"paidproductDataRetrived%@",self.productID]);
            
            
            MyLog(@"NOTI = %@", [NSString stringWithFormat:@"audioDataRetrieved%@",self.productID]);
            
            
            MyLog(@"productId = %@",self.productID);
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"audioDataRetrieved%@",self.productID] object: self userInfo:values];
        }

		
	}
	
}

#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
//	int responseCode = [httpResponse statusCode];
//	MyLog(@"Response Code : %d",responseCode);
    // Can check response code here
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    self.receivedData = nil; 
    
	MyLog(@"Webrequest didFailWithError and sending back Notification");
	if([self.strURL caseInsensitiveCompare:kURL_ProductListFromServer]==0 && [self.strPostVariable caseInsensitiveCompare:kPV_ProductListFromServer]==0)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"productListFromServerRetrived" object: self ];
    
	else if (self.strURL == kGetpaidProduct) 
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"paidproductDataRetrived" object: self ];	
    }
    
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
    
	NSString *payloadAsString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	MyLog(@"data :%@",payloadAsString);
    
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	
	[self sendNotification];
}



@end

