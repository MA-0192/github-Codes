//
//  UpdateProductXMLParser.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdateProductXMLParser.h"
#import "iChantAppDelegate.h"
#import "UpdateProductItem.h"

@implementation UpdateProductXMLParser


- (UpdateProductXMLParser *) initUpdateProductXMLParser {
	
	if (!(self = [super init])) return nil;
	
	appDelegate = (iChantAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.updatesProductArray = [[NSMutableArray alloc] init];
	oUpdateProductItem = [[UpdateProductItem alloc] init];
	
	return self;
}




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName caseInsensitiveCompare:@"productUpdateList"]==0)
	{
		return;
	}
	else if([elementName caseInsensitiveCompare:@"item"]==0)
	{
		//appDelegate.updatesProductArray = [[NSMutableArray alloc]init];
		oUpdateProductItem = [[UpdateProductItem alloc] init];
		//NSLog(@"oProduct item = %@",oUpdateProductItem);
	}else if([elementName caseInsensitiveCompare:@"URLs"]==0)
	{
		//appDelegate.updatesProductArray = [[NSMutableArray alloc]init];
        oUpdateProductItem.URLs = [[NSMutableArray alloc] init];
		//NSLog(@"oProduct item = %@",oUpdateProductItem);
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
	
	
	if([elementName caseInsensitiveCompare:@"productUpdateList"]==0)
	{
		return;
	}
	
	else if([elementName caseInsensitiveCompare:@"item"]==0)
	{
		//Initialize the object.
		
        [appDelegate.updatesProductArray addObject:oUpdateProductItem];
	//	[oUpdateProductItem.URLArray addObject:currentElementValue];
		#ifdef DEBUG
			NSLog(@"app delegate product array = %@",appDelegate.updatesProductArray);
		#endif
		
	}
	else if ([elementName caseInsensitiveCompare:@"URLs"]==0)
	{
		//[oUpdateProductItem setValue:currentElementValue forKey:elementName];
		//[oUpdateProductItem.URLs addObject:currentElementValue];
	}
	
	else if([elementName caseInsensitiveCompare:@"url"]==0)
	{
		[oUpdateProductItem.URLs addObject:currentElementValue];
	}
	
	else 
	{
		[oUpdateProductItem setValue:currentElementValue forKey:elementName];
	}	
	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	
		NSLog(@"error code %d",[parseError code]);
	
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in xml" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	
}





@end
