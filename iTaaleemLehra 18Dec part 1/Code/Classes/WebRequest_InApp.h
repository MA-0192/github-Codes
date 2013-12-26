//
//  WebRequest_InApp.h
//  iPadInApps
//
//  Created by User on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequest_InApp : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *strURL;
@property (strong, nonatomic) NSString *strPostVariable;
@property (strong, nonatomic) NSString *productID;

@property (nonatomic,strong) NSString                    *strBundleIdFreeItemDownload;

-(void)webRequestURL:(NSString *) url withXMLMessage: (NSString *) requestMessage withPostVariable: (NSString*) postVariable;
-(void)sendNotification;


@end
