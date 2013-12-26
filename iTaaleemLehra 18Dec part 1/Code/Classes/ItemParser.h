//
//  ItemParser.h
//  iAatman
//
//  Created by iPhone Developer on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Narration.h"
#import "Display.h"
#import "iChantAppDelegate.h"
@class iChantAppDelegate;
@interface ItemParser : NSObject<NSXMLParserDelegate> {
	
	iChantAppDelegate *appDelegate;
	Item *currentItem;
	Narration *narration;
	Display *display;
	NSString *currentCategory;
	NSMutableString *currentElementValue;
    NSString *playingitemNameNew;
}
- (ItemParser *) initAatmanXMLParser;
@property(nonatomic,strong)NSString *currentCategory;
@property(nonatomic,strong)NSMutableString *currentElementValue;
@property(nonatomic,strong)NSString *playingitemNameNew;
@end
