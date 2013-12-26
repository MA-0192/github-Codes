//
//  ItemParser.m
//  iAatman
//
//  Created by iPhone Developer on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemParser.h"


@implementation ItemParser
@synthesize currentCategory;
@synthesize currentElementValue;
@synthesize playingitemNameNew;

- (ItemParser *) initAatmanXMLParser
{
	if (!(self = [super init])) return nil;
	
	appDelegate = (iChantAppDelegate*)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"item"]) 
	{
		currentItem=[[Item alloc] init];
		currentItem.narrationArray=[[NSMutableArray alloc] init];
		currentItem.displayArray=[[NSMutableArray alloc]init];
	}
	
	else if([elementName isEqualToString:@"name"]) 
		currentCategory = elementName;
	else  if([elementName isEqualToString:@"itemcost"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"freebeadscount"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemtype"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemplist"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"timefactor"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemaudio"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemaudiotype"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itembgimage"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itembgimagetype"])
		currentCategory=elementName;
    
    else if([elementName isEqualToString:@"itembgimageiPod"])
		self.currentCategory=elementName;
	else if([elementName isEqualToString:@"itembgimagetypeiPod"])
		self.currentCategory=elementName;
    
    else if([elementName isEqualToString:@"itembgimagePortrait"])
		self.currentCategory=elementName;
	else if([elementName isEqualToString:@"itembgimagetypePortrait"])
		self.currentCategory=elementName;
    
    else if([elementName isEqualToString:@"itembgimageLandscape"])
		self.currentCategory=elementName;
	else if([elementName isEqualToString:@"itembgimagetypeLandscape"])
		self.currentCategory=elementName;
	
	else if([elementName isEqualToString:@"itemartistname"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemartistimage"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemartistimagetype"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"itemartistinfo"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"narration"])
		narration=[[Narration alloc] init];
	else if([elementName isEqualToString:@"languagename"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"artistname"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"artistimage"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"artistimagetype"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"audioname"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"audiotype"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"artistinfo"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"display"])
		display=[[Display alloc]init];
	else if([elementName isEqualToString:@"displaylanguagename"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"text"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"imagename"])
		currentCategory=elementName;
	else if([elementName isEqualToString:@"imagetype"])
		currentCategory=elementName;
	
	
	//NSLog(@"Processing Element: %@", elementName);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	//NSLog(@"Found Value: %@", currentElementValue);
	
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"name"]) 
	{
		currentItem.itemName=currentElementValue;
		currentElementValue=nil;
	}
	else  if([elementName isEqualToString:@"itemcost"])
	{
		currentItem.itemCost=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"freebeadscount"])
	{
		currentItem.itemFreeBeadsCount=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemtype"])
	{
		currentItem.itemType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemplist"])
	{
		currentItem.itemPlist=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"timefactor"])
	{
		currentItem.timeFactor=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemaudio"])
	{
		currentItem.itemAudio=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemaudiotype"])
	{
		currentItem.itemAudioType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itembgimage"])
	{
		currentItem.itembgImage=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itembgimagetype"])
	{
		currentItem.itembgImageType=currentElementValue;
		currentElementValue=nil;
	}
    else if([elementName isEqualToString:@"itembgimageiPod"])
	{
		currentItem.itembgimageiPod = self.currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itembgimagetypeiPod"])
	{
		currentItem.itembgimagetypeiPod = self.currentElementValue;
		currentElementValue=nil;
	}
    else if([elementName isEqualToString:@"itembgimagePortrait"])
	{
		currentItem.itembgimagePortrait = self.currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itembgimagetypePortrait"])
	{
		currentItem.itembgimagetypePortrait = self.currentElementValue;
		currentElementValue=nil;
	}
    else if([elementName isEqualToString:@"itembgimageLandscape"])
	{
		currentItem.itembgimageLandscape = self.currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itembgimagetypeLandscape"])
	{
		currentItem.itembgimagetypeLandscape = self.currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemartistname"])
	{
		currentItem.itemArtistName=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemartistimage"])
	{
		currentItem.itemArtistImage=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemartistimagetype"])
	{
		currentItem.itemArtistImageType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"itemartistinfo"])
	{
		currentItem.itemArtistInfo=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"languagename"])
	{
		narration.languageName=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"artistname"])
	{
		narration.artistName=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"artistimage"])
	{
		narration.artistImage=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"artistimagetype"])
	{
		narration.artistImageType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"audioname"])
	{
		narration.audioName=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"audiotype"])
	{
		narration.audioType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"artistinfo"])
	{
		narration.artistInfo=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"narration"])
	{
		[currentItem.narrationArray addObject:narration];
		narration=nil;
	}
	else if([elementName isEqualToString:@"displaylanguagename"])
	{
		display.displayLanguageName=currentElementValue;
		currentElementValue=nil;
	}
	
	else if([elementName isEqualToString:@"text"])
	{
		display.displayText=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"imagename"])
	{
		display.displayImage=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"imagetype"])
	{
		display.displayImageType=currentElementValue;
		currentElementValue=nil;
	}
	else if([elementName isEqualToString:@"display"])
	{
		[currentItem.displayArray addObject:display];
		display=nil;
	}
	else if([elementName isEqualToString:@"item"])
	{
		appDelegate.playingItem=nil;
        
   //     NSLog(@"%@",currentItem.itemAudio);
        
		appDelegate.playingItem=currentItem;
        
             NSLog(@"%@",appDelegate.playingItem.itemAudio);
        
		currentItem=nil;
	}
	
	
	//NSLog(@"End element:%@",elementName);
	
	
	
}
 -(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"Error occured:%@",parseError);
}
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"Parsing the document started");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"Came to end of document");
}

@end
