//
//  InfoViewController.h
//  LDSAT
//
//  Created by MediaAgility on 06/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MPAdView.h"

@interface InfoViewController : UIViewController <UIWebViewDelegate, MPAdViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIWebView *infowebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonDone;
@property (strong, nonatomic) IBOutlet UITextView *txtView;

@property (strong, nonatomic) MPAdView *adView;

-(void)FAQ;
-(IBAction)barButtonDoneClicked;

-(void)changeViewForLandscapeMode;
-(void)changeViewForPortraitMode;

@end
