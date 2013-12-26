    //
//  ProductDetailCell.m
//  iPooja
//
//  Created by iPhone Dev 2 on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailCell.h"
#import "WebRequest.h"
#import "Constants.h"
#import "ConstantInApps.h"

@implementation ProductDetailCell
@synthesize imageView;
@synthesize productItem;
@synthesize productNameLabel;
@synthesize activityIndicator;

-(void)setCellData
{
	NSLog(@"product name :  %@",self.productItem.name);
	self.productNameLabel.text = self.productItem.name;
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(callNextStep:) name:self.productItem.iconImage object:nil];
	ImageWebRequest *imageRequest = [[ImageWebRequest alloc] init];
	[imageRequest webRequestURL:self.productItem.iconImage];
}





-(void)callNextStep:(NSNotification *)notification
{
	
	
	
	
	NSData *responseData = [[notification userInfo] objectForKey:kResponseKey];
	
	
	if (responseData == nil)
	{
		UIImage *defaultImage = [UIImage imageNamed:@"home-1.jpg"];
		imageView.image = defaultImage;
		
		
	}
	else 
	{
		
		UIImage *image = [[UIImage alloc] initWithData:responseData];
		imageView.image = image;
	}
	[self.activityIndicator stopAnimating];
	NSLog(@"In Call Next step");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:self.productItem.iconImage object:nil];
}











@end
