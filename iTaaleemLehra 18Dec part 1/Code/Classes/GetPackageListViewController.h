//
//  GetPackageListViewController.h
//  InAppModel
//
//  Created by User on 5/15/13.
//  Copyright (c) 2013 Richa Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAWebRequest.h"
#import "MAProductRequest.h"
#import <StoreKit/StoreKit.h>
#import "PackageListModalClass.h"

@interface GetPackageListViewController : UIViewController <MAWebRequestDelegate, MAProductRequestDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableViewPackageList;
@property (strong, nonatomic) MAProductRequest *productReq;
@property (strong, nonatomic) NSArray *arrProductList;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableArray *marrImageIcons;
@property (strong, nonatomic) PackageListModalClass *item;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBackground;

-(void) updateProductList;
-(IBAction)doneButtonPressed:(id)sender;


@end
