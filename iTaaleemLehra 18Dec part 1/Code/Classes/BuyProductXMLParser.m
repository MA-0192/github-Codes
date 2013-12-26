//
//  BuyProductXMLParser.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BuyProductXMLParser.h"


@implementation BuyProductXMLParser
@synthesize currentElementValue,currentCategory;
@synthesize transactionId;
@synthesize url;
@synthesize errorMessage;
@synthesize size;
@synthesize productName;
@synthesize  urlArray;
@synthesize errorHasOcuured;
- (BuyProductXMLParser *) initBuyProductXMLParser
{
	
	if (!(self = [super init])) return nil;
	
	//appDelegate = (iPoojaAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.productArray = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
	
	
	if([elementName caseInsensitiveCompare:@"buyProduct"]==0)
	{
		return;
	}
	
	else if ([elementName caseInsensitiveCompare:@"transactionID"]==0)
	{
		self.transactionId = [[NSString alloc]init];
	}
	else if([elementName caseInsensitiveCompare:@"url"]==0)
	{
		//self.url = [[NSString alloc]init];
		self.urlArray = [[NSMutableArray alloc] init];
		//appDelegate.productArray = [[NSMutableArray alloc]init];
		//oProductItem = [[ProductItem alloc] init];
		//NSLog(@"oProduct item = %@",oProductItem);
	}else if([elementName caseInsensitiveCompare:@"errMessage"]==0)
	{
		self.errorMessage = [[NSString alloc]init];
		//appDelegate.productArray = [[NSMutableArray alloc]init];
		//oProductItem = [[ProductItem alloc] init];
		//NSLog(@"oProduct item = %@",oProductItem);
	}else if([elementName caseInsensitiveCompare:@"size"]==0)
	{
		self.size = [[NSString alloc]init];
		//appDelegate.productArray = [[NSMutableArray alloc]init];
		//oProductItem = [[ProductItem alloc] init];
		//NSLog(@"oProduct item = %@",oProductItem);
	}else if([elementName caseInsensitiveCompare:@"productName"]==0)
	{
		self.productName = [[NSString alloc]init];
		//appDelegate.productArray = [[NSMutableArray alloc]init];
		//oProductItem = [[ProductItem alloc] init];
		//NSLog(@"oProduct item = %@",oProductItem);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	
	//if(!currentElementValue) 
	currentElementValue = [[NSMutableString alloc] initWithString:string];
	//else
	//	[currentElementValue appendString:string];
		#ifdef DEBUG
			NSLog(@"Processing Value: %@", currentElementValue);
        #endif
	
	
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	
	if([elementName caseInsensitiveCompare:@"buyProduct"]==0)
	{
		return;
	}
	
	else if ([elementName caseInsensitiveCompare:@"transactionID"]==0)
	{
		//Initialize the object.
		self.transactionId = currentElementValue;

	}
	/*else if([elementName caseInsensitiveCompare:@"url"]==0)
	{
		//Initialize the object.
		self.url = currentElementValue;
		
		// [appDelegate.productArray addObject:oProductItem];
		//NSLog(@"app delegate product array = %@",appDelegate.productArray);	
	}*/
	else if([elementName caseInsensitiveCompare:@"errMessage"]==0)
	{
		//Initialize the object.
		self.errorMessage = currentElementValue;
		
		// [appDelegate.productArray addObject:oProductItem];
		//NSLog(@"app delegate product array = %@",appDelegate.productArray);	
	}
	else if([elementName caseInsensitiveCompare:@"size"]==0)
	{
		//Initialize the object.
		self.size = currentElementValue;
		
		// [appDelegate.productArray addObject:oProductItem];
		//NSLog(@"app delegate product array = %@",appDelegate.productArray);	
	}else if([elementName caseInsensitiveCompare:@"productName"]==0)
	{
		//Initialize the object.
		self.productName = currentElementValue;
		
		// [appDelegate.productArray addObject:oProductItem];
		//NSLog(@"app delegate product array = %@",appDelegate.productArray);	
	}else if([elementName caseInsensitiveCompare:@"item"]==0)
	{
		//Initialize the object.
		//self.urlArray = [[NSMutableArray alloc] addObject:currentElementValue];
		[self.urlArray addObject:currentElementValue];
		
		// [appDelegate.productArray addObject:oProductItem];
		//NSLog(@"app delegate product array = %@",appDelegate.productArray);	
	}
	else 
	{
		//[oProductItem setValue:currentElementValue forKey:elementName];
	}	
	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	self.errorHasOcuured = 1;
	#ifdef DEBUG
		NSLog(@"error code %d",[parseError code]);
	#endif
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in xml" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	
}




@end
