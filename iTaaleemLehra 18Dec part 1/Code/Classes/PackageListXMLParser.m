	//
	//  PackageListXMLParser.m
	//
	//  Created by user on 15/11/11.
    //  Modified by Akash Gupta on 02/05/13
	//  Copyright (c) 2011 MediaAgility. All rights reserved.
	//

/*
 This class parses response data from PackageList.
 
 */

#import "PackageListXMLParser.h"

@implementation PackageListXMLParser

@synthesize currentElementValue = _currentElementValue;
@synthesize accumulatingParsedCharacterData = _accumulatingParsedCharacterData;

@synthesize marrData = _marrData;
@synthesize objPackageListModalClass = _objPackageListModalClass;

- (PackageListXMLParser *) initPackageListXMLParser 
{
	self = [super init];
	if(self != nil) {
		
	}
    
    self.marrData = [[NSMutableArray alloc] init];
	return self;

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
	
    
    if([elementName caseInsensitiveCompare:@"responseProduct"] == 0)
    {
        //NSLog(@"responseProduct Start");
		return;
	}
	else if([elementName caseInsensitiveCompare:@"item"] == 0)
    {
        //NSLog(@"item start");
		self.objPackageListModalClass = nil;
		self.objPackageListModalClass = [[PackageListModalClass alloc] init];
		return;
	}
	else if([elementName caseInsensitiveCompare:@"productID"] == 0){
    
	}
	else if([elementName caseInsensitiveCompare:@"type"] == 0){

	}
	else if([elementName caseInsensitiveCompare:@"name"] == 0){

	}
	else if([elementName caseInsensitiveCompare:@"description"] == 0){

	}
	else if([elementName caseInsensitiveCompare:@"iconImage"] == 0){

	}
    else if([elementName caseInsensitiveCompare:@"installStatus"] == 0){
        
	}
    
    
	
	
	
	self.accumulatingParsedCharacterData = YES;
	self.currentElementValue = nil;
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
   // NSLog(@"foundChars function called");
	if (self.accumulatingParsedCharacterData) 
	{
		
		if(!self.currentElementValue) 
			self.currentElementValue = [[NSMutableString alloc] initWithString:string];
		else
			[self.currentElementValue appendString:string];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName caseInsensitiveCompare:@"responseProduct"] == 0){
        //NSLog(@"responseProduct End");
		return;
	}
	else if([elementName caseInsensitiveCompare:@"item"] == 0){
        //NSLog(@"item end");

        [self.marrData addObject:self.objPackageListModalClass];
	}
	
	if([elementName caseInsensitiveCompare:@"productID"] == 0){
       // NSLog(@"pid end");
          if ([self.currentElementValue length] > 0){
              self.objPackageListModalClass.strProductId = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }
	}
	else if([elementName caseInsensitiveCompare:@"type"] == 0){
       // NSLog(@"type end");
          if ([self.currentElementValue length] > 0){
		self.objPackageListModalClass.strType = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }

	}
	else if([elementName caseInsensitiveCompare:@"name"] == 0){
       // NSLog(@"name end");
          if ([self.currentElementValue length] > 0){
        self.objPackageListModalClass.strName = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }
	}
	else if([elementName caseInsensitiveCompare:@"description"] == 0){
        //NSLog(@"desc end");
          if ([self.currentElementValue length] > 0){
        self.objPackageListModalClass.strDescription = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }
	}
	else if([elementName caseInsensitiveCompare:@"iconImage"] == 0){
        //NSLog(@"icon end");
          if ([self.currentElementValue length] > 0){
        self.objPackageListModalClass.strIconimage = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }
        
        
	}
    else if([elementName caseInsensitiveCompare:@"installStatus"] == 0){
          if ([self.currentElementValue length] > 0){
        self.objPackageListModalClass.strInstallStatus = [NSString stringWithFormat:@"%@",self.currentElementValue];
          }
	}
	
	self.currentElementValue = nil;
	
	self.accumulatingParsedCharacterData = NO;
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[parseError localizedDescription] 
												   delegate:nil 
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	
	
}


@end
