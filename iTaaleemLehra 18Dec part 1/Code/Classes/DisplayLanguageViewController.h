//
//  DisplayLanguageViewController.h
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ConstantInApps.h"

@protocol DisplayLanguageSettingsDelegate <NSObject>
-(void)reflectSettingsChanges;

@end

@interface DisplayLanguageViewController : UIViewController {
	UITableView *mTableView;
	NSMutableArray *displayLanguageTypes;//Array to display the cells of the table
	NSMutableArray *displayLanguages;// array to be set into user defaults
	NSMutableArray *userDefualtProductIDArray;
	NSMutableArray *productIDArray;
	NSInteger displayLanguageIndex;
}
@property (strong, nonatomic) id<DisplayLanguageSettingsDelegate>delegate;
@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *displayLanguageTypes;
@property(nonatomic,strong)NSMutableArray *displayLanguages;
@property(nonatomic)NSInteger displayLanguageIndex;

@property(nonatomic,strong)NSMutableArray *userDefualtProductIDArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;

@end
