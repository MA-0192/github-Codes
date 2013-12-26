//
//  ActiveDownLoadController.h
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveDownLoadDataCell.h"
#import "MAProductRequest.h"

@class AppDelegate;

@interface ActiveDownLoadController : UIViewController <UITableViewDelegate ,UITableViewDataSource,UIAlertViewDelegate,MAProductRequestDelegate>
{
    UIBarButtonItem *doneButton;
	IBOutlet UITableView *activeDownLoadTable;
	NSMutableArray *ActiveDownLoadArray;
	NSMutableArray *tableCellArray;
	NSMutableArray *timerArray;
	NSUserDefaults *userDefaultsObj;
	ActiveDownLoadDataCell *tblcell;
	NSTimer * downloadTimer;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UITextView *infoTextView;
	AppDelegate *appDelagete;
	NSMutableArray *activeDownloadUserDefaltArray;
}

@property(nonatomic,strong)	IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic,strong)	UITableView *activeDownLoadTable;
@property(nonatomic,strong)	NSMutableArray *ActiveDownLoadArray;
@property(nonatomic,strong)NSUserDefaults *userDefaultsObj;
@property(nonatomic,strong)ActiveDownLoadDataCell *tblcell;
@property(nonatomic,strong)NSMutableArray *tableCellArray;
@property(nonatomic,strong)NSTimer * downloadTimer;
@property(nonatomic,strong)AppDelegate *appDelagete;
@property(nonatomic,strong)NSMutableArray *timerArray;
@property(nonatomic,strong)IBOutlet UITextView *infoTextView;
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)NSMutableArray *activeDownloadUserDefaltArray;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBG;
@property(strong,nonatomic) UIAlertView *clearDownloadsAlert;
@property(strong,nonatomic) UIBarButtonItem *clearButton;
@property(nonatomic) BOOL boolShowClearButton;
//USING TWO BUTTONS i.e. ONE FOR ADDING PULSE TO NAVIGATION BAR FOR SHOWING PULSE ON COMPLETE SCREEN AND SECOND FOR REMOVING PULSE
@property (strong, nonatomic) IBOutlet UIButton *btnPulse;
@property (strong, nonatomic) IBOutlet UIButton *btnForRemovingPulse;
@property (strong, nonatomic) MAProductRequest *productRequest;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDownload;


@property(nonatomic,strong)	NSString *DoneBtnVisible;

- (IBAction)langSettingButtonPressed:(id)sender;
-(id)initWithTabBar;
-(void)clearUnfinishedDownloads;
@end
