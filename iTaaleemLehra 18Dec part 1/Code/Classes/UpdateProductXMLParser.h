//
//  UpdateProductXMLParser.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UpdateProductItem.h"
@class iChantAppDelegate;
@class UpdateProductItem;

@interface UpdateProductXMLParser : NSObject <NSXMLParserDelegate>
{
	NSMutableString *currentElementValue;
	NSString *currentCategory;
	
	iChantAppDelegate *appDelegate;
	UpdateProductItem * oUpdateProductItem;
	BOOL accumulatingParsedCharacterData;
	

}
- (UpdateProductXMLParser *) initUpdateProductXMLParser;
@end
