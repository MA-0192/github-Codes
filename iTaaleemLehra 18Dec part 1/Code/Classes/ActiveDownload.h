//
//  ActiveDownload.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActiveDownload : NSObject 
{
	NSString *transactionID;
 	NSString *productID;
    NSString *productName;
    NSString *url;
	NSString *productType;
	NSArray *urlArray;
	NSString *urlCount;
	
	NSString *totalSize;
	NSString *downloadeSize;

}
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic ,strong) NSArray *urlArray;
@property (nonatomic ,strong) NSString *urlCount;
@property (nonatomic, strong) NSString *totalSize;
@property (nonatomic, strong) NSString *downloadeSize;
@end
