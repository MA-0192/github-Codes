//
//  MAInAppWebRequest.h
//  LDSAT
//
//  Created by Akash Gupta on 5/1/13.
//  Copyright (c) 2013 MediaAgility. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MAWebRequestDelegate

@optional
- (void)webRequestResponseReceived: (NSData*)response;
- (void)webRequestDidFail;

@end

@interface MAWebRequest : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *strURL;
@property (strong, nonatomic) NSString *strNotificationName;

@property BOOL silent;
@property BOOL isImage;
@property (strong, nonatomic) id <MAWebRequestDelegate> delegate;


//For web request -> URL, Message are mandatory
//NotificationName can be nil if you want to use delegate
-(void)webRequestwithURL:(NSString *)url withMessage:(NSString *)requestMessage  withNotificationNameOrNil:(NSString*)notificationName;

@end
