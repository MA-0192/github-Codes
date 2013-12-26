//
//  SettingViewController.h
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Narration.h"
#import "Display.h"
#import "Constants.h"
#import "NarrationViewController.h"
#import "DisplayLanguageViewController.h"
#import "AudioModeViewController.h"
#import "ConstantInApps.h"
#import "SettingViewController.h"

@protocol SettingsViewDelegate <NSObject>
-(void)reflectSettingsChanges;
@end

@interface SettingViewController : UIViewController <AudioSettingsDelegate,NarrationSettingsDelegate,DisplayLanguageSettingsDelegate> {
	
	NSMutableArray *productIDArray;
	NSMutableArray *narrationArray;
	NSMutableArray *displayArray;
	NSString *paidOrFree;
	
	NSMutableArray *availableSettingArray;
	UITableView *mTableView;
	UILabel *noSettingLabel;
}

@property (strong, nonatomic) id<SettingsViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *availableSettingArray;
@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)IBOutlet UILabel *noSettingLabel;

@property(nonatomic,strong)NSMutableArray *productIDArray;
@property(nonatomic,strong)NSMutableArray *narrationArray;
@property(nonatomic,strong)NSMutableArray *displayArray;
@property(nonatomic,strong)NSString *paidOrFree;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;

-(IBAction)doneButtonPressed:(id)sender;

@end
