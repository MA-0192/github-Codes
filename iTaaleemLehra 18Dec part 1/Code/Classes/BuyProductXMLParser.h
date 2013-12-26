//
//  BuyProductXMLParser.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BuyProductXMLParser : NSObject <NSXMLParserDelegate>
{
	NSMutableString *currentElementValue;
	NSString *currentCategory;
	
	NSString *transactionId;
	NSString *url;
	NSString *errorMessage;
	NSString *size;
	NSString *productName;
	
	NSMutableArray *urlArray; 
	BOOL errorHasOcuured;
	
}
@property(nonatomic,strong)	NSMutableString *currentElementValue;
@property(nonatomic,strong)	NSString *currentCategory;
@property(nonatomic,strong)NSString *transactionId;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *errorMessage;
@property(nonatomic,strong)	NSString *size;
@property(nonatomic,strong)NSString *productName;
@property (nonatomic ,strong)NSMutableArray *urlArray; 
@property (nonatomic)BOOL errorHasOcuured;
- (BuyProductXMLParser *) initBuyProductXMLParser;
@end
