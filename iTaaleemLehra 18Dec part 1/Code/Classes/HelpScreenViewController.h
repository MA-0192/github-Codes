//
//  HelpScreenViewController.h
//  iChant
//
//  Created by Vivek Yadav on 12/16/13.
//
//

#import <UIKit/UIKit.h>

@interface HelpScreenViewController : UIViewController<UITabBarControllerDelegate>
- (IBAction)okButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *checkButton;

@end
