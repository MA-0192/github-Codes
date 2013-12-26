//
//  AudioModeViewController.h
//  iAatman
//
//  Created by iPhone Developer on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ConstantInApps.h"

@protocol AudioSettingsDelegate <NSObject>
-(void)reflectSettingsChanges;

@end

@interface AudioModeViewController : UIViewController {
	
	UITableView *mTableView;
	UIPickerView *noOfTimesPicker;
	UIDatePicker *timeDurationPicker;
	
	NSMutableArray *productIDArray;
	
	NSInteger selectedAudioSetting;
	NSInteger noOfTimes;
	
	NSInteger noOfSecs;
	NSMutableArray *userDefaultProductIDArray;
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;
	NSMutableArray *audioSettingsType;
	NSMutableArray *pickerData;
}

@property (strong, nonatomic) id<AudioSettingsDelegate>delegate;
@property(nonatomic,strong)IBOutlet UITableView *mTableView;
@property(nonatomic,strong)IBOutlet UIPickerView *noOfTimesPicker;
@property(nonatomic,strong)IBOutlet UIDatePicker *timeDurationPicker;
@property(nonatomic,strong)NSMutableArray *productIDArray;
@property(nonatomic)NSInteger selectedAudioSetting;
@property(nonatomic)NSInteger noOfTimes;
@property(nonatomic) NSInteger noOfSecs;

@property(nonatomic,strong)NSMutableArray *userDefaultProductIDArray;
@property(nonatomic,strong)NSMutableArray *numberOfTimesArray;
@property(nonatomic,strong)NSMutableArray *numberOfSecondArray;
@property(nonatomic,strong)NSMutableArray *selectedAudioSettingArray;
@property(nonatomic,strong)NSMutableArray *audioSettingsType;
@property(nonatomic,strong)NSMutableArray *pickerData;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;

-(IBAction) timeDurationPickerValueChanged;
@end
