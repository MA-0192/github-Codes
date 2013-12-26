//
//  UpdateProduectViewController.h
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateProductDataCell.h"
#import "ActiveDownload.h"
#import "ActiveDownLoadController.h"
#import "ProductWebRequest.h"


@class iChantAppDelegate;
@interface UpdateProduectViewController : UIViewController <UITableViewDelegate ,UITableViewDataSource,ProductWebRequestDelegate>
{
	
	 UIBarButtonItem *doneButton;
	
	IBOutlet UITableView *productUpgradeTable;
	UpdateProductDataCell *tblCell;
	iChantAppDelegate *appDelegate;
    ActiveDownload  *activeDownObj;
	
	IBOutlet  UIActivityIndicatorView *activityIndicator;
	ActiveDownLoadController *activeDownLoadObj;
	
	NSMutableArray *itemDirectroyArray;
  
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic,retain) UITableView *productUpgradeTable;
@property(nonatomic,retain) UpdateProductDataCell *tblCell;
@property(nonatomic,retain) ActiveDownload  *activeDownObj;
@property(nonatomic,retain)UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain)	ActiveDownLoadController *activeDownLoadObj;
@property(nonatomic,retain)NSMutableArray *itemDirectroyArray;
@property(nonatomic,retain)NSString *directoryPath;

@property (nonatomic, retain) IBOutlet UIImageView *imgViewBackground;

-(IBAction)dismissModelView:(id)sender;
- (IBAction)buyUpdate:(id)sender;

-(void)changeViewForLandscapeMode;
-(void)changeViewForPortraitMode;

@end
