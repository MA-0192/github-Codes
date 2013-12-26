	//
	//  PackageListXMLParser.h
	//
	//  Created by Aditya A. Kamble on 27/12/11.
    //  Modified by Akash Gupta on 02/05/13
	//  Copyright (c) 2011 MediaAgility. All rights reserved.
	//

#import <Foundation/Foundation.h>
#import "PackageListModalClass.h"

@interface PackageListXMLParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableString				*currentElementValue;
@property (nonatomic)		  BOOL							accumulatingParsedCharacterData;



@property (strong, nonatomic) NSMutableArray				*marrData;
@property (strong, nonatomic) PackageListModalClass		*objPackageListModalClass;

- (PackageListXMLParser *) initPackageListXMLParser;

@end
