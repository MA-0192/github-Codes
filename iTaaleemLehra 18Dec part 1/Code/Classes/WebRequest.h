//
//  WebRequest.h
//  PassportGourmet
//
//  Created by iPhone Dev 1 on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebRequest : NSObject 
{
	NSMutableData *receivedData;
	NSString * strURL;
	NSString *productID;

}
@property (nonatomic, strong)	NSString *productID;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString * strURL;

-(void)webRequestURL:(NSString *) url withXMLMessage: (NSString *) requestMessage;

@end
