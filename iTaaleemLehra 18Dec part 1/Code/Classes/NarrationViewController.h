//
//  NarrationViewController.h
//  iAatman
//
//  Created by iPhone Developer on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ConstantInApps.h"

@protocol NarrationSettingsDelegate <NSObject>
-(void)reflectSettingsChanges;

@end


@interface NarrationViewController : UIViewController {
	UITableView *mTableView;
	
	NSMutableArray *narrations;
	NSMutableArray *userDefaultProductIDArray;
	NSMutableArray *productIDArray;
	NSMutableArray *narrationTypes;
	NSInteger narrationSelectedIndex;

}
@property (strong, nonatomic) id<NarrationSettingsDelegate>delegate;
@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *narrations;
@property(nonatomic)NSInteger narrationSelectedIndex;

@property(nonatomic,strong)NSMutableArray *userDefaultProductIDArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;
@property(nonatomic,strong)NSMutableArray *narrationTypes;

@property(nonatomic, strong) IBOutlet UIImageView *imgViewBackground;

@end
