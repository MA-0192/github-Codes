//
//  iChantDetailViewController.m
//  iChant
//
//  Created by iPhone Developer on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import "iChantDetailViewController.h"
#import "CBAutoScrollLabel.h"
#import "GetPackageListViewController.h"
@implementation iChantDetailViewController

@synthesize mTableView;
@synthesize instructionsView;
/*@synthesize narrations;
@synthesize displayLanguages;
@synthesize beadsArray;
@synthesize malasArray;
@synthesize selectedAudioSettingArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;*/
@synthesize productIDArray;
@synthesize infoButton;
@synthesize done;
@synthesize login;
//@synthesize dialog;
@synthesize editing;
@synthesize directoryPath;

@synthesize chantNameArray;
@synthesize chantIconArray;
@synthesize chantDirectoryArray;
@synthesize displayProductOrderArray;

@synthesize narrationArray;
@synthesize displayArray;
@synthesize paidOrFree;
@synthesize content;
@synthesize toolBarSettings;

//MOPUB
@synthesize adView;

@synthesize imgViewBackground;
@synthesize popOverController = _popOverController;
@synthesize mPopOverController = _mPopOverController;
@synthesize imgViewBG = _imgViewBG;
@synthesize btnSettings = _btnSettings;
@synthesize fbObject;

#define kSampleAdUnitIDForiPhone @"be96b08ae9a04ff5b40fc44950f01418"
#define kSampleAdUnitIDForiPad @"aceeaaddf4994181979aa5af6f5e292a"

bool _settingsClicked;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    GetMoreButton.backgroundColor=[UIColor colorWithRed:214.0f/255.0f green:97.0f/255.0f blue:6.0f/255.0f alpha:1.0f];

    
    
    UIButton* SettingButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[SettingButton addTarget:self action:@selector(SettingButton) forControlEvents:UIControlEventTouchUpInside];
    [SettingButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    
	SettingBarButton = [[UIBarButtonItem alloc] initWithCustomView:SettingButton];
	self.navigationItem.rightBarButtonItem = SettingBarButton;
    
    
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
      //  GetMoreButton.barTintColor=[UIColor whiteColor];
    }
    _settingsClicked=false;
	NSLog(@"In viewDidLoad in player view");
	//self.title=kViewTitle;
	mTableView.backgroundColor=[UIColor clearColor];
	mTableView.rowHeight=60;
	appdel=[[UIApplication sharedApplication] delegate];
    
	NSString *productPlistPath = [NSBundle pathForResource:kProductPlist ofType:@"plist" inDirectory:directoryPath];
    
    NSLog(@"%@",productPlistPath);
    
	content=[[NSArray alloc] initWithContentsOfFile:productPlistPath];
	
	paidOrFree=[content objectAtIndex:4];
	
	if ([content count]>=6) 
		narrationArray=[[NSMutableArray alloc] initWithArray:[content objectAtIndex:5]];
	
	if ([content count]>=7) 
	displayArray=[[NSMutableArray alloc] initWithArray:[content objectAtIndex:6]];
	
	productIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
	NSLog(@"PRODUCT ID ARRAY %@",productIDArray);
	
	//showing the info and active download button
	UIButton *info=[UIButton buttonWithType:UIButtonTypeInfoLight];
	[info addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    
	infoButton=[[UIBarButtonItem alloc] initWithCustomView:info]; 
	editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	
    
    
    

	chantDirectoryArray=[[NSMutableArray alloc] init];
	chantNameArray=[[NSMutableArray alloc] init];
	chantIconArray=[[NSMutableArray alloc] init];
	displayProductOrderArray=[[NSMutableArray alloc] init];
    NSLog(@"directory Path:%@",directoryPath);
	NSFileManager *fManager=[NSFileManager defaultManager];
	
	NSArray *fileArray=[fManager contentsOfDirectoryAtPath:directoryPath error:nil];
	NSLog(@"Sub-Directory array is:%@",fileArray);
	NSString *chantOrderPlistPath=[NSBundle pathForResource:kChantOrderPlist ofType:@"plist" inDirectory:directoryPath];
	NSArray *itemOrderArray=[[NSArray alloc] initWithContentsOfFile:chantOrderPlistPath];
	NSLog(@"item order array count is:%d",[itemOrderArray count]);
	for (int i=0; i<[itemOrderArray count]; i++)
	{
		NSString *s; 
		for (s in fileArray) 
		{
			NSString *plistPath=[NSBundle pathForResource:kChantPlist ofType:@"plist" inDirectory: [directoryPath stringByAppendingString:s]];
			if (plistPath!=nil)
			{
				NSLog(@"Plist path : %@",plistPath);
				NSArray *chantDetailArray=[[NSArray alloc] initWithContentsOfFile:plistPath];
				NSLog(@"chantDetailArray :%@",chantDetailArray);
				NSLog(@"chantDetailArrayobjectAtIndex:2] : %@",[chantDetailArray objectAtIndex:2]);
				NSLog(@"[itemOrderArray objectAtIndex:i] : %@",[itemOrderArray objectAtIndex:i]);
				
				if ([[itemOrderArray objectAtIndex:i] isEqualToString:[chantDetailArray objectAtIndex:2]]) 
				{
					NSLog(@"YES product id finds equal");
					[chantDirectoryArray addObject:[NSString stringWithFormat:@"%@/",[directoryPath stringByAppendingString:s]]];
                    NSLog(@"chant dir array %@", chantDirectoryArray);
					[chantNameArray addObject:[chantDetailArray objectAtIndex:0]];
					[chantIconArray addObject:[chantDetailArray objectAtIndex:1]];
					[displayProductOrderArray addObject:[chantDetailArray objectAtIndex:2]];
					
					break;
				}
			}
		}
	}
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
        }
        else
        {
            [self changeViewForLandscapeMode];
        }
    }
    
    UISwipeGestureRecognizer *showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [mTableView addGestureRecognizer:showExtrasSwipe];
    
    UISwipeGestureRecognizer *recognizerRITE = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRITE)];
    [recognizerRITE setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recognizerRITE];
    
	[super viewDidLoad];
}
-(void)handleSwipeRITE
{
    
    
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
        [self.mTableView reloadData];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
    {
        [self.adView removeFromSuperview];
        self.adView.delegate = nil;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            GetMoreButton.frame = CGRectMake(GetMoreButton.frame.origin.x, 330,GetMoreButton.frame.size.width,GetMoreButton.frame.size.height);
            self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 380);
            self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 367);

        }
        if(result.height == 568)
        {

           GetMoreButton.frame = CGRectMake(GetMoreButton.frame.origin.x, 413,GetMoreButton.frame.size.width,GetMoreButton.frame.size.height);
            self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 424);
        }
    }
    else{
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                [self changeViewForPortraitMode];
            }
            else
            {
                [self changeViewForLandscapeMode];
            }
            
        }
        else{
            self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPhone
                                                        size:MOPUB_BANNER_SIZE];
            self.adView.delegate = self;
            if([[UIScreen mainScreen] bounds].size.height == 480)
            {
            
            self.adView.frame = CGRectMake(0, 276,MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
            }else
            {
                   self.adView.frame = CGRectMake(0, 363,MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
                self.adView.backgroundColor=[UIColor clearColor];
            }
            [self.view addSubview:self.adView];
            [self.adView loadAd];
        }
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
           GetMoreButton.frame = CGRectMake(GetMoreButton.frame.origin.x, 324,GetMoreButton.frame.size.width,GetMoreButton.frame.size.height);
       
            self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 270);
        
        }
        if(result.height == 568)
        {
   
            
           GetMoreButton.frame = CGRectMake(GetMoreButton.frame.origin.x, 413,GetMoreButton.frame.size.width,GetMoreButton.frame.size.height);
            self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 424);
        }
        
    }
   
}
- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		self.editing=NO;
		[mTableView setEditing:NO animated:NO];
		[mTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		self.editing=YES;
		[mTableView setEditing:YES animated:YES];
		[mTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

-(void)SettingButton
{
    _settingsClicked=true;
    SettingViewController  *objSettingsController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    objSettingsController.narrationArray=narrationArray;
    objSettingsController.displayArray=displayArray;
    objSettingsController.productIDArray=displayProductOrderArray;
    objSettingsController.paidOrFree=paidOrFree;
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:objSettingsController];
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone)
    {
        [self.navigationController pushViewController:objSettingsController animated:YES];
        //[self presentModalViewController:objSettingsController animated:YES];
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
        objSettingsController.delegate = self;
        self.mPopOverController=[[UIPopoverController alloc] initWithContentViewController:navigationController] ;
        self.popOverController = self.mPopOverController;
        [objSettingsController setContentSizeForViewInPopover:CGSizeMake(320, 416)];
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self changeViewForPortraitMode];
            
        }
        else
        {
            [self changeViewForLandscapeMode];
            
        }
    }
}

-(IBAction) settingButtonClicked
{

}
-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:mTableView];
    NSIndexPath *swipedIndexPath = [mTableView indexPathForRowAtPoint:location];
    
    
    //   NSLog(@"%@",swipedCell);
    NSLog(@"%d",swipedIndexPath.row);
    
    
    NSLog(@"chant Dir Array %@", chantDirectoryArray);
	NSString *xmlPath=[NSBundle pathForResource:kChantXML ofType:@"xml" inDirectory:
                       [chantDirectoryArray objectAtIndex:swipedIndexPath.row]];
	if (xmlPath!=nil)
	{
		
		NSData *data=[NSData dataWithContentsOfFile:xmlPath];
		NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithData:data];
		
		ItemParser *itemParser=[[ItemParser alloc] initAatmanXMLParser];
		[xmlParser setDelegate:itemParser];
		
		BOOL b=[xmlParser parse];
		if(b==YES)
			NSLog(@"Success");
		else
			NSLog(@"Error!!");
		//[itemParser release];
		//[xmlParser release];
	}

    
    NSLog(@"PRODUCT ID ARRAY %@",productIDArray);
    NSLog(@"DISPLAY PRODUCT ORDER ARRAY %@",displayProductOrderArray);
    
	NSInteger index=[productIDArray indexOfObject:[displayProductOrderArray objectAtIndex:swipedIndexPath.row]];
    
    PlayerViewController *temp = [[PlayerViewController alloc] init];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        temp=[[PlayerViewController alloc]initWithNibName:@"PlayerViewController-iPad" bundle:
              [NSBundle mainBundle]];
    }
    else{
        temp=[[PlayerViewController alloc]initWithNibName:@"PlayerViewController" bundle:
              [NSBundle mainBundle]];
    }
    
	//temp.session=session;
	NSLog(@"INDEX %d", index);
	if (index!=NSNotFound)
		temp.playingItemIndex=index;
	else
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Product ID" message:@"Product IDs mismatch"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	//temp.playingItemIndex=indexPath.row;
	temp.selectedRowIndex=swipedIndexPath.row;
	temp.chantDirectoryArray=chantDirectoryArray;
	temp.productIDArray=displayProductOrderArray;
	
	temp.timeArrayIndex=0;
    NSLog(@"DIRECTORY PATH %@",temp.directoryPath);
    NSLog(@"CHANT DIR ARRAY %@",chantDirectoryArray);
    
	temp.directoryPath=[chantDirectoryArray objectAtIndex:swipedIndexPath.row];
	[self.navigationController pushViewController:temp animated:YES];
    
 //   [self.mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
	

}
#pragma mark Table view methods


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	viewFooter.backgroundColor = [UIColor clearColor];
	return viewFooter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	
	return [chantNameArray count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    UITableViewCell *cell=nil;
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
    }
	NSString *path=[NSBundle pathForResource:[chantIconArray objectAtIndex:indexPath.row] ofType:@"png" inDirectory:[chantDirectoryArray objectAtIndex:indexPath.row]]; 
																												 

    
    if([[UIDevice currentDevice] userInterfaceIdiom]== UIUserInterfaceIdiomPad){
        	cell.textLabel.text = [chantNameArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
    else{
        CBAutoScrollLabel *marqueLbl=[[CBAutoScrollLabel alloc]init];
    marqueLbl.labelSpacing = 35; // distance between start and end labels
    marqueLbl.pauseInterval = 1.7; // seconds of pause before scrolling starts again
    marqueLbl.scrollSpeed = 20; // pixels per second
    //   marqueLbl.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    
    marqueLbl.frame=CGRectMake(90, 8, 200, 50);
    marqueLbl.fadeLength = 12.f;
    marqueLbl.scrollDirection = CBAutoScrollDirectionLeft;
    marqueLbl.text=[chantNameArray objectAtIndex:indexPath.row];
    [cell addSubview:marqueLbl];
    [ marqueLbl observeApplicationNotifications];
    }

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if(path!=nil)
		cell.imageView.image=[UIImage imageWithContentsOfFile:path];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
 //   cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    
	NSLog(@"chant Dir Array %@", chantDirectoryArray);
	NSString *xmlPath=[NSBundle pathForResource:kChantXML ofType:@"xml" inDirectory: 
																	[chantDirectoryArray objectAtIndex:indexPath.row]];
	if (xmlPath!=nil)
	{
		
		NSData *data=[NSData dataWithContentsOfFile:xmlPath];
		NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithData:data];
		
		ItemParser *itemParser=[[ItemParser alloc] initAatmanXMLParser];
		[xmlParser setDelegate:itemParser];
		
		BOOL b=[xmlParser parse];
		if(b==YES)
			NSLog(@"Success");
		else 
			NSLog(@"Error!!");
		//[itemParser release];
		//[xmlParser release];
	}
    NSLog(@"PRODUCT ID ARRAY %@",productIDArray);
    NSLog(@"DISPLAY PRODUCT ORDER ARRAY %@",displayProductOrderArray);
    
	NSInteger index=[productIDArray indexOfObject:[displayProductOrderArray objectAtIndex:indexPath.row]];
    
    PlayerViewController *temp = [[PlayerViewController alloc] init];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        temp=[[PlayerViewController alloc]initWithNibName:@"PlayerViewController-iPad" bundle:
                                    [NSBundle mainBundle]];
    }
    else{
        temp=[[PlayerViewController alloc]initWithNibName:@"PlayerViewController" bundle:
								[NSBundle mainBundle]];
    }
    
	//temp.session=session;
	NSLog(@"INDEX %d", index);
	if (index!=NSNotFound)
		temp.playingItemIndex=index;
	else
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Product ID" message:@"Product IDs mismatch" 
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	//temp.playingItemIndex=indexPath.row;
	temp.selectedRowIndex=indexPath.row;
	temp.chantDirectoryArray=chantDirectoryArray;
	temp.productIDArray=displayProductOrderArray;
	
	temp.timeArrayIndex=0;
    NSLog(@"DIRECTORY PATH %@",temp.directoryPath);
    NSLog(@"CHANT DIR ARRAY %@",chantDirectoryArray);
      NSLog(@"display product order id %@",displayProductOrderArray);
    
    
    
	temp.directoryPath=[chantDirectoryArray objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:temp animated:YES];
    
    [self.mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
	
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	
}*/
#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath 
{
	
	//chantName, chantIcon, displayOrder, chantDirectory and chantOrder plist needs to update then reload the table
	
	NSString *chantname=[chantNameArray objectAtIndex:fromIndexPath.row ];
	[chantNameArray removeObjectAtIndex:fromIndexPath.row];
	[chantNameArray insertObject:chantname atIndex:toIndexPath.row];

	
	NSString *chanticon=[chantIconArray objectAtIndex:fromIndexPath.row];
	[chantIconArray removeObjectAtIndex:fromIndexPath.row];
	[chantIconArray insertObject:chanticon atIndex:toIndexPath.row];
		
	NSString *chantdirectory=[chantDirectoryArray objectAtIndex:fromIndexPath.row];
	[chantDirectoryArray removeObjectAtIndex:fromIndexPath.row];
	[chantDirectoryArray insertObject:chantdirectory atIndex:toIndexPath.row];
	
	
	NSString *displayOrderPID=[displayProductOrderArray objectAtIndex:fromIndexPath.row];
	[displayProductOrderArray removeObjectAtIndex:fromIndexPath.row];
	[displayProductOrderArray insertObject:displayOrderPID atIndex:toIndexPath.row];
		
	NSString *chantOrderPlistPath=[NSBundle pathForResource:kChantOrderPlist ofType:@"plist" inDirectory:directoryPath];
	[displayProductOrderArray writeToFile:chantOrderPlistPath atomically:YES];
	
		
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([[chantNameArray objectAtIndex:indexPath.row] isEqualToString:kDefaultPackage])
		return UITableViewCellEditingStyleNone;
	else {
		return UITableViewCellEditingStyleDelete;
	}
    
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}
- (void)adViewDidLoadAd:(MPAdView *)view
{
}
-(void)adViewDidFailToLoadAd:(MPAdView *)view
{
    
    self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, 315);
    
    
    self.adView.hidden = YES;
    self.adView = nil;
}
#pragma mark -  AUDIO SETTINGS DELEGATE
-(void)reflectSettingsChanges
{
    _settingsClicked=false;
    [self.popOverController dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
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
}
-(void)changeViewForLandscapeMode
{
    self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, 1024, 768);
  //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Landscape.png"];
    
    
    self.imgViewBG.frame = CGRectMake(0, 600, 1024, 768);
    self.btnSettings.frame = CGRectMake(450, 608, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height);
    
    //POPOVER
    if (_settingsClicked) {
        self.popOverController.popoverContentSize = CGSizeMake(320, 416);
        
        if(self.view.window!=nil){
          [self.mPopOverController presentPopoverFromRect:CGRectMake(270, 140, 320, 416) inView:self.view permittedArrowDirections:0 animated:YES];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
    {
        [self.adView removeFromSuperview];
        self.adView.delegate = nil;
        
//        self.imgViewBG.frame = CGRectMake(0, 655, 1024, 49);
//        self.btnSettings.frame = CGRectMake(450, 660, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height);
    }
    else{
        self.adView.hidden = YES;
        self.adView = nil;
        self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad
                                                    size:MOPUB_BANNER_SIZE];
        self.adView.delegate = self;
        self.adView.frame = CGRectMake(0, 510,1024, 90);
        self.adView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.adView];
        [self.adView loadAd];
        
//        self.imgViewBG.frame = CGRectMake(0, 570, 1024, 49);
//        self.btnSettings.frame = CGRectMake(460, 575, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height);
        
    }
}

-(void)changeViewForPortraitMode
{
    self.imgViewBackground.frame = CGRectMake(self.imgViewBackground.frame.origin.x, self.imgViewBackground.frame.origin.y, 768, 1004);
  //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_Portrait.png"];
    
    self.imgViewBG.frame = CGRectMake(self.imgViewBG.frame.origin.x, 867, self.imgViewBG.frame.size.width, self.imgViewBG.frame.size.height);
    
    
    self.btnSettings.frame = CGRectMake(336, 874, self.btnSettings.frame.size.width, self.btnSettings.frame.size.height);
    
    //POPOVER
    if (_settingsClicked) {
        self.popOverController.popoverContentSize = CGSizeMake(320, 416);
        if(self.view.window!=nil) {
        [self.mPopOverController presentPopoverFromRect:CGRectMake(200, 240, 320, 416) inView:self.view permittedArrowDirections:0 animated:YES];
        }
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
    {
        [self.adView removeFromSuperview];
        self.adView.delegate = nil;
        
    }
    else
    {
        self.adView.hidden = YES;
        self.adView = nil;
        self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad                                                     size:MOPUB_LEADERBOARD_SIZE];
        self.adView.delegate = self;
        self.adView.frame = CGRectMake(0, 780,768, 90);
        self.adView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.adView];
        [self.adView loadAd];
        
     
    }
}

- (IBAction)GetMoreButtonAction:(id)sender {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
    else{
        GetPackageListViewController  *addController1 = [[GetPackageListViewController alloc]initWithNibName:@"GetPackageListViewController-iPad" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addController1];
        [self presentModalViewController:navigationController animated:YES];
    }
}
@end
