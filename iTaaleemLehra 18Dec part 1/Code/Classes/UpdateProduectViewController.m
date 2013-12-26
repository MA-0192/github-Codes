//
//  UpdateProduectViewController.m
//  iPooja
//
//  Created by iPhone Dev 2 on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdateProduectViewController.h"
#import "WebRequest.h"
#import "Constants.h"
#import "ProductWebRequest.h"
#import "UpdateProductItem.h"
#import "iChantAppDelegate.h"
#import "ActiveDownLoadController.h"
#import "ConstantInApps.h"
#import "GlobalValues_InApp.h"
#import "Constants_InApp.h"

@implementation UpdateProduectViewController
@synthesize doneButton;
@synthesize productUpgradeTable;
@synthesize tblCell;

@synthesize activeDownObj;
@synthesize activityIndicator;
@synthesize activeDownLoadObj;
@synthesize itemDirectroyArray;
@synthesize directoryPath;

@synthesize imgViewBackground;

GlobalValues_InApp *globalValues_InApp;
UpdateProductItem *currentProductItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = NSLocalizedString(@"Update", @"Update");
//        self.tabBarItem.image = [UIImage imageNamed:@"updatetab.png"];
        self.tabBarItem.title=@"Update";
        
        [  self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                                   [UIFont fontWithName:@"Helvetica" size:12.0], UITextAttributeFont, nil]
                                         forState:UIControlStateNormal];

        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"updatetab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"updatetab.png"]];
    }
    return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = @"Updates";
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor whiteColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:25.0];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        bigLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    else
        bigLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    [bigLabel sizeToFit];
    self.navigationItem.titleView = bigLabel;
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

	appDelegate = (iChantAppDelegate *)[[UIApplication sharedApplication] delegate];
	itemDirectroyArray=[[NSMutableArray alloc] init];
	
    globalValues_InApp = [GlobalValues_InApp sharedManager];
	
//	UIBarButtonItem *addButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_activedownload-03.png"]style:UIBarButtonItemStyleBordered target:self action:@selector(flipActiveDownloadAction:)];
//	self.navigationItem.rightBarButtonItem = addButton1;
	
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.directoryPath = [NSString stringWithFormat:@"%@/Caches",libraryPath];
	
	// send request for product upadates
	
	NSFileManager *manager = [NSFileManager defaultManager];
   
	NSArray *fileListArray =  [manager contentsOfDirectoryAtPath:self.directoryPath error:nil];
	
	NSMutableArray  *fileList = [[NSMutableArray alloc] initWithArray:fileListArray];

		NSLog(@"file list = %@",fileList);
	
	
	
	self.productUpgradeTable.backgroundColor = [UIColor clearColor];
    NSMutableArray *directoryArray = [[NSMutableArray alloc] init];
	
	for (NSString *s in fileList)
	{
		[directoryArray addObject:[NSString stringWithFormat:@"%@/%@/",self.directoryPath,s]];
	}
	NSLog(@"Directory array:%@",directoryArray);
	
	NSMutableArray *chantdetailArray = [[NSMutableArray alloc] init];
	
	for (int i=0; i<[directoryArray count]; i++) 
	{
		
		
		NSString *chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:[directoryArray objectAtIndex:i]];
		if (chantDetailPath != nil) 
		{
			
			NSArray *detailArray = [[NSArray alloc] initWithContentsOfFile:chantDetailPath];
			[itemDirectroyArray addObject:[directoryArray objectAtIndex:i]];
			[chantdetailArray addObject:detailArray];
		}
	}
	
	NSLog(@"Chant Detail array:%@",chantdetailArray);
	
	
	
	[self.activityIndicator startAnimating];
	
	NSString *requestString = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><productUpdateList>"];
	
	
	for (int i = 0; i<[fileList count]; i++)
	{
		NSLog(@"Directory name: %@",[directoryArray objectAtIndex:i]);
		NSString *chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:[directoryArray objectAtIndex:i]];
		if (chantDetailPath != nil) 
		{  
			
			NSArray *detailArray = [[NSArray alloc] initWithContentsOfFile:chantDetailPath];
			NSArray *tempArray = detailArray;
			NSString *temp = [[NSString alloc] initWithFormat:@"<item><productID>%@</productID><version>%@</version></item>",[tempArray objectAtIndex:2],[tempArray objectAtIndex:3] ];
			requestString = [requestString stringByAppendingString:temp];
		}
		else 
		{
			NSLog(@"Chant detail path could not found for the directory%@",[directoryArray objectAtIndex:i]);
		}

	}

	
	requestString = [requestString stringByAppendingString:@"</productUpdateList>"];
	
	WebRequest *wr = [[WebRequest alloc] init];
	
	NSString *str = [NSString stringWithFormat:@"productUpgradeRequest=%@",requestString];
    
	NSLog(@"Request message Print :%@",str);
	
	[wr webRequestURL:kgetUpdatesOfProductURL withXMLMessage:str];
	
	#ifdef DEBUG
		NSLog(@"request = %@",str);
	#endif
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateTable) name:@"updateProductdataRetrived" object:nil];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	tblCell = [[UpdateProductDataCell alloc] init];
	
//	doneButton.title = @"Done";
//	doneButton.style = UIBarButtonSystemItemDone;
//	self.navigationItem.leftBarButtonItem = doneButton;
	
	self.productUpgradeTable.hidden = YES;
	

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
        }
        else{
            [self changeViewForLandscapeMode];
        }
    }
    else{
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
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
   
	[super viewDidUnload];
    doneButton = nil;
	productUpgradeTable = nil;
    tblCell = nil;
	activeDownObj = nil;
	activityIndicator = nil;
	
}


-(IBAction)dismissModelView:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];	
}


#pragma mark tableView

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	viewFooter.backgroundColor = [UIColor clearColor];
	return viewFooter;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section
{
		return[appDelegate.updatesProductArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *FirstLevelCell= @"FirstLevelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: FirstLevelCell];
    }
    // Configure the cell
	
	NSInteger row = [indexPath row];
	static NSString *activeDownloadCellIdentifier = @"activeDownloadCellIdentifier";
	
	
	tblCell = (UpdateProductDataCell *)[tableView dequeueReusableCellWithIdentifier: activeDownloadCellIdentifier];
	
	
	if (tblCell == nil)
	{
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateProductDataCell-iPad" owner:self options:nil];
            
            for (id oneObject in nib){
                
                
                if ([oneObject isKindOfClass:[UpdateProductDataCell class]])
                    tblCell = (UpdateProductDataCell *)oneObject;
                
                self.tblCell.backgroundColor = [UIColor clearColor];
                self.tblCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        else
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateProductDataCell" owner:self options:nil];
            
            for (id oneObject in nib){
                
                
                if ([oneObject isKindOfClass:[UpdateProductDataCell class]])
                    self.tblCell = (UpdateProductDataCell *)oneObject;
                
                self.tblCell.backgroundColor = [UIColor clearColor];
                self.tblCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
	}
	tblCell.backgroundColor = [UIColor clearColor];
	tblCell.selectionStyle = UITableViewCellSelectionStyleNone;
	[tblCell setCellData:row directory:[itemDirectroyArray objectAtIndex:indexPath.row]];
	return tblCell ;
}


-(void)updateTable
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateProductdataRetrived" object:nil];
	[self.activityIndicator stopAnimating];

	self.productUpgradeTable.hidden = NO;
	[self.productUpgradeTable reloadData];
	
	NSLog(@"appdelegate.updateProduct array :%d",[appDelegate.updatesProductArray count]);
	
}


- (IBAction)buyUpdate:(id)sender
{
	NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachesPath = [NSString stringWithFormat:@"%@/Caches",libraryPath];
    
	UIButton *senderButton = (UIButton *)sender;
	UITableViewCell *buttonCell = (UITableViewCell *)[senderButton superview];   //get the superview of the button
	NSUInteger buttonRow = [[self.productUpgradeTable indexPathForCell:buttonCell]row];
	//NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths1 objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
    //NSArray *fileListArray =  [manager directoryContentsAtPath:documentsDirectory];
	// deprecated method
	
	NSArray *fileListArray =  [manager contentsOfDirectoryAtPath:cachesPath error:nil];
	
	NSMutableArray  *fileList = [[NSMutableArray alloc] initWithArray:fileListArray];
	
	NSMutableArray *directoryNameArray=[[NSMutableArray alloc]init];
	NSString *s;
	
	for (s in fileList)
	{
		NSString *folderPath = [NSString stringWithFormat:@"%@/%@/",cachesPath,s];
		
		NSString *chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:folderPath];
        if (chantDetailPath != NULL)
		{
			[directoryNameArray addObject:[NSString stringWithFormat:@"%@/%@/",cachesPath,s]];
			//[chantDirectoryArray addObject:[NSString stringWithFormat:@"/Documents/%@/",s]];
		}
		
	}
	
	NSString *DetailChantPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:[directoryNameArray objectAtIndex:buttonRow]];
	NSArray *chantDetailArray = [[NSArray alloc] initWithContentsOfFile:DetailChantPath];
	
	
	
	NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
	
	NSMutableArray *activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
	NSLog(@"button row :%d",buttonRow);
	UpdateProductItem *item = [appDelegate.updatesProductArray objectAtIndex:buttonRow];
	NSLog(@"update product array :%@",item.URLs);
	int i;
	if ([activeDownLoadArray count])
	{
		BOOL unique = YES;
		for(i=0;i<[activeDownLoadArray count];i++)
		{
			ActiveDownload *objAD = [activeDownLoadArray objectAtIndex:i];
			
			
			if([objAD.productID isEqualToString:item.productID])
			{
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your download request for content  is already in Process" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
                
				i = [activeDownLoadArray count];
				
				//break;
			}
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your Download is already in process" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
            }
            unique = NO;
            
            
		}
		if(unique)
		{
			activeDownObj = [[ActiveDownload alloc]init];
			UpdateProductItem *item = [appDelegate.updatesProductArray objectAtIndex:buttonRow];
			
			activeDownObj.productID = item.productID;
			activeDownObj.productName = [chantDetailArray objectAtIndex:0];
			activeDownObj.url = item.URL;
			//activeDownObj.transactionID = self.transactionID;
			activeDownObj.productType = @"up";
			activeDownObj.urlArray = item.URLs;
			activeDownObj.totalSize = item.size;
			
			//get data from user defaults and save it to array
			NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
			NSMutableArray * activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
			
			
			
			if(activeDownLoadArray == nil)
				activeDownLoadArray = [[NSMutableArray alloc]init];
			[activeDownLoadArray addObject:activeDownObj];
			
			NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
			[[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
			
            currentProductItem = item;
            
			ProductWebRequest *pr = [[ProductWebRequest alloc] init];
            pr.delegate = self;
			pr.productType = @"up";
			pr.productID = item.productID;
			pr.productName =  [chantDetailArray objectAtIndex:0];
			pr.transactionID = item.transactionID;
			
			
			pr.totalSize = item.size;
			pr.downLoadSize = [item.size intValue]*1024;
			
            globalValues_InApp.strUnzipPackagePath = self.directoryPath;
			NSLog(@"URL Count :%d",[item.URLs count]);
			[pr getAndUnZipContent:[item.URLs objectAtIndex:0]];
			
			
			activeDownLoadObj = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];	
			UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj];
              activeDownLoadObj.DoneBtnVisible=@"yes";
			[self presentModalViewController:navigationController animated:YES];
			
		}	
	}
	else
	{
		
		activeDownObj = [[ActiveDownload alloc]init];
		UpdateProductItem *item = [appDelegate.updatesProductArray objectAtIndex:buttonRow];
		
		activeDownObj.productID = item.productID;
		activeDownObj.productName = [chantDetailArray objectAtIndex:0];
		activeDownObj.url = item.URL;
		//activeDownObj.transactionID = self.transactionID;
		activeDownObj.productType = @"up";
		activeDownObj.urlArray = item.URLs;
		activeDownObj.totalSize = item.size;
		
		//get data from user defaults and save it to array
		NSData *data1 = [[[NSUserDefaults standardUserDefaults]objectForKey:kuserDefKeyForActiveDownLoad] mutableCopy];
		NSMutableArray * activeDownLoadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
		
		
		
		if(activeDownLoadArray == nil)
			activeDownLoadArray = [[NSMutableArray alloc]init];
		[activeDownLoadArray addObject:activeDownObj];
		
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDownLoadArray];
		[[NSUserDefaults standardUserDefaults] setObject:data forKey:kuserDefKeyForActiveDownLoad];
		
        currentProductItem = item;
        
		ProductWebRequest *pr = [[ProductWebRequest alloc] init];
        pr.delegate = self;
		pr.productType = @"up";
		pr.productID = item.productID;
		pr.productName =  [chantDetailArray objectAtIndex:0];
		pr.transactionID = item.transactionID;
		//pr.totalSize = parser.size;
		//pr.downLoadSize = [parser.size intValue]*1024;
		//[pr getAndUnZipContent:item.URL];
		
		pr.totalSize = item.size;
		pr.downLoadSize = [item.size intValue]*1024;

        globalValues_InApp.strUnzipPackagePath = self.directoryPath;
		NSLog(@"URL Count :%d",[item.URLs count]);
		[pr getAndUnZipContent:[item.URLs objectAtIndex:0]];
		
		
		activeDownLoadObj = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];	
		UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj];
           activeDownLoadObj.DoneBtnVisible=@"yes";
		[self presentModalViewController:navigationController animated:YES];
		
	}
	
}


- (void)flipActiveDownloadAction:(id)sender
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        ActiveDownLoadController *activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownloadController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];
           activeDownLoadObj1.DoneBtnVisible=@"yes";
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        ActiveDownLoadController *activeDownLoadObj1 = [[ActiveDownLoadController alloc]initWithNibName:@"ActiveDownLoadController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:activeDownLoadObj1];
            activeDownLoadObj1.DoneBtnVisible=@"yes";
        [self presentModalViewController:navigationController animated:YES];
    }
	
}

-(void)downloadCompleted
{
    NSString *paths1 = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.directoryPath = [NSString stringWithFormat:@"%@/Caches",paths1];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *fileListArray =  [manager contentsOfDirectoryAtPath:self.directoryPath error:nil];
    
    NSMutableArray  *fileList = [[NSMutableArray alloc] initWithArray:fileListArray];
    
#ifdef DEBUG
    
    NSLog(@"file list = %@",fileList);
    
#endif
    
    NSMutableArray *directoryNameArray=[[NSMutableArray alloc]init];
    
    NSString *s;
    
    for (s in fileList)
    {
        
        NSString *folderPath = [NSString stringWithFormat:@"%@/%@/",self.directoryPath,s];
        
        NSString *chantDetailPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:folderPath];
        
        if (chantDetailPath != NULL)
        {
            
            [directoryNameArray addObject:[NSString stringWithFormat:@"%@/%@/",self.directoryPath,s]];
        }
    }
    
    NSMutableArray *chantDetailArray = [[NSMutableArray alloc] init];
    NSString *DetailChantPath = [[NSString alloc] init];
    
    NSString *dir;
    
    for (dir in directoryNameArray)
    {
        
        DetailChantPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:dir];
        
        chantDetailArray = [[NSMutableArray alloc] initWithContentsOfFile:DetailChantPath];
        
        if ([[chantDetailArray objectAtIndex:2]isEqualToString:currentProductItem.productID])
        {
            
            break;
        }
        
    }
    
    [chantDetailArray replaceObjectAtIndex:3 withObject:currentProductItem.latestVersion];
    
    //Save to plist
    
    NSLog(@"DIR %@",DetailChantPath);
    
    [chantDetailArray writeToFile:DetailChantPath atomically:NO];
    NSLog(@"Chant Detail Array %@",chantDetailArray);
    
    currentProductItem = nil;
    
}

#pragma mark - AUTOROTATE

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            NSLog(@"LANDSCAPE");
            
            [self changeViewForLandscapeMode];
            
        }
        else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            NSLog(@"PORTRAIT");
            
            [self changeViewForPortraitMode];
        }
    }
    else{
        
    }
}
-(void)changeViewForLandscapeMode
{
    self.view.frame = CGRectMake(0, 0, 1024, 768);
    self.imgViewBackground.frame = CGRectMake(0, 0, 1024, 768);
    self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Landscape.png"];
}

-(void)changeViewForPortraitMode
{
    self.view.frame = CGRectMake(0, 0, 768, 1004);
    self.imgViewBackground.frame = CGRectMake(0, 0, 768, 1004);
    self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Portrait.png"];
}

@end
