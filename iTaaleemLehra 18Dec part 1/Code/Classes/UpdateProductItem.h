//
//  UpdateProductItem.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UpdateProductItem : NSObject 
{
	NSString *productID;
	NSString *transactionID;
	NSString *latestVersion;
	NSString *URL;
	NSMutableArray *URLArray;
	NSString *size;
	NSMutableArray *URLs;
	
	

}
@property(nonatomic,strong)	NSString *productID;
@property(nonatomic,strong)	NSString *transactionID;
@property(nonatomic,strong)	NSString *latestVersion;
@property(nonatomic,strong)	NSString *URL;
@property (nonatomic,strong)NSMutableArray *URLArray;
@property (nonatomic,strong)NSString *size;
@property (nonatomic ,strong)NSMutableArray *URLs;

@end
