//
//  MAInAppWebRequest.m
//  LDSAT
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//

#import "MAWebRequest.h"
#import "Reachability.h"
#import "Constants_InApp.h"
#import "Constants.h"
#import "AlertConstants.h"


@implementation MAWebRequest

@synthesize receivedData = _receivedData;
@synthesize strURL = _strURL;
@synthesize strNotificationName;
@synthesize delegate = _delegate;
@synthesize silent, isImage;

-(id)init
{
    if (self = [super init])
    {
        
    }
    
    self.receivedData = [[NSMutableData alloc]init];
    self.silent = NO;
    self.isImage = NO;
    return self;
    
}

-(void)setDelegate:(id<MAWebRequestDelegate>)delegate
{
    _delegate = delegate;
}

-(void)webRequestwithURL:(NSString *)url withMessage:(NSString *)requestMessage  withNotificationNameOrNil:(NSString*)notificationName
{
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable)
	{
		self.strURL = url;
        self.strNotificationName = notificationName;
        self.receivedData = [[NSMutableData alloc]init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
        
        if (self.isImage)
            [request setHTTPMethod:@"GET"];
        else
            [request setHTTPMethod:@"POST"];
        
        if (requestMessage != nil)
        {
            
            NSData *dataRequest = [NSData alloc];
            dataRequest = [requestMessage dataUsingEncoding: NSUTF8StringEncoding];
            NSString *postLength=[NSString stringWithFormat:@"%d", [dataRequest length]];
            NSLog(@"post length : %@",postLength);
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:dataRequest];
        }
        else
        {
            NSLog(@"message is nil");
        }
        
		
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		[conn start];
        
	}
	else
	{
        if (!self.silent)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OK" message:@"No Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
		}
        
        if (notificationName == nil)
            [_delegate webRequestDidFail];
        else
            [self sendNotification:notificationName withData:nil];
        
	}
}

-(void)sendNotification:(NSString*)notificationName withData:(NSData*)data
{
   
    
    NSMutableDictionary * values;
    
    NSLog(@"%@",data);
    
    values = [NSMutableDictionary dictionaryWithObject:data forKey:kResponseKeyName];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object: self userInfo:values];
    
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connected");
    self.receivedData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
    NSString *payloadAsString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"received data %@", data);
    NSLog(@"PAYLOAD STRING %@",payloadAsString);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.receivedData = nil;
	
	NSLog(@"Webrequest didFailWithError, calling back with nil");
    
    if (self.strNotificationName == nil)
        [_delegate webRequestDidFail];
    else
        [self sendNotification:self.strNotificationName withData:nil];
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectioncomplete");
		
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    if (self.strNotificationName == nil)
        [_delegate webRequestResponseReceived:self.receivedData];
    else
        [self sendNotification:self.strNotificationName withData:self.receivedData];
	
}


-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Authentication challenge");
    
    NSURLCredential *newCredential;
    
    /*if ([[[[connection currentRequest]URL]absoluteString] hasPrefix:kMAPromotionalAdPrefix])
    {
        newCredential = [NSURLCredential credentialWithUser:kUserNameMAPromotionalAds
                                                   password:kUserPasswordMAPromotionalAds
                                                persistence:NSURLCredentialPersistenceNone];
        
    }
    else
    {*/
        newCredential = [NSURLCredential credentialWithUser:kDeveloperAuthenticationID
                                                   password:kDeveloperAuthenticationPassword
                                                persistence:NSURLCredentialPersistenceNone];
    //}
    
    [[challenge sender] useCredential:newCredential
           forAuthenticationChallenge:challenge];
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"can authenticate");
    return YES;
}


@end
