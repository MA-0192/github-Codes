//
//  UpdateProductDataCell.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdateProductDataCell.h"
#import "iChantAppDelegate.h"
#import "UpdateProductItem.h"
#import "ProductWebRequest.h"

@implementation UpdateProductDataCell
@synthesize productNameLabel;
@synthesize currentversionLabel;
@synthesize getUpdateButton;
@synthesize updateVersionlabel;
@synthesize productImage;

@synthesize activeDownObj;


-(void)setCellData:(NSInteger)cellNo directory:(NSString*)dir
{
	appDelegate = (iChantAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.backgroundColor = [UIColor clearColor];
	
	
	NSString *DetailPoojaPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:dir];
	NSArray *poojaDetailArray = [[NSArray alloc] initWithContentsOfFile:DetailPoojaPath];
		
	self.productNameLabel.text = [poojaDetailArray objectAtIndex:0];
	self.currentversionLabel.text = [NSString stringWithFormat:@"Current Version : %@",[poojaDetailArray objectAtIndex:3]];
	NSString *path = [NSBundle pathForResource:[poojaDetailArray objectAtIndex:1] ofType:@"png" inDirectory:dir];
	self.productImage.image = [UIImage imageWithContentsOfFile:path];
	UpdateProductItem *item = [appDelegate.updatesProductArray objectAtIndex:cellNo];
    self.updateVersionlabel.text = [NSString stringWithFormat:@"Updated version : %@",item.latestVersion];

	if ([item.latestVersion floatValue]<=[[poojaDetailArray objectAtIndex:3] floatValue])
	{
		self.getUpdateButton.hidden = YES;
		self.accessoryView.hidden = YES;
		self.updateVersionlabel.text = @"Upadated version not available";
	}
	
	
		#ifdef DEBUG
			NSLog(@"appdelagte/updateProductarray : %d",[appDelegate.updatesProductArray count]);
		#endif 
	
	
    for (int i = 0; i<[appDelegate.updatesProductArray count]; i++)
	{
	#ifdef DEBUG
		UpdateProductItem *item = [appDelegate.updatesProductArray objectAtIndex:i];
		NSLog(@"item url = %@ ",item.URL);
		NSLog(@"item productID = %@ ",item.productID);
		NSLog(@"item latestVersion = %@ ",item.latestVersion);
	#endif
		
	}
	
}

@end
