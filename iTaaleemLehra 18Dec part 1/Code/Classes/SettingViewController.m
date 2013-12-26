//
//  SettingViewController.m
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController
@synthesize availableSettingArray;
@synthesize mTableView;
@synthesize noSettingLabel;

@synthesize productIDArray;
@synthesize narrationArray;
@synthesize displayArray;
@synthesize paidOrFree;

@synthesize imgViewBackground;
@synthesize delegate = _delegate;
@synthesize doneButton = _doneButton;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		productIDArray=[[NSMutableArray alloc] init];
		narrationArray=[[NSMutableArray alloc] init];
		displayArray=[[NSMutableArray alloc] init];
		NSLog(@"Came into nib method");
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent=NO;
        //self.toolbarItems.=NO;
    }
    
	NSLog(@"Came into view did load of setting");
//	self.navigationController.navigationBar.tintColor=[UIColor clearColor];
	self.title=@"Settings";
	mTableView.backgroundColor=[UIColor clearColor];
	availableSettingArray=[[NSMutableArray alloc]init];
	NSLog(@"Paid or free:%@",paidOrFree);
    
    if([paidOrFree  isEqualToString:@"paid"])
		[availableSettingArray addObject:@"Playing Mode"];
	if ([narrationArray count]!=0) {
		[availableSettingArray addObject:@"Narration Language"];
	}
	if ([displayArray count]!=0) {
		[availableSettingArray addObject:@"Display Language"];
	}
	/*UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.leftBarButtonItem=done;*/
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
    //    self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
    }
    if(result.height == 568)
    {
     //   self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
    }
    
    if([[UIDevice currentDevice] userInterfaceIdiom]== UIUserInterfaceIdiomPad)
    {
        self.doneButton.title = @"Done";
        self.doneButton.style = UIBarButtonSystemItemDone;
    
        self.navigationItem.rightBarButtonItem = self.doneButton;
        
    }
    
    [super viewDidLoad];
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
	if ([availableSettingArray count]==0) {
		noSettingLabel.hidden=NO;
	}
	else {
		noSettingLabel.hidden=YES;
	}

	
	return [availableSettingArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
	cell.textLabel.text = [availableSettingArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
  //  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
  //  cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *selectedSetting=[availableSettingArray objectAtIndex:indexPath.row];
	
	if ([selectedSetting isEqualToString:@"Playing Mode"]) {
		AudioModeViewController *audioModeController=[[AudioModeViewController alloc] initWithNibName:@"AudioModeViewController" bundle:[NSBundle mainBundle]];
        NSLog(@"productid array %@", productIDArray);
		audioModeController.productIDArray=productIDArray;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.navigationController pushViewController:audioModeController animated:YES];

        }
        else
        {
            audioModeController.delegate = self;
            [self.navigationController pushViewController:audioModeController animated:YES];
            [audioModeController setContentSizeForViewInPopover:CGSizeMake(320, 416)];
        }
        
				
	}
	else if([selectedSetting isEqualToString:@"Narration Language"])
	{
		
		NarrationViewController *narrationController=[[NarrationViewController alloc] initWithNibName:@"NarrationViewController" bundle:[NSBundle mainBundle]];
		narrationController.productIDArray=productIDArray;
		for (int i=0; i<[narrationArray count]; i++) {
			
			[narrationController.narrationTypes addObject:[narrationArray objectAtIndex:i]];
		}
		
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.navigationController pushViewController:narrationController animated:YES];
            
        }
        else
        {
            narrationController.delegate = self;
            [self.navigationController pushViewController:narrationController animated:YES];
            [narrationController setContentSizeForViewInPopover:CGSizeMake(320, 416)];
        }
        
    }
	else
	{
		DisplayLanguageViewController *displayController=[[DisplayLanguageViewController alloc] initWithNibName:@"DisplayLanguageViewController" bundle:[NSBundle mainBundle]];
		displayController.productIDArray=productIDArray;
		for (int j=0; j<[displayArray count]; j++) {
			
			[displayController.displayLanguageTypes addObject:[displayArray objectAtIndex:j]];
		}
		if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.navigationController pushViewController:displayController animated:YES];
            
        }
        else
        {
            displayController.delegate = self;
            [self.navigationController pushViewController:displayController animated:YES];
            [displayController setContentSizeForViewInPopover:CGSizeMake(320, 416)];
        }
	}
	
	
	
}
-(IBAction)doneButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [_delegate reflectSettingsChanges];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
