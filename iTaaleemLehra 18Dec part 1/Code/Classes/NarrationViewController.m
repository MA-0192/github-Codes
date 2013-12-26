//
//  NarrationViewController.m
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NarrationViewController.h"

@implementation NarrationViewController
@synthesize mTableView;
@synthesize narrations;
@synthesize narrationSelectedIndex;

@synthesize userDefaultProductIDArray;
@synthesize productIDArray;
@synthesize narrationTypes;

@synthesize imgViewBackground;
@synthesize delegate = _delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		narrationTypes=[[NSMutableArray alloc] init];
		productIDArray=[[NSMutableArray alloc] init];
        // Custom initialization
    }
	
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    
//	self.navigationController.navigationBar.tintColor=[UIColor clearColor];
	self.title=@"Narration Setting";
	narrations=[[[NSUserDefaults standardUserDefaults] objectForKey:kNarration] mutableCopy];
	userDefaultProductIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
	NSInteger index=[userDefaultProductIDArray indexOfObject:[productIDArray objectAtIndex:0]];
	narrationSelectedIndex=[[narrations objectAtIndex:index] intValue];
	mTableView.backgroundColor=[UIColor clearColor];
    
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
	for (int i=0; i<[productIDArray count]; i++) {
	NSInteger index=[userDefaultProductIDArray indexOfObject:[productIDArray objectAtIndex:i]];
	
	[narrations replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",narrationSelectedIndex]];
	[[NSUserDefaults standardUserDefaults] setObject:narrations forKey:kNarration];
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
	
	return [narrationTypes count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    

    
	if(indexPath.row==[narrationTypes count])
		cell.textLabel.text=@"None";
	else
	cell.textLabel.text = [narrationTypes objectAtIndex:indexPath.row] ;
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
	
	if(indexPath.row==narrationSelectedIndex)
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
	else 
		cell.accessoryType=UITableViewCellAccessoryNone;

  //  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
 //   cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
	 
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	narrationSelectedIndex=indexPath.row;
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
