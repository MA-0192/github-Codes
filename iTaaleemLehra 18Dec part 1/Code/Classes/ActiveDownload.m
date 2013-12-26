//
//  ActiveDownload.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActiveDownload.h"


@implementation ActiveDownload

@synthesize transactionID;
@synthesize productID;
@synthesize productName;
@synthesize url;
@synthesize productType;
@synthesize urlArray;
@synthesize urlCount;
@synthesize totalSize;
@synthesize downloadeSize;


-(void)encodeWithCoder:(NSCoder *)encoder

{
	[encoder encodeObject:transactionID forKey:@"transactionID"];
	[encoder encodeObject:productID forKey:@"productID"];
	[encoder encodeObject:productName forKey:@"productName"];
	[encoder encodeObject:url forKey:@"url"]; 
	[encoder encodeObject:productType forKey:@"productType"];
	[encoder encodeObject:urlArray forKey:@"urlArray"];
	[encoder encodeObject:urlCount forKey:@"urlCount"];
	[encoder encodeObject:totalSize forKey:@"totalSize"];
}

-(id)initWithCoder:(NSCoder *)decoder

{ 
	self.transactionID = [decoder decodeObjectForKey:@"transactionID"];
	self.productID = [decoder decodeObjectForKey:@"productID"];
	self.productName = [decoder decodeObjectForKey:@"productName"]; 
	self.url = [decoder decodeObjectForKey:@"url"]; 
	self.productType = [decoder decodeObjectForKey:@"productType"];
	self.urlArray = [decoder decodeObjectForKey:@"urlArray"];
	self.urlCount = [decoder decodeObjectForKey:@"urlCount"];
	self.totalSize = [decoder decodeObjectForKey:@"totalSize"];
    return self;
}

@end

