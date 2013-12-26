//
//  ProductItem.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProductItem : NSObject 
{
	NSString *productID;
	NSString *type;
	NSString *name;
	NSString *description;
    NSString *iconImage;
	NSString *installStatus;
}
@property(nonatomic,strong)  NSString *iconImage;
@property(nonatomic,strong)NSString *productID;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *installStatus;

@end
