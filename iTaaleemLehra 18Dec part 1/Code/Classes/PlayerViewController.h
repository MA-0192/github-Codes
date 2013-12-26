//
//  PlayerViewController.h
//  iAatman
//
//  Created by iPhone Developer on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "iChantAppDelegate.h"
#import "Item.h"
//#import "FBConnect/FBConnect.h"
#import "ItemParser.h"
#import "MPAdView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayerViewController : UIViewController<AVAudioPlayerDelegate, MPAdViewDelegate> {
	
	UIImageView *bgView;
	UIImageView *upperView;
	UIImageView *artistImageView;
	UILabel *artistName;
	UILabel *artistInfo;
	UILabel *beads;
	UILabel *malas;
	UILabel *beadsLabel;
	UILabel *malasLabel;
	UIImageView *lyricsView;
	UITextView *lyricsText;
	UIImageView *audioSettingView;
	UILabel *audioSettingType;
	UILabel *audioSettingCounter;
	UILabel *hhmmss;
	
	//Scrubber to move fwd/bckwd
	UIImageView *scrubberView;
	UISlider *slider;
	UILabel *playedTime;
	UILabel *remaningTime;
	
	
	Item *playingItem;
	NSString *directoryPath;
	NSInteger timeFactor;
	NSInteger playingItemIndex;
	NSInteger timeArrayIndex;
	NSInteger beadsCounter;
	NSInteger malasCounter;
	iChantAppDelegate *appdel;
//	NSUserDefaults *userDefaults;
	NSMutableArray *narrations;
	NSMutableArray *displayLanguages;
	NSMutableArray *beadsArray;
	NSMutableArray *malasArray;
	NSArray *timeArray;
	
	
	NSMutableArray *selectedAudioSettingArray;
	NSMutableArray *numberOfTimesArray;
	NSMutableArray *numberOfSecondArray;
	NSInteger selectedAudioSettingIndex;
	NSInteger noOfTimes;
	NSInteger noOfSecs;
	NSInteger noOfLoops;
	NSInteger freeBeadsCount;
	
	NSMutableArray *userDefaultProductIDArray;
	NSMutableArray *productIDArray;
	NSMutableArray *chantDirectoryArray;
	NSInteger selectedRowIndex;
	
	
	AVAudioPlayer *player;
	AVAudioPlayer *player1;
	NSTimer *loopTimer;
	NSTimer *decrementLabel;
	NSTimer *scrubberTimer;
	UIButton *playPauseBtn;
	//FBSession *session;
	
	UIImageView *textBackgroundImageView;
    __unsafe_unretained IBOutlet UIButton *volumeBtn;
        BOOL volumeEnable;
      MPMusicPlayerController *musicPlayer;
      UISlider *volumeControler;
    __unsafe_unretained IBOutlet UIButton *NextBtn;
    __unsafe_unretained IBOutlet UIButton *previous;
    
    

    
}
- (IBAction)NextBtnAction:(id)sender;
- (IBAction)previousBtnAction:(id)sender;
- (IBAction)volumeBtnAction:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *footerBg;
@property(nonatomic,retain)IBOutlet UIImageView *bgView;
@property(nonatomic,retain)IBOutlet UIImageView *upperView;
@property(nonatomic,retain)IBOutlet UIImageView *artistImageView;
@property(nonatomic,retain)IBOutlet UILabel *artistName;
@property(nonatomic,retain)IBOutlet UILabel *artistInfo;
@property(nonatomic,retain)IBOutlet UILabel *beadsLabel;
@property(nonatomic,retain)IBOutlet UILabel *malasLabel;
@property(nonatomic,retain)IBOutlet UILabel *beads;
@property(nonatomic,retain)IBOutlet UILabel *malas;
@property(nonatomic,retain)IBOutlet UIImageView *lyricsView;
@property(nonatomic,retain)IBOutlet UITextView *lyricsText;
@property(nonatomic,retain)IBOutlet UIImageView *audioSettingView;
@property(nonatomic,retain)IBOutlet UILabel *audioSettingType;
@property(nonatomic,retain)IBOutlet UILabel *audioSettingCounter;
@property(nonatomic,retain)IBOutlet UILabel *hhmmss;
@property(nonatomic,retain)IBOutlet UIButton *playPauseBtn;
@property(nonatomic,retain)IBOutlet UIImageView *scrubberView;
@property(nonatomic,retain)IBOutlet UISlider *slider;
@property(nonatomic,retain)IBOutlet UILabel *playedTime;
@property(nonatomic,retain)IBOutlet UILabel *remaningTime;

@property(nonatomic,retain)NSString *directoryPath;
@property(nonatomic)NSInteger timeFactor;
@property(nonatomic)NSInteger playingItemIndex;
@property(nonatomic)NSInteger timeArrayIndex;
@property(nonatomic)NSInteger beadsCounter;
@property(nonatomic)NSInteger malasCounter;
@property(nonatomic)NSInteger noOfTimes;
@property(nonatomic)NSInteger noOfSecs;
@property(nonatomic)NSInteger noOfLoops;
@property(nonatomic)NSInteger freeBeadsCount;
@property(nonatomic)NSInteger selectedAudioSettingIndex;

@property(nonatomic,retain)NSMutableArray *narrations;
@property(nonatomic,retain)NSMutableArray *displayLanguages;
@property(nonatomic,retain)NSMutableArray *beadsArray;
@property(nonatomic,retain)NSMutableArray *malasArray;
@property(nonatomic,retain)NSArray *timeArray;
//@property(nonatomic,retain)NSArray *directoryArray;
@property(nonatomic,retain)NSMutableArray *selectedAudioSettingArray;
@property(nonatomic,retain)NSMutableArray *numberOfTimesArray;
@property(nonatomic,retain)NSMutableArray *numberOfSecondArray;
@property(nonatomic,retain)AVAudioPlayer *player;
@property(nonatomic,retain)AVAudioPlayer *player1;
//@property(nonatomic,retain)FBSession *session;
@property(nonatomic,retain)NSTimer *loopTimer;
@property(nonatomic,retain)NSTimer *decrementLabel;
@property(nonatomic,retain)NSTimer *scrubberTimer;

@property(nonatomic,retain)NSMutableArray *userDefaultProductIDArray;
@property(nonatomic,retain)NSMutableArray *productIDArray;
@property(nonatomic,retain)NSMutableArray *chantDirectoryArray;
@property(nonatomic)NSInteger selectedRowIndex;
@property (nonatomic,retain)IBOutlet UIImageView *textBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;

@property (nonatomic, retain) IBOutlet UIToolbar *toolBarAudio;
//MOPUB BANNER ADS
@property (nonatomic,retain) MPAdView *adView;


//@property(nonatomic,retain)NSMutableArray *chantDirectoryArray;


-(IBAction) playButtonClicked;
-(IBAction) resetCounter;
-(IBAction) sliderMoved;
-(void) playItem;
-(void) decrementTimeDuration;
-(void)updateScrubber;
-(void)hideSlider;
-(void)showSlider;
-(void) audioModeSetting;
-(void) initializePlayerWithNextItem;
- (void)setupAudioSession;
- (void)pausePlayback;

@end
