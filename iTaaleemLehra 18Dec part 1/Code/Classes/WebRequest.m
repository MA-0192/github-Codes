//
//  WebRequest.m
//  PassportGourmet
//
//  Created by iPhone Dev 1 on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebRequest.h"
#import "NSData+Base64.h"


#import "Reachability.h"
#import "ProductXMLParser.h"
#import "Constants.h"
#import "BuyProductXMLParser.h"
#import "UpdateProductXMLParser.h"
#import "ConstantInApps.h"
#import "Constants_InApp.h"

@implementation WebRequest
@synthesize receivedData;
@synthesize strURL;
@synthesize productID;

-(void)webRequestURL:(NSString *) url withXMLMessage: (NSString *) requestMessage
{
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{
		self.strURL = url;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		
		NSData *dataRequest = [NSData alloc];
		dataRequest = [requestMessage dataUsingEncoding: NSUTF8StringEncoding];
		
	
		
		NSString *postLength=[NSString stringWithFormat:@"%d", [dataRequest length]];
	#ifdef DEBUG
		NSLog(@"post length : %@",postLength);
	#endif
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
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
			NSLog(@"encoded string %@", encodedString);
			NSLog(@"%@",str);
		#endif
		
		[request setValue:str forHTTPHeaderField:@"Authorization"];
		
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (conn)
		{

			NSMutableData *data = [[NSMutableData alloc] init];
			self.receivedData = data;
		#ifdef DEBUG
			NSLog(@"received data = %@",self.receivedData);
		#endif
			
		}
		else
		{
		#ifdef DEBUG
			NSLog(@"could not retrive data");
		#endif
			
		}
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet Connection not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		//return;

		if(strURL == kGetXMLURL)
		{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"productDataRetrived" object: self];
		}
		else if (strURL == kGetProductURL)
		{

		[[NSNotificationCenter defaultCenter] postNotificationName:@"freeproductDataRetrived" object: self ];
		}
		else if (strURL == kGetpaidProduct) 
		{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"paidproductDataRetrived" object: self ];	
			
		}
		else if(strURL == kgetUpdatesOfProductURL){

			[[NSNotificationCenter defaultCenter] postNotificationName:@"updateProductdataRetrived" object: self ];	

		}
	}

	
}

#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	

	
	     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
		int responseCode = [httpResponse statusCode];
		NSLog(@"Response Code : %d",responseCode);

	
    // Can check response code here
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    self.receivedData = nil; 
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Connection failed!", [error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
	if(strURL == kGetXMLURL)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"productDataRetrived" object: self];
	}
	else if (strURL == kGetProductURL)
	{
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"freeproductDataRetrived" object: self ];
	}
	else if (strURL == kGetpaidProduct) 
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"paidproductDataRetrived" object: self ];	
		
	}else if(strURL == kgetUpdatesOfProductURL){
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateProductdataRetrived" object: self ];	
		
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	

	
	
	
	   NSString *payloadAsString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
		NSLog(@"data : %@",payloadAsString);
	
	
	//payloadAsString = [payloadAsString stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    //NSLog(@"manipulated data : %@",payloadAsString);
	
 
	//NSData * manipulatedData = [NSData alloc];
	//manipulatedData = [payloadAsString dataUsingEncoding: NSUTF8StringEncoding];    
	
	
	/////////////////////////////////////////////
	//My code ---
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"responce"ofType:@"xml" ];
	
	//NSData *plistXML = [[NSFileManager defaultManager]contentsAtPath:path];
	
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self.receivedData];
	BOOL success;
	//Initialize the delegate.
	if(strURL == kGetXMLURL)
	{
		
		ProductXMLParser *parser = [[ProductXMLParser alloc] initProductXMLParser];
		[xmlParser setDelegate:parser];
		success = [xmlParser parse];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"productDataRetrived" object: self];
		if(success)
		{
			#ifdef DEBUG
				NSLog(@"No Errors");
			#endif
			
		}
		else
		{
		#ifdef DEBUG
			NSLog(@"Error Error Error!!!");
		#endif
			
		}
		
	}
	else if (strURL == kGetProductURL)
	{
		NSMutableDictionary * values;
		values = [NSMutableDictionary dictionaryWithObject:self.receivedData forKey:kResponseDictionaryKey1];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"freeproductDataRetrived" object: self userInfo:values];
		


	}else if (strURL == kGetpaidProduct) 
	{
		NSMutableDictionary * values;

		
		NSArray *array1 = [[NSArray alloc] initWithObjects:self.receivedData,self.productID,nil];
		NSArray *array2 = [[NSArray alloc] initWithObjects:kResponseDictionaryKey1,kResponseDictionaryKey2, nil];
		values = [NSMutableDictionary dictionaryWithObjects:array1 forKeys:array2];

		#ifdef DEBUG
			NSLog(@"in web request = %@",[NSString stringWithFormat:@"paidproductDataRetrived%@",self.productID]);
		#endif
		
		
		[[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"paidproductDataRetrived%@",self.productID] object: self userInfo:values];
		
	}
	if(strURL == kgetUpdatesOfProductURL)
	{
		
		UpdateProductXMLParser *parser = [[UpdateProductXMLParser alloc] initUpdateProductXMLParser];
		[xmlParser setDelegate:parser];
		success = [xmlParser parse];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateProductdataRetrived" object: self];
		if(success)
		{
			#ifdef DEBUG
				NSLog(@"No Errors");
			#endif
			
		}
		else
		{
		#ifdef DEBUG
			NSLog(@"Error Error Error!!!");
		#endif
			
		}
		  
	}

	
	
	
	////////////////////////////////////////////
	
	
    self.receivedData = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
}

#pragma mark Memory Management


@end
