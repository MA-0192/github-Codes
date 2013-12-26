//
//  PoojaXMLParser.m
//  iPooja
//
//  Created by iPhone Dev 1 on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProductXMLParser.h"

#import "iChantAppDelegate.h"
#import "ProductItem.h"

@implementation ProductXMLParser

- (ProductXMLParser *) initProductXMLParser {
	
	if (!(self = [super init])) return nil;

	appDelegate = (iChantAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.productArray = [[NSMutableArray alloc] init];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
	if([elementName caseInsensitiveCompare:@"responseProduct"]==0)
	{
		return;
	}
	else if([elementName caseInsensitiveCompare:@"item"]==0)
	{
		//appDelegate.productArray = [[NSMutableArray alloc]init];
		oProductItem = [[ProductItem alloc] init];
		#ifdef DEBUG
			NSLog(@"oProduct item = %@",oProductItem);
		#endif
		
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
	
	
	if([elementName caseInsensitiveCompare:@"responseProduct"]==0)
	{
		return;
	}
		
	else if([elementName caseInsensitiveCompare:@"item"]==0)
	{
		//Initialize the object.
		
        [appDelegate.productArray addObject:oProductItem];
		#ifdef DEBUG
			NSLog(@"app delegate product array = %@",appDelegate.productArray);
		#endif
		
	}
	else 
	{
		[oProductItem setValue:currentElementValue forKey:elementName];
	}	

	}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
		#ifdef DEBUG
			NSLog(@"error code %d",[parseError code]);
		#endif
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in xml" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	
}

	

@end
