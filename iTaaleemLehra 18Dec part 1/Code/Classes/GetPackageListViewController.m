//
//  GetPackageListViewController.m
//  InAppModel
//
//  Created by User on 5/15/13.
//  Copyright (c) 2013 Richa Kumar. All rights reserved.
//

#import "GetPackageListViewController.h"
#import "Reachability.h"
#import "PackagesDetailViewController.h"
#import "GlobalValues_InApp.h"
#import "Constants_InApp.h"
#import "PackageListXMLParser.h"
#import "ActiveDownLoadController.h"

@interface GetPackageListViewController ()

@end

@implementation GetPackageListViewController
@synthesize tableViewPackageList = _tableViewPackageList;
@synthesize productReq = _productReq;
@synthesize arrProductList = _arrProductList;
@synthesize queue = _queue;
@synthesize marrImageIcons = _marrImageIcons;
@synthesize item = _item;
@synthesize doneButton = _doneButton;
@synthesize imgViewBackground = _imgViewBackground;

int chosenIndex;

GlobalValues_InApp *globalValues_InApp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.productReq = [MAProductRequest sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        
        self.navigationController.navigationBar.translucent=NO;
    }
    
    Reachability *reach = [[Reachability alloc]init];
    reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach currentReachabilityStatus] != NotReachable)
    {
        self.item = [[PackageListModalClass alloc] init];
        self.productReq.delegate = self;
        [self.productReq fetchProductListFromServer];
    }
    else
    {
        
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.title = @"Get More";
	self.doneButton.title = @"Done";
	self.doneButton.style = UIBarButtonSystemItemDone;
      
	self.navigationItem.leftBarButtonItem = self.doneButton;
    
 
    
    UIBarButtonItem *activeDownloads = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_activedownload"] style:UIBarButtonItemStyleBordered target:self action:@selector(activeDownloadsClicked)];
    self.navigationItem.rightBarButtonItem = activeDownloads;
    
    if ( isAtLeast7 ) {
        
        self.doneButton.tintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    }
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
       // self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
    }
    if(result.height == 568)
    {
        self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, self.imgViewBackground.frame.size.width, 568);
        
      //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
    }
}

- (void)activeDownloadsClicked
{
    ActiveDownLoadController* activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];

    [activeDownLoadObj1 setDoneBtnVisible:@"yes"];
	[self presentModalViewController:navigationController animated:YES];
}

-(void)productListRetrieved:(NSArray *)arrProductList
{
    self.arrProductList = [arrProductList mutableCopy];
    [self updateProductList];
    
}

-(void) updateProductList
{
    NSLog(@"self.marrProductList = %@", self.arrProductList);
	
	self.marrImageIcons = [[NSMutableArray alloc] init];
    self.item = [[PackageListModalClass alloc] init];
	
    // BEGIN BACKGROUND ASYNC TASK
	self.queue = [NSOperationQueue new];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:self
										selector:@selector(beginBackgroundWebImageTask)
										object:nil];
	[self.queue addOperation:operation];
    
	[self.tableViewPackageList reloadData];
}

-(void) beginBackgroundWebImageTask{
	for (int i=0; i<[self.arrProductList count]; i++){
		self.item = [self.arrProductList objectAtIndex:i];
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.item.strIconimage]];
		UIImage* imagePic = [[UIImage alloc] initWithData:imageData];
		[self.marrImageIcons addObject:imagePic];
		chosenIndex = i;
		[self performSelectorOnMainThread:@selector(loadCell) withObject:nil waitUntilDone:NO];
	}
}

-(void) loadCell{
	NSIndexPath *indexPath = [[NSIndexPath alloc] init];
	indexPath = [NSIndexPath indexPathForRow:chosenIndex inSection:0];
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	cell = (UITableViewCell *) [self.tableViewPackageList cellForRowAtIndexPath:indexPath];
	
	//cell.imageView.image = [self.marrImageIcons objectAtIndex:chosenIndex];
	//[cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
	[self.tableViewPackageList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)productDetailsFromAppStoreRetrieved:(NSArray*)productDetails
{
    
}

-(void)productPurchased:(NSString*)productID
{
    
}
-(void)productRestored:(NSString*)productID
{
    
}
-(void)productTransactionFailed
{
    
}

-(void)productStatusUpdated:(NSString*)message
{
    
}

-(void)productTriggerDownloadfromURL:(NSString*)URL;
{
}
-(IBAction)doneButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popToRoot" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return [self.arrProductList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        //        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    cell.textLabel.text = [[self.arrProductList objectAtIndex:indexPath.row] strName];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    
  //  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
 //   cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];

    if (indexPath.row < [self.marrImageIcons count]){
		if ([self.marrImageIcons objectAtIndex:indexPath.row] != nil){
			cell.imageView.image = [self.marrImageIcons objectAtIndex:indexPath.row];
		}
	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    self.item = [self.arrProductList objectAtIndex:row];
	
    PackagesDetailViewController *pkgDetailViewObj1 = [[PackagesDetailViewController alloc]initWithNibName:@"PackagesDetailViewController" bundle:nil];
    pkgDetailViewObj1.item = self.item;
    [self.navigationController pushViewController:pkgDetailViewObj1 animated:YES];

}

@end
