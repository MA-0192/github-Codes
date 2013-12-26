//
//  PoojaXMLParser.h
//  iPooja
//
//  Created by iPhone Dev 1 on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class RootViewController;
@class ProductItem; 
@class iChantAppDelegate;

@interface ProductXMLParser : NSObject <NSXMLParserDelegate>
{

	NSMutableString *currentElementValue;
	NSString *currentCategory;
	
	iChantAppDelegate *appDelegate;
	ProductItem * oProductItem;
	
}

- (ProductXMLParser *) initProductXMLParser;

@end

