//
//  ProductItem.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProductItem.h"


@implementation ProductItem

@synthesize productID;
@synthesize type;
@synthesize description;
@synthesize name;
@synthesize iconImage;
@synthesize installStatus;

-(void)encodeWithCoder:(NSCoder *)encoder

{
	[encoder encodeObject:productID forKey:@"transactionID"];
	[encoder encodeObject:type forKey:@"productID"];
	[encoder encodeObject:description forKey:@"productName"];
	[encoder encodeObject:name forKey:@"url"]; 
	[encoder encodeObject:iconImage forKey:@"iconImage"];
    [encoder encodeObject:installStatus forKey:@"installStatus"];
}

-(id)initWithCoder:(NSCoder *)decoder

{ 
	self.productID = [decoder decodeObjectForKey:@"transactionID"];
	self.type = [decoder decodeObjectForKey:@"productID"];
	self.description = [decoder decodeObjectForKey:@"productName"]; 
	self.name = [decoder decodeObjectForKey:@"url"]; 
	self.iconImage = [decoder decodeObjectForKey:@"iconImage"];
    self.installStatus = [decoder decodeObjectForKey:@"installStatus"];
    return self;
}



@end
