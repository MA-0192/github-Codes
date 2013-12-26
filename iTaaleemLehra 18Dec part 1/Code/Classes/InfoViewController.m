//
//  InfoViewController.m
//  LDSAT
//
//  Created by MediaAgility on 06/12/12.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize infowebView = _infowebView;
@synthesize barButtonDone = _barButtonDone;
@synthesize txtView = _txtView;
@synthesize adView = _adView;

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
    
    


   
    //CLEAR BACKGROUND COLOR OF INFO WEBVIEW AND MAKE IT OPAQUE
    [self.infowebView setBackgroundColor:[UIColor clearColor]];
    [self.infowebView setOpaque:NO];
    self.infowebView.delegate = self;
    [self.infowebView setScalesPageToFit:YES];
    [self.infowebView setMultipleTouchEnabled:NO];
    [self.infowebView.scrollView setBouncesZoom:NO];
    
    self.barButtonDone.title = @"Done";
	self.barButtonDone.style = UIBarButtonSystemItemDone;
    
    
	self.navigationItem.rightBarButtonItem = self.barButtonDone;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.title = @"FAQ's";
    
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
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            
        }
        if(result.height == 568)
        {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568);
            self.infowebView.frame = CGRectMake(self.infowebView.frame.origin.x, self.infowebView.frame.origin.y, self.infowebView.frame.size.width, 460);
            self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, self.txtView.frame.origin.y, self.txtView.frame.size.width, 460);
        }
    }
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.barButtonDone.tintColor=[UIColor whiteColor];
    }
    
    [self FAQ];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
-(void)FAQ
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"html" inDirectory:nil];
    [self.infowebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]];
}

-(IBAction)barButtonDoneClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.infowebView.frame = CGRectMake(20, 60, 950, 650);
    self.txtView.frame = CGRectMake(20, 60, 950, 650);
}

-(void)changeViewForPortraitMode
{
    self.view.frame = CGRectMake(0, 0, 768,1004);
    self.infowebView.frame = CGRectMake(29, 40, 704, 927); 
    self.txtView.frame = CGRectMake(29, 40, 704, 927);
}

@end
