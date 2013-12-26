//
//  DisplayLanguageViewController.m
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DisplayLanguageViewController.h"


@implementation DisplayLanguageViewController
@synthesize mTableView;
@synthesize displayLanguageTypes;
@synthesize displayLanguages;
@synthesize displayLanguageIndex;

@synthesize userDefualtProductIDArray;
@synthesize productIDArray;

@synthesize imgViewBackground;
@synthesize delegate = _delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	displayLanguageTypes=[[NSMutableArray alloc] init];
	productIDArray=[[NSMutableArray alloc] init];
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    
	self.title=@"Display Language";
//	self.navigationController.navigationBar.tintColor=[UIColor clearColor];
	displayLanguages=[[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages] mutableCopy];
	userDefualtProductIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
	NSInteger index=[userDefualtProductIDArray indexOfObject:[productIDArray objectAtIndex:0]];
	
	displayLanguageIndex=[[displayLanguages objectAtIndex:index] intValue];
	self.mTableView.backgroundColor=[UIColor clearColor];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
      //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
    }
    if(result.height == 568)
    {
      //  self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPod.png"];
    }
    
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
	for (int i=0; i<[productIDArray count]; i++) 
	{
	NSInteger index=[userDefualtProductIDArray indexOfObject:[productIDArray objectAtIndex:i]];
	
	[displayLanguages replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",displayLanguageIndex]];
	[[NSUserDefaults standardUserDefaults] setObject:displayLanguages forKey:kDisplayLanguages];
	}
		
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
	
	return [displayLanguageTypes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

	cell.textLabel.text = [displayLanguageTypes objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
	if(indexPath.row==displayLanguageIndex)
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType=UITableViewCellAccessoryNone;

 //   cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
  //  cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	displayLanguageIndex=indexPath.row;
	[tableView reloadData];
	
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
