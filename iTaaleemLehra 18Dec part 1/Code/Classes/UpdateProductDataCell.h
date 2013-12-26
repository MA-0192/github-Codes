//
//  UpdateProductDataCell.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveDownload.h"
@class iChantAppDelegate;

@interface UpdateProductDataCell : UITableViewCell 
{

	UILabel *productNameLabel;
	UILabel *currentversionLabel;
	UIButton *getUpdateButton;
	UILabel  *updateVersionlabel;
	UIImageView *productImage;
	
	iChantAppDelegate *appDelegate;
	ActiveDownload *activeDownObj;
	
	
}


@property(nonatomic,strong)IBOutlet  UILabel *productNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *currentversionLabel;
@property(nonatomic,strong)IBOutlet UIButton *getUpdateButton;
@property(nonatomic,strong)IBOutlet UILabel  *updateVersionlabel;
@property(nonatomic,strong)IBOutlet UIImageView *productImage;

@property(nonatomic,strong)ActiveDownload *activeDownObj;

-(void)setCellData:(NSInteger)cellNo directory:(NSString*)dir;

@end
