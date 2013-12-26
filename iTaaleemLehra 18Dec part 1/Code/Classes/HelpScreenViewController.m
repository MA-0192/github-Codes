//
//  HelpScreenViewController.m
//  iChant
//
//  Created by Vivek Yadav on 12/16/13.
//
//

#import "HelpScreenViewController.h"

@interface HelpScreenViewController ()

@end

@implementation HelpScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
       self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}
- (IBAction)okButtonClicked:(id)sender {
    
     self.tabBarController.tabBar.hidden=NO;
   [self dismissModalViewControllerAnimated:NO];
}
- (IBAction)checkButtonClicked:(id)sender {
    
    if (self.checkButton.currentImage==[UIImage imageNamed:@"checked.png"]) {
        
         [self.checkButton setImage :[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
         [ [NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"help" ];
    }
    else
    {
     [self.checkButton setImage :[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        
        [ [NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"help" ];
        
    }
//	[self.infoViewEnableButton setImage:[UIImage imageNamed:@"borders.png"] forState:UIControlStateNormal];
    
}
@end
