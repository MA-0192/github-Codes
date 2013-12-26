//
//  iChantAppDelegate.h
//  iChant
//
//  Created by iPhone Developer on 9/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "Item.h"
#import "Constants.h"
#import "ProductWebRequest.h"
#import "ConstantInApps.h"

@class iChantViewController;

@interface iChantAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
    iChantViewController *viewController;
	UINavigationController *mNavigationController;
	
	NSInteger updateInfoViewNumber;
	
	Item *playingItem;
	//download chant and InApp Variables
	NSMutableArray *productArray;
	NSMutableArray *productRequestArray;
	NSMutableArray *updatesProductArray;
	NSMutableArray *progressValueArray;
	NSMutableArray *updatedDownLoadSizeArray;
	NSMutableArray *totalSizeArray;
	NSMutableArray *remainingDownloadArray;
	BOOL activeDownLoadBool;
	

	
	NSUserDefaults *userDefaults;
	NSMutableArray *narrations;
	NSMutableArray *displayLanguages;
	NSMutableArray *beadsArray;
	NSMutableArray *malasArray;
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;
	NSMutableArray *productIDArray;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) iChantViewController *viewController;
@property(nonatomic,strong)UINavigationController *mNavigationController;

@property(nonatomic)NSInteger updateInfoViewNumber;

@property(nonatomic,strong)Item *playingItem;

@property(nonatomic)BOOL activeDownLoadBool;
@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)NSMutableArray *productRequestArray;
@property(nonatomic,strong)NSMutableArray *updatesProductArray;
@property(nonatomic,strong)NSMutableArray *progressValueArray;
@property(nonatomic,strong)NSMutableArray *updatedDownLoadSizeArray;
@property(nonatomic,strong)NSMutableArray *totalSizeArray;
@property(nonatomic,strong)NSMutableArray* remainingDownloadArray;


@property(nonatomic,strong)NSMutableArray *narrations;
@property(nonatomic,strong)NSMutableArray *displayLanguages;
@property(nonatomic,strong)NSMutableArray *beadsArray;
@property(nonatomic,strong)NSMutableArray *malasArray;
@property(nonatomic,strong)NSMutableArray *selectedAudioSettingArray;
@property(nonatomic,strong)NSMutableArray *numberOfTimesArray;
@property(nonatomic,strong)NSMutableArray *numberOfSecondArray;
@property(nonatomic,strong)NSMutableArray *productIDArray;

@property(nonatomic)NSInteger updateHelpScreenNumber;
@property (strong, nonatomic) UITabBarController *tabBarController;
-(void) createUserDefualtForSampleItem;

@end

