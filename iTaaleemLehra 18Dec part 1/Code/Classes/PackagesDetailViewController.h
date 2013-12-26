//
//  PackagesDetailViewController.h
//  iCityPediaUniversal
//
//  Created by User on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageListModalClass.h"
#import "MAProductRequest.h"

@interface PackagesDetailViewController : UIViewController <UIAlertViewDelegate,MAProductRequestDelegate>

//INAPPS
@property(strong,nonatomic) SKProduct                   *product;
@property(strong,nonatomic) MAProductRequest *objProductReq;
@property (strong, nonatomic) NSMutableArray *marrDataPackageList;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBG;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPackageIcon;
@property(nonatomic,strong) PackageListModalClass *item;
@property (strong, nonatomic) IBOutlet UILabel *lblNameText;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceText;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;
@property (strong, nonatomic) IBOutlet UIButton *btnRestorePurchase;
@property (strong, nonatomic) IBOutlet UIButton *btnClearUnfinished;
@property (strong, nonatomic) UIBarButtonItem *barButtonItemBack;
@property (strong, nonatomic) UIBarButtonItem *barButtonItemHomeScreen;
@property (strong, nonatomic) IBOutlet UIView *viewWait;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIAlertView *alertBuyPackage;
@property (strong, nonatomic) UIAlertView *alertRestorePackage;
@property (strong, nonatomic) UIAlertView *alertClearUnfinished;
@property (strong, nonatomic) UIAlertView *alertNetNotAvailable;
@property (nonatomic) BOOL boolButtonBuyClicked;

@property(nonatomic,strong) IBOutlet UILabel *borderLabelforPrice;
@property(nonatomic,strong) IBOutlet UILabel *borderLabelforDescription;
@property(nonatomic,strong) IBOutlet UILabel *lblRemoveAdvertisments;
@property(nonatomic,strong) IBOutlet UILabel *lblWait;
@property(nonatomic,strong) IBOutlet UIImageView *imgViewBackground;

- (IBAction)btnBuyButtonClicked:(id)sender;
//- (IBAction)btnClearUnfinishedClicked:(id)sender;
-(IBAction)restorePurchaseButtonClicked;
-(void)displayProductImage;
//-(void)checkItemPurchased;
-(void) designUI;
//-(void) removeWaitView;
//-(void)buyPackage;
-(void)presentActiveDownloadPageForiPhone;
@end
