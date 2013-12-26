//
//  AudioModeViewController.m
//  iAatman
//
//  Created by iPhone Developer on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AudioModeViewController.h"


@implementation AudioModeViewController
@synthesize mTableView;
@synthesize noOfTimesPicker;
@synthesize timeDurationPicker;
@synthesize productIDArray;
@synthesize noOfTimes;
@synthesize noOfSecs;
@synthesize userDefaultProductIDArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;
@synthesize selectedAudioSettingArray;
@synthesize selectedAudioSetting;
@synthesize audioSettingsType;
@synthesize pickerData;

@synthesize imgViewBackground;
@synthesize delegate = _delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		productIDArray=[[NSMutableArray alloc] init];
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

    
	self.title=@"Audio Mode Setting";
//	self.navigationController.navigationBar.tintColor=[UIColor clearColor];
	mTableView.backgroundColor=[UIColor clearColor];
	pickerData=[[NSMutableArray alloc] init];
	for (int i=1; i<=100; i++) {
		NSString *number=[NSString stringWithFormat:@"%d",i];
		[pickerData addObject:number];
	}
	
	selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
	numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
	numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
	userDefaultProductIDArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID] mutableCopy];
    
    NSLog(@"userDefaultsProductIdArray = %@",userDefaultProductIDArray);
    NSLog(@"productIdArray = %@",productIDArray);
	
	int itemIndex=[userDefaultProductIDArray indexOfObject:[productIDArray objectAtIndex:0]];
	audioSettingsType=[[NSMutableArray alloc] initWithObjects:@"Continuous",@"Number of Times",@"Time Duration",nil];
    NSLog(@"selectedAudioSetting Array = %@",selectedAudioSettingArray);
	selectedAudioSetting=[[selectedAudioSettingArray objectAtIndex:itemIndex] intValue];
	noOfTimes=[[numberOfTimesArray objectAtIndex:itemIndex] intValue];
	noOfSecs=[[numberOfSecondArray objectAtIndex:itemIndex] intValue];
	
	
	if(selectedAudioSetting==0)
	{
		noOfTimesPicker.hidden=YES;
		timeDurationPicker.hidden=YES;
	}
	else if(selectedAudioSetting==1)
	{
		noOfTimesPicker.hidden=NO;
		[noOfTimesPicker selectRow:noOfTimes-1 inComponent:0 animated:YES];
		timeDurationPicker.hidden=YES;
	}
	else
	{
		noOfTimesPicker.hidden=YES;
		timeDurationPicker.hidden=NO;
		timeDurationPicker.countDownDuration=noOfSecs;
		
	}
	
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
       // self.imgViewBackground.image = [UIImage imageNamed:@"Bg_iPhone.png"];
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
	
		NSInteger index=[userDefaultProductIDArray indexOfObject:[productIDArray objectAtIndex:i]];
		[selectedAudioSettingArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",selectedAudioSetting]];
		[numberOfTimesArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",noOfTimes]];
		[numberOfSecondArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",noOfSecs]];
		[[NSUserDefaults standardUserDefaults] setObject:selectedAudioSettingArray forKey:kSelectedAudioSetting];
		[[NSUserDefaults standardUserDefaults] setObject:numberOfTimesArray forKey:kNumberOfTimesArray];
		[[NSUserDefaults standardUserDefaults] setObject:numberOfSecondArray forKey:kNumberOfSecondsArray];
	}
	
}


-(IBAction) timeDurationPickerValueChanged
{
	noOfSecs=timeDurationPicker.countDownDuration;
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
	
	return [audioSettingsType count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

	cell.textLabel.text = [audioSettingsType objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
	if(indexPath.row==selectedAudioSetting)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType=UITableViewCellAccessoryNone;
    
 //   cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu.png"]];
    
 //   cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_mainmenu_touch.png"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedAudioSetting=indexPath.row;
	
	if(selectedAudioSetting==0)
	{
		noOfTimesPicker.hidden=YES;
		timeDurationPicker.hidden=YES;
	}
	else if(selectedAudioSetting==1)
	{
		noOfTimesPicker.hidden=NO;
		[noOfTimesPicker selectRow:noOfTimes-1 inComponent:0 animated:YES];
		timeDurationPicker.hidden=YES;
	}
	else
	{
		noOfTimesPicker.hidden=YES;
		timeDurationPicker.hidden=NO;
		timeDurationPicker.countDownDuration=noOfSecs;
	}
	[tableView reloadData];
	
}
#pragma mark Picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerData count];
}
#pragma mark Picker delegate Methods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerData objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
	noOfTimes=[[pickerData objectAtIndex:row] intValue];
	
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
