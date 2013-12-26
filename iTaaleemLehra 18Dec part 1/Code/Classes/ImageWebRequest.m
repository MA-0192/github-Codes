//
//  ImageWebRequest.m
//  Swissimmo
//
//  Created by iPhone Dev 2 on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageWebRequest.h"
#import "NSData+Base64.h"
#import "Reachability.h"
#import "Constants.h"
#import "ConstantInApps.h"


@implementation ImageWebRequest
@synthesize receivedData;
@synthesize strURL;
@synthesize typeOfRequest;
@synthesize responseCode;



-(void)webRequestURL:(NSString *) url ; 
{
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{		
		NSLog(@"url : %@",url);
		self.strURL = url;
		//self.typeOfRequest = requestType;
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		/*
		NSString *strCredentials = @"media:agility";
		
		NSData *dataRequest = [NSData alloc];
		dataRequest = [requestType dataUsingEncoding: NSUTF8StringEncoding];
		
		NSData *dataCredentials = [NSData alloc];
		dataCredentials = [strCredentials dataUsingEncoding: NSUTF8StringEncoding];
		
		
		NSString *encodedString = [dataCredentials base64EncodedString];
		NSLog(@"encoded string %@", encodedString);
		
		NSString *postLength=[NSString stringWithFormat:@"%d", [dataRequest length]];
		NSLog(@"post length : %@",postLength);
		
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:url]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		
		[request setHTTPBody:[requestType dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSString *str = [NSString stringWithFormat:@"Basic %@",encodedString];
		NSLog(@"%@",str);
		[request setValue:str forHTTPHeaderField:@"Authorization"];
		*/
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
		
		
		[request setHTTPMethod:@"POST"];
		
		
		
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
		
		
		
		
		//NSLog(@"url is %@",url);
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (conn)
		{
			//NSURLResponse * response = [[NSURLResponse alloc] init];
			NSMutableData *data = [[NSMutableData alloc] init];
			self.receivedData = data;
			NSLog(@"received data");
		}
		else
		{
			NSLog(@"could not retrive data");
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"aa" 
														message:@"bb"
													   delegate:nil 
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[self sendNotification];		
	}
	
	
}

-(void)sendNotification
{
	
	
		NSMutableDictionary * values;
		values = [NSMutableDictionary dictionaryWithObject:self.receivedData forKey:kResponseKey];
		[[NSNotificationCenter defaultCenter] postNotificationName:self.strURL object: self userInfo:values];
		
/*
	
	if([typeOfRequest caseInsensitiveCompare:kRequestTypeDetailImage]==0)
	{
		NSMutableDictionary * values;
		values = [NSMutableDictionary dictionaryWithObject:self.receivedData forKey:kResponseKey];
		[[NSNotificationCenter defaultCenter] postNotificationName:self.strURL object: self userInfo:values];
		
	}*/
}



#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
	 responseCode = [httpResponse statusCode];
	
	NSLog(@"Response Code : %d",responseCode);
	
	
    // Can check response code here
    [receivedData setLength:0];
	
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	NSLog(@"Error :%@",error);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    self.receivedData = nil; 
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Connection Failed"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
   // [alert show];
	
	
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
    
	//NSString *payloadAsString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
	if (responseCode == 200)
	{
	  [self sendNotification];	
	}
	else
	{
		
		NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"home-1" ofType:@"jpg"];
		NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
		self.receivedData = [NSData dataWithData:data];
		[self sendNotification];	
	}

	
	//NSLog(@"Received data: %@",self.receivedData);
    self.receivedData = nil;
	
	
}

#pragma mark Memory Management


@end
