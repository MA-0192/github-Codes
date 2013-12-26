//
//  MoreViewController.m
//  iChant
//
//  Created by Vivek Yadav on 11/28/13.
//
//

#import "MoreViewController.h"
#import "CBAutoScrollLabel.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"More", @"More");
  //      self.tabBarItem.image = [UIImage imageNamed:@"moretab.png"];
        
        [  self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                                   [UIFont fontWithName:@"Helvetica" size:12.0], UITextAttributeFont, nil]
                                         forState:UIControlStateNormal];

        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"moretab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"moretab.png"]];

        
        self.tabBarItem.title=@"More";
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
 moreArray=[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iTunesAppList" ofType:@"plist"]];
	
    
    NSLog(@"%@",moreArray);
    
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
	
	return [moreArray count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=nil;
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
    }

    
    
    if([[UIDevice currentDevice] userInterfaceIdiom]== UIUserInterfaceIdiomPad){
        cell.textLabel.text = [[moreArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
    else{
        CBAutoScrollLabel *marqueLbl=[[CBAutoScrollLabel alloc]init];
        marqueLbl.labelSpacing = 35; // distance between start and end labels
        marqueLbl.pauseInterval = 1.7; // seconds of pause before scrolling starts again
        marqueLbl.scrollSpeed = 20; // pixels per second
        
        marqueLbl.frame=CGRectMake(90, 8, 200, 50);
        marqueLbl.fadeLength = 12.f;
        marqueLbl.scrollDirection = CBAutoScrollDirectionLeft;
        marqueLbl.text=[[moreArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        [cell addSubview:marqueLbl];
        [ marqueLbl observeApplicationNotifications];
    }
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	

    cell.imageView.image=[UIImage imageNamed:[[moreArray objectAtIndex:indexPath.row] objectForKey:@"ImageName"]];
    

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[moreArray objectAtIndex:indexPath.row] objectForKey:@"Link"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
