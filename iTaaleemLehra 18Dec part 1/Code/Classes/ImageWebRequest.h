//
//  ImageWebRequest.h
//  Swissimmo
//
//  Created by iPhone Dev 2 on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageWebRequest : NSObject 
{
	NSMutableData *receivedData;
	NSString *strURL;
	NSString *typeOfRequest;
	
	NSInteger responseCode;
}

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString * strURL;
@property (nonatomic, strong) NSString *typeOfRequest;
@property (nonatomic) NSInteger responseCode;


-(void)webRequestURL:(NSString *) url ;
-(void)sendNotification;

@end
