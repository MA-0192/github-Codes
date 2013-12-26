//
//  ProductDetailCell.h
//  iPooja
//
//  Created by iPhone Dev 2 on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"
#import "ImageWebRequest.h"

@interface ProductDetailCell : UITableViewCell 
{
	
	UIImageView *imageView;
	UILabel *productNameLabel;
	ProductItem *productItem;
	UIActivityIndicatorView *activityIndicator;

}
@property (nonatomic,strong)IBOutlet  UIImageView *imageView;
@property (nonatomic,strong)ProductItem *productItem;
@property (nonatomic,strong)IBOutlet UILabel *productNameLabel;
@property (nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)setCellData ;

@end
