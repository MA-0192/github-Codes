//
//  PlayerViewController.m
//  iAatman
//
//  Created by iPhone Developer on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "vunglepub.h"
#import "CBAutoScrollLabel.h"
@implementation PlayerViewController

@synthesize bgView;
@synthesize upperView;
@synthesize artistImageView;
@synthesize artistName;
@synthesize artistInfo;
@synthesize lyricsView;
@synthesize lyricsText;
@synthesize audioSettingView;
@synthesize audioSettingType;
@synthesize audioSettingCounter;
@synthesize hhmmss;

@synthesize scrubberView;
@synthesize slider;
@synthesize playedTime;
@synthesize remaningTime;
@synthesize scrubberTimer;

@synthesize userDefaultProductIDArray;
@synthesize productIDArray;
@synthesize chantDirectoryArray;
@synthesize selectedRowIndex;

@synthesize directoryPath;
@synthesize timeFactor;
@synthesize playingItemIndex;
@synthesize timeArrayIndex;
@synthesize noOfLoops;
@synthesize freeBeadsCount;;
@synthesize beadsCounter;
@synthesize malasCounter;
@synthesize selectedAudioSettingIndex;
@synthesize noOfTimes;
@synthesize noOfSecs;
@synthesize playPauseBtn;
@synthesize beadsLabel;
@synthesize malasLabel;
@synthesize beads;
@synthesize malas;
@synthesize displayLanguages;
@synthesize narrations;
@synthesize beadsArray;
@synthesize malasArray;
@synthesize timeArray;
@synthesize selectedAudioSettingArray;
@synthesize numberOfTimesArray;
@synthesize numberOfSecondArray;
//@synthesize session;
@synthesize decrementLabel;
@synthesize loopTimer;
@synthesize player;
@synthesize player1;
@synthesize textBackgroundImageView;
@synthesize settingBtn = _settingBtn;

@synthesize toolBarAudio;

//MOPUB
@synthesize adView;

//#define kSampleAdUnitIDForiPhone @"be96vdvdsdfvdsvb08ae9a04ff5b40fc44950f01418"
//#define kSampleAdUnitIDForiPad @"aceeaadsdvdsdsvdsvdf4994181979aa5af6f5e292a"




#define kSampleAdUnitIDForiPhone @"be96b08ae9a04ff5b40fc44950f01418"
#define kSampleAdUnitIDForiPad @"aceeaaddf4994181979aa5af6f5e292a"
int itemOrIntro=0;//0 indicating intro and 1 indicating item

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
    self.audioSettingView.backgroundColor=[UIColor clearColor];
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer setRepeatMode:MPMusicRepeatModeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleVolumeChangedFromOutSideApp:)
                                                 name:MPMusicPlayerControllerVolumeDidChangeNotification
                                               object:musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];

    
    
    
    
    
    
	malas.hidden=YES;
    malasLabel.hidden=YES;
    
    BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    if ( isAtLeast7 ) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        
        self.toolBarAudio.barTintColor=[UIColor colorWithRed:214.0f/255.0f green:97.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
       
        
        //brown
 //     self.audioSettingView.backgroundColor=  [UIColor whiteColor];
        
        
      ///  orange
     //   self.audioSettingView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:96.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        
   // green
    //   self.audioSettingView.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:201.0f/255.0f blue:148.0f/255.0f alpha:1.0f];
    }

    //   marqueLbl.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
	NSLog(@"Came into begining of view did load");
	appdel=[[UIApplication sharedApplication]delegate];
	//userDefaults=[NSUserDefaults standardUserDefaults];
	
	playingItem=appdel.playingItem;
    
    NSLog(@"%@",chantDirectoryArray);
      NSLog(@"%d",timeFactor);
    NSLog(@"%d",freeBeadsCount);
    
	timeFactor=[[playingItem.timeFactor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
	freeBeadsCount=[[playingItem.itemFreeBeadsCount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
   	self.title=playingItem.itemName;
	[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	

    
	beadsArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kBeadsArray] mutableCopy];
	malasArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kMalaArray] mutableCopy];
	beadsCounter=[[beadsArray objectAtIndex:playingItemIndex] intValue];
	malasCounter=[[malasArray objectAtIndex:playingItemIndex] intValue];
	beadsLabel.text=[NSString stringWithFormat:@"%d",beadsCounter];
	malasLabel.text=[NSString stringWithFormat:@"%d",malasCounter];
	
	//getting narration and audio mode setting
	userDefaultProductIDArray=[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID];
	narrations=[[NSUserDefaults standardUserDefaults]objectForKey:kNarration];
	displayLanguages=[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages];
	selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
	numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
	numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
    
    NSLog(@"%@",selectedAudioSettingArray);
    
	selectedAudioSettingIndex=[[selectedAudioSettingArray objectAtIndex:playingItemIndex] intValue];
	noOfTimes=[[numberOfTimesArray objectAtIndex:playingItemIndex] intValue];
	noOfSecs=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue];
	NSLog(@"No of Sec in view did load:%d",noOfSecs);
	
	//initializing the time array from the plist file
	timeArray=[[NSArray alloc] initWithContentsOfFile:[NSBundle pathForResource:[playingItem.itemPlist 
	stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:@"plist" 
								inDirectory:directoryPath]];
	//Put the scrubber in those chants, that has only one count of timearray
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideSlider) userInfo:nil repeats:NO];
	if ([timeArray count]==1) 
	{
		scrubberView.hidden=NO;
		slider.hidden=NO;
		remaningTime.hidden=NO;
		playedTime.hidden=NO;
	
		
	}
	else 
	{
		
	}

    NSLog(@"iPod image %@",playingItem.itembgimageiPod);
    NSLog(@"iPhone image %@",playingItem.itembgImage);
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
        {
            
            NSString *bgImageName=[NSBundle pathForResource:[playingItem.itembgimageLandscape stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                     ofType:[playingItem.itembgimagetypeLandscape stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                inDirectory:directoryPath];
            
            
            
         //   bgView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile: bgImageName]];
            
            [self changeViewForLandscapeMode];
            
        }else
        {
            NSString *bgImageName=[NSBundle pathForResource:[playingItem.itembgimagePortrait stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                     ofType:[playingItem.itembgimagetypePortrait stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                inDirectory:directoryPath];
        //    bgView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile: bgImageName]];
            
            [self changeViewForPortraitMode];
        }
    }
    else {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            NSString *bgImageName=[NSBundle pathForResource:[playingItem.itembgImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                     ofType:[playingItem.itembgImageType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                inDirectory:directoryPath];
       //     bgView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile: bgImageName]];
            
            
            //NSLog(@"IMAGE NAME iPhone %@",bgImageName);
        }
        if(result.height == 568)
        {
            NSString *bgImageName=[NSBundle pathForResource:[playingItem.itembgimageiPod stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                     ofType:[playingItem.itembgimagetypeiPod stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                inDirectory:directoryPath];
      //      bgView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile: bgImageName]];
            
            //NSLog(@"IMAGE NAME %@",bgImageName);
        }
    }

	if([playingItem.displayArray count]!=0)
	{
		//setting display text or image
		NSInteger displayIndex=[[displayLanguages objectAtIndex:playingItemIndex] intValue];
		if ([[[playingItem.displayArray objectAtIndex:displayIndex] displayText] stringByTrimmingCharactersInSet:
			 [NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
			
			lyricsView.hidden=YES;
			lyricsText.hidden=NO;
			self.textBackgroundImageView.hidden = NO;
			lyricsText.text=[[[playingItem.displayArray objectAtIndex:displayIndex] displayText] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			lyricsText.backgroundColor=[UIColor clearColor];
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                lyricsText.font = [UIFont boldSystemFontOfSize:30.0];
            }
		}
		else 
		{
			lyricsText.hidden=YES;
			self.textBackgroundImageView.hidden = YES;
			NSString *lyricsImagePath=[NSBundle pathForResource:[[[playingItem.displayArray objectAtIndex:displayIndex] displayImage] 
																 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.displayArray 
                                                                                                                            objectAtIndex:displayIndex] displayImageType] stringByTrimmingCharactersInSet:[NSCharacterSet
                                                                                                    whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
			lyricsView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:lyricsImagePath]];
		}
		
	}
	else 
	{
		lyricsView.hidden=YES;
		lyricsText.hidden=YES;
		self.textBackgroundImageView.hidden = YES;
	}

	if ([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"free"])
	{
		audioSettingView.hidden=YES;
		audioSettingType.hidden=YES;
		audioSettingCounter.hidden=YES;
		hhmmss.hidden=YES;
	}
    
	if([playingItem.narrationArray count]==0)
	{
		NSLog(@"narration count is zero");
		upperView.hidden=YES;
		artistImageView.hidden=YES;
		artistName.hidden=YES;
		artistInfo.hidden=YES;
		
		beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
		malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
		beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
		malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
		slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
		playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
		remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
		scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
		
		
		NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
		[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:
								[NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
		
        
        NSLog(@"%@",itemPath);
         NSLog(@"%@",playingItem.itemAudio);
         NSLog(@"%@",playingItem.itemAudioType);
         NSLog(@"%@",directoryPath);
    
		NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
		
		if(player!=nil)
			player=nil;
		player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
		player.numberOfLoops=-1;
        player.delegate=self;
		itemOrIntro=1;
		[self audioModeSetting];
		[self playItem];
	}
	else
	{
		if ([[narrations objectAtIndex:playingItemIndex] intValue]==[playingItem.narrationArray count]) 
		{
			NSLog(@"YES narration is set to NONE");
			
			upperView.hidden=YES;
			artistImageView.hidden=YES;
			artistName.hidden=YES;
			artistInfo.hidden=YES;
			
			beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
			malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
			beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
			malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
			slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
			playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
			remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
			scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
			
			
			
			
			
			NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
														  [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:
																													 [NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:
								directoryPath];
            NSLog(@"%@",itemPath);
            
			NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
			
			if(player!=nil)
				player=nil;
			
			player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
			player.numberOfLoops=-1;
            player.delegate=self;
			itemOrIntro=1;
			[self audioModeSetting];
			[self playItem];
		}
		else 
		{
			
			if ([[[playingItem.narrationArray objectAtIndex:[[narrations 
															  objectAtIndex:playingItemIndex] intValue]] artistImage] stringByTrimmingCharactersInSet:[NSCharacterSet 
																																					   whitespaceAndNewlineCharacterSet]]!=nil) {
							
				NSString *artistImageName=[NSBundle pathForResource:[[[playingItem.narrationArray objectAtIndex:[[narrations 
				objectAtIndex:playingItemIndex] intValue]] artistImage] stringByTrimmingCharactersInSet:[NSCharacterSet 
				whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.narrationArray 
				objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistImageType]
				stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]inDirectory:directoryPath];
							
				NSLog(@"item artist image is not nil");
				upperView.hidden=NO;
				artistImageView.hidden=NO;
				artistName.hidden=NO;
				artistInfo.hidden=NO;
				
				beads.frame=CGRectMake(beads.frame.origin.x, 91, beads.frame.size.width, beads.frame.size.height);
				malas.frame=CGRectMake(malas.frame.origin.x, 91, malas.frame.size.width,malas.frame.size.height);
				beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,120, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
				malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 120, malasLabel.frame.size.width,malasLabel.frame.size.height);
				slider.frame=CGRectMake(slider.frame.origin.x, 161, slider.frame.size.width, slider.frame.size.height);
				playedTime.frame=CGRectMake(playedTime.frame.origin.x, 163, playedTime.frame.size.width, playedTime.frame.size.height);
				remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 163, remaningTime.frame.size.width, remaningTime.frame.size.height);
				scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 145, scrubberView.frame.size.width, scrubberView.frame.size.height);
				
				
				artistImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:artistImageName]];
				//setting artist name and info
				artistName.font=[UIFont boldSystemFontOfSize:16];
				artistInfo.font=[UIFont boldSystemFontOfSize:12];
				artistName.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
				artistInfo.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
				artistName.text=[[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				artistInfo.text=[[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistInfo] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			}
			else
			{
				upperView.hidden=YES;
				artistImageView.hidden=YES;
				artistName.hidden=YES;
				artistInfo.hidden=YES;
				
				
				beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
				malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
				beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
				malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
				slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
				playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
				remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
				scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
			}
			
			
			
			
			
			
			NSString *narrationPath=[NSBundle pathForResource:[[[playingItem.narrationArray objectAtIndex:[[narrations
			objectAtIndex:playingItemIndex] intValue]] audioName] stringByTrimmingCharactersInSet:[NSCharacterSet
			whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.narrationArray objectAtIndex:[[narrations 
			objectAtIndex:playingItemIndex] intValue]] audioType] stringByTrimmingCharactersInSet:
			[NSCharacterSet whitespaceAndNewlineCharacterSet]]inDirectory:directoryPath];
			
			NSURL *url=[[NSURL alloc] initFileURLWithPath:narrationPath];
			if(player!=nil)
				player=nil;
			player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			player.delegate=self;
            itemOrIntro=0;
			[self audioModeSetting];
		}
	}
	
	
	
	
	timeArrayIndex=0;
	slider.minimumValue=0.0;
	slider.maximumValue=player.duration;
	[self updateScrubber];
	
	[self setupAudioSession];
	NSLog(@"Came into end of view did load");
	
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleVolumeChangedFromOutSideApp:)
//                                                 name:MPMusicPlayerControllerVolumeDidChangeNotification
//                                               object:player];
//    
    //    [musicPlayer beginGeneratingPlaybackNotifications];
    
  //  [volumeBtn setImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
    volumeControler = [[UISlider alloc] init];
    
    [volumeControler addTarget:self action:@selector(volumesliderAction:) forControlEvents:UIControlEventValueChanged];
    volumeControler.transform = CGAffineTransformRotate(volumeControler.transform, -90.0/180*M_PI);
    [volumeControler setBackgroundColor:[UIColor clearColor]];
    volumeControler.minimumValue = 0.0;
    volumeControler.maximumValue = 1.0;
    volumeControler.value = 0.5;
    [self.view addSubview:volumeControler];
    volumeEnable=NO;
    volumeControler.hidden=YES;
 
    
    
    if (player.playing)
	{
		NSLog(@"Came to pause");
		[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
		[player pause];
		
		if(itemOrIntro==1)
		{
			[decrementLabel invalidate];
			decrementLabel=nil;
		}
	}
	else
	{
		NSLog(@"came to play");
		if (itemOrIntro==1)
            
        {
			loopTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(showUpdatedLoopNumber) userInfo:nil repeats:YES];
            player.delegate = self;
        }
		if (([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"paid"])&&(selectedAudioSettingIndex==2)&&(itemOrIntro==1))
            
            
			decrementLabel=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTimeDuration) userInfo:nil repeats:YES];
        
        
		if([timeArray count]==1)
            
            
            scrubberTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateScrubber) userInfo:nil repeats:YES];
		
		[playPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
		[player play];
        
	}
    
	[super viewDidLoad];
}
- (void)handleVolumeChangedFromOutSideApp:(id)notification {
    
    [volumeControler setValue:musicPlayer.volume animated:YES];
}

-(void)volumesliderAction:(UISlider *)sender
{
    if (player  != nil)
    {
      musicPlayer.volume = volumeControler.value;
        //  [volumeBtn setImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
        volumeControler.hidden=NO;
        //    volumeEnable=NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
	
	[super viewWillAppear:YES];

        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {

//            }
        }
        else{
        

            
            //VUNGLE AD
            if ([VGVunglePub adIsAvailable]){
                [VGVunglePub playModalAd:self animated:YES];
            }
            else {
                NSLog(@"Ad Not Yet Available");
            }
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                self.toolBarAudio.frame = CGRectMake(self.toolBarAudio.frame.origin.x, 324, self.toolBarAudio.frame.size.width, self.toolBarAudio.frame.size.height);
                self.audioSettingView.frame = CGRectMake(self.audioSettingView.frame.origin.x, 260, self.audioSettingView.frame.size.width, self.audioSettingView.frame.size.height);
                self.audioSettingType.frame = CGRectMake(self.audioSettingType.frame.origin.x, 270, self.audioSettingType.frame.size.width, self.audioSettingType.frame.size.height);
                self.hhmmss.frame = CGRectMake(self.hhmmss.frame.origin.x, 260, self.hhmmss.frame.size.width, self.hhmmss.frame.size.height);
                self.audioSettingCounter.frame = CGRectMake(self.audioSettingCounter.frame.origin.x, 273, self.audioSettingCounter.frame.size.width, self.audioSettingCounter.frame.size.height);
                
//                
//                BOOL isAtLeast7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
//                
//                if ( isAtLeast7 ) {
                
                   lyricsText.frame=CGRectMake(self.lyricsText.frame.origin.x, 130, self.lyricsText.frame.size.width, self.lyricsText.frame.size.height);
                    
                    
                       textBackgroundImageView.frame=CGRectMake(self.textBackgroundImageView.frame.origin.x, 125, self.textBackgroundImageView.frame.size.width, self.lyricsText.frame.size.height+5);
                    
                   // lyricsView.backgroundColor=[UIColor redColor];
           //     }
               
                
                
            }
            if(result.height == 568)
            {
                self.toolBarAudio.frame = CGRectMake(self.toolBarAudio.frame.origin.x, 400, self.toolBarAudio.frame.size.width, self.toolBarAudio.frame.size.height+10);
                
                self.audioSettingView.frame = CGRectMake(self.audioSettingView.frame.origin.x, 350, self.audioSettingView.frame.size.width, self.audioSettingView.frame.size.height);
                self.audioSettingType.frame = CGRectMake(self.audioSettingType.frame.origin.x, 360, self.audioSettingType.frame.size.width, self.audioSettingType.frame.size.height);
                self.audioSettingCounter.frame = CGRectMake(205, 365, self.audioSettingCounter.frame.size.width, self.audioSettingCounter.frame.size.height);
                self.hhmmss.frame = CGRectMake(self.hhmmss.frame.origin.x, 350, self.hhmmss.frame.size.width, self.hhmmss.frame.size.height);
                
                
                lyricsText.frame=CGRectMake(self.lyricsText.frame.origin.x, 130, self.lyricsText.frame.size.width, self.lyricsText.frame.size.height+50);
                
                
        textBackgroundImageView.frame=CGRectMake(self.textBackgroundImageView.frame.origin.x, 125, self.textBackgroundImageView.frame.size.width, self.lyricsText.frame.size.height+10);
                

                
            }
        }
  //  }
    
    
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        
         volumeControler.frame=CGRectMake(85, 305, 150, 100);
        volumeControler.backgroundColor=[UIColor clearColor];
    }  else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
           volumeControler.frame=CGRectMake(85, 230, 150, 100);
    }else
    {
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
    }
}

-(void) initializePlayerWithNextItem
{
	NSString *xmlPath=[NSBundle pathForResource:kChantXML ofType:@"xml" inDirectory: 
					   [chantDirectoryArray objectAtIndex:selectedRowIndex]];
	if (xmlPath!=nil)
	{
		
		NSData *data=[NSData dataWithContentsOfFile:xmlPath];
		NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithData:data];
		
		ItemParser *itemParser=[[ItemParser alloc] initAatmanXMLParser];
		[xmlParser setDelegate:itemParser];
		
		BOOL b=[xmlParser parse];
		if(b==YES)
			NSLog(@"Success");
		else 
			NSLog(@"Error!!");

	}
	
	NSInteger index=[userDefaultProductIDArray indexOfObject:[productIDArray objectAtIndex:selectedRowIndex]];
	if (index!=NSNotFound) 
		self.playingItemIndex=index;
	else
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Product ID" message:@"Product IDs mismatch" 
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
	directoryPath=[chantDirectoryArray objectAtIndex:selectedRowIndex];
	
	playingItem=appdel.playingItem;
	timeFactor=[[playingItem.timeFactor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
	freeBeadsCount=[[playingItem.itemFreeBeadsCount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
	self.title=playingItem.itemName;
	[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	
	//setting beads and malas labels
	beadsArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kBeadsArray] mutableCopy];
	malasArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kMalaArray] mutableCopy];
	beadsCounter=[[beadsArray objectAtIndex:playingItemIndex] intValue];
	malasCounter=[[malasArray objectAtIndex:playingItemIndex] intValue];
	beadsLabel.text=[NSString stringWithFormat:@"%d",beadsCounter];
	malasLabel.text=[NSString stringWithFormat:@"%d",malasCounter];
	
	//getting narration and audio mode setting
	userDefaultProductIDArray=[[NSUserDefaults standardUserDefaults] objectForKey:kChantProductID];
	narrations=[[NSUserDefaults standardUserDefaults]objectForKey:kNarration];
	displayLanguages=[[NSUserDefaults standardUserDefaults] objectForKey:kDisplayLanguages];
	selectedAudioSettingArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kSelectedAudioSetting] mutableCopy];
	numberOfTimesArray=[[[NSUserDefaults standardUserDefaults]objectForKey:kNumberOfTimesArray] mutableCopy];
	numberOfSecondArray=[[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfSecondsArray] mutableCopy];
	selectedAudioSettingIndex=[[selectedAudioSettingArray objectAtIndex:playingItemIndex] intValue];
	noOfTimes=[[numberOfTimesArray objectAtIndex:playingItemIndex] intValue];
	noOfSecs=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue];
	
	
	//initializing the time array from the plist file
	timeArray=[[NSArray alloc] initWithContentsOfFile:[NSBundle pathForResource:[playingItem.itemPlist 
																				 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:@"plist" 
																	inDirectory:directoryPath]];
	//Put the scrubber in those chants, that has only one count of timearray
	if ([timeArray count]==1) 
	{
		scrubberView.hidden=NO;
		slider.hidden=NO;
		remaningTime.hidden=NO;
		playedTime.hidden=NO;
		[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideSlider) userInfo:nil repeats:NO];
		
	}
	else 
	{
		//scrubberView.hidden=YES;
		//slider.hidden=YES;
		//remaningTime.hidden=YES;
		//playedTime.hidden=YES;
	}
	NSString *bgImageName=[NSBundle pathForResource:[playingItem.itembgImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
											 ofType:[playingItem.itembgImageType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
										inDirectory:directoryPath];
//	bgView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile: bgImageName]];
	
		
	
	if([playingItem.displayArray count]!=0)
	{
		//setting display text or image
		NSInteger displayIndex=[[displayLanguages objectAtIndex:playingItemIndex] intValue];
		if ([[[playingItem.displayArray objectAtIndex:displayIndex] displayText] stringByTrimmingCharactersInSet:
			 [NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
			
			//lyricsView.hidden=YES;
			lyricsText.hidden=NO;
			self.textBackgroundImageView.hidden = NO;
			lyricsText.text=[[[playingItem.displayArray objectAtIndex:displayIndex] displayText] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			lyricsText.backgroundColor=[UIColor clearColor];
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                lyricsText.font = [UIFont boldSystemFontOfSize:30.0];
            }
		}
		else 
		{
			lyricsText.hidden=YES;
			self.textBackgroundImageView.hidden = YES;
			NSString *lyricsImagePath=[NSBundle pathForResource:[[[playingItem.displayArray objectAtIndex:displayIndex] displayImage] 
																 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.displayArray 
																																							  objectAtIndex:displayIndex] displayImageType] stringByTrimmingCharactersInSet:[NSCharacterSet 
																																																											 whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
			lyricsView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:lyricsImagePath]];
		}
		
	}
	else 
	{
		lyricsView.hidden=YES;
		lyricsText.hidden=YES;
		self.textBackgroundImageView.hidden = YES;
	}
	
	if ([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"free"])
	{
		audioSettingView.hidden=YES;
		audioSettingType.hidden=YES;
		audioSettingCounter.hidden=YES;
		hhmmss.hidden=YES;
	}
	
	
	if([playingItem.narrationArray count]==0)
	{
		upperView.hidden=YES;
		artistImageView.hidden=YES;
		artistName.hidden=YES;
		artistInfo.hidden=YES;
		
		beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
		malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
		beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
		malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
		slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
		playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
		remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
		scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
		
		
		
		
		NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
													  [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:
																												 [NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
		
		NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
		
		if(player!=nil)
			player=nil;
		player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
		player.numberOfLoops=-1;
        player.delegate=self;
		itemOrIntro=1;
		[self audioModeSetting];
		[self playItem];
		
	}
	
	else
	{
		if ([[narrations objectAtIndex:playingItemIndex] intValue]==[playingItem.narrationArray count]) 
		{
			
			upperView.hidden=YES;
			artistImageView.hidden=YES;
			artistName.hidden=YES;
			artistInfo.hidden=YES;
			
			beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
			malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
			beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
			malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
			slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
			playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
			remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
			scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
			
			
			
			
			NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
														  [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:
																													 [NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:
								directoryPath];
			NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
			
			if(player!=nil)
				player=nil;
			
			player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
			player.numberOfLoops=-1;
            player.delegate=self;
			itemOrIntro=1;
			[self audioModeSetting];
			[self playItem];
		}
		else 
		{
			
			
			if ([[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]]
				artistImage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
				
				
				NSString *artistImageName=[NSBundle pathForResource:[[[playingItem.narrationArray objectAtIndex:[[narrations 
				objectAtIndex:playingItemIndex] intValue]] artistImage] stringByTrimmingCharactersInSet:[NSCharacterSet 
				whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.narrationArray 
				objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistImageType]
				stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]inDirectory:directoryPath];
				
				
				
				upperView.hidden=NO;
				artistName.hidden=NO;
				artistInfo.hidden=NO;
				artistImageView.hidden=NO;
				
				beads.frame=CGRectMake(beads.frame.origin.x, 91, beads.frame.size.width, beads.frame.size.height);
				malas.frame=CGRectMake(malas.frame.origin.x, 91, malas.frame.size.width,malas.frame.size.height);
				beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,120, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
				malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 120, malasLabel.frame.size.width,malasLabel.frame.size.height);
				slider.frame=CGRectMake(slider.frame.origin.x, 161, slider.frame.size.width, slider.frame.size.height);
				playedTime.frame=CGRectMake(playedTime.frame.origin.x, 163, playedTime.frame.size.width, playedTime.frame.size.height);
				remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 163, remaningTime.frame.size.width, remaningTime.frame.size.height);
				scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 145, scrubberView.frame.size.width, scrubberView.frame.size.height);
				
				
				artistImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:artistImageName]];
				//setting artist name and info
				artistName.font=[UIFont boldSystemFontOfSize:16];
				artistInfo.font=[UIFont boldSystemFontOfSize:12];
				artistName.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
				artistInfo.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
				artistName.text=[[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				artistInfo.text=[[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] artistInfo] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			}
			else
			{
				upperView.hidden=YES;
				artistImageView.hidden=YES;
				artistName.hidden=YES;
				artistInfo.hidden=YES;
				
				
				beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
				malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
				beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
				malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
				slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
				playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
				remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
				scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
				
			}
			
			NSString *narrationPath=[NSBundle pathForResource:[[[playingItem.narrationArray objectAtIndex:[[narrations objectAtIndex:playingItemIndex] intValue]] audioName] stringByTrimmingCharactersInSet:[NSCharacterSet
																																																   whitespaceAndNewlineCharacterSet]] ofType:[[[playingItem.narrationArray objectAtIndex:[[narrations 
																																																																						   objectAtIndex:playingItemIndex] intValue]] audioType] stringByTrimmingCharactersInSet:
																																																											  [NSCharacterSet whitespaceAndNewlineCharacterSet]]inDirectory:directoryPath];
			NSURL *url=[[NSURL alloc] initFileURLWithPath:narrationPath];
			if(player!=nil)
				player=nil;
			player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			player.delegate=self;
            itemOrIntro=0;
			[self audioModeSetting];
		}
	}
	
	
	timeArrayIndex=0;
	slider.minimumValue=0.0;
	slider.maximumValue=player.duration;
	[self updateScrubber];
	
	
	//player
	if (itemOrIntro==1) 
		loopTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(showUpdatedLoopNumber) userInfo:nil repeats:YES];
	if (([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"paid"])&&(selectedAudioSettingIndex==2)&&(itemOrIntro==1))
		decrementLabel=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTimeDuration) userInfo:nil repeats:YES];
	scrubberTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateScrubber) userInfo:nil repeats:YES];
	
	[playPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	[player play];
	
	
	
}

-(void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"Came into begining of view will disappear");
	
		
	if (player.playing==YES)
	{
		NSLog(@"YES player is playing");
		[player stop];
		player.currentTime=0;
		[decrementLabel invalidate];
        decrementLabel=nil;
		
		[scrubberTimer invalidate];
        scrubberTimer=nil;
	}
	
	[beadsArray replaceObjectAtIndex:playingItemIndex withObject:beadsLabel.text];
	[malasArray replaceObjectAtIndex:playingItemIndex withObject:malasLabel.text];
	[[NSUserDefaults standardUserDefaults] setObject:beadsArray forKey:kBeadsArray];
	[[NSUserDefaults standardUserDefaults] setObject:malasArray forKey:kMalaArray];
	NSLog(@"Came into end of view will disappear");
}

-(void)updateScrubber
{
	NSLog(@"Scrubber timer is running");
	self.playedTime.text = [NSString stringWithFormat:@"%d:%02d", (int)player.currentTime / 60, (int)player.currentTime % 60, nil];
	self.remaningTime.text = [NSString stringWithFormat:@"%d:%02d", (int)(player.duration - player.currentTime) / 60, (int)(player.duration - player.currentTime) % 60, nil];
	self.slider.value = player.currentTime;
	if (player.playing==NO) 
	{
		[scrubberTimer invalidate];
        scrubberTimer=nil;
	}
}
-(IBAction) sliderMoved
{
	player.currentTime=slider.value;
	NSString *str=self.playedTime.text;
	NSArray *arr=[str componentsSeparatedByString:@":"];
	int min=[[arr objectAtIndex:0] intValue];
	int sec=[[arr objectAtIndex:1] intValue];
	sec=(min*60)+sec;
	sec=(int)(player.currentTime)-sec;
	NSLog(@"secs moved:%d",sec);
		
	self.playedTime.text = [NSString stringWithFormat:@"%d:%02d", (int)player.currentTime / 60, (int)player.currentTime % 60, nil];
	self.remaningTime.text = [NSString stringWithFormat:@"%d:%02d", (int)(player.duration - player.currentTime) / 60, (int)(player.duration - player.currentTime) % 60, nil];
	 
	if ((itemOrIntro==1)&&( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==2))) {
		noOfSecs= noOfSecs-sec;
		
		
	}
	
	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches) 
	{
		
		if([playingItem.displayArray count]!=0)
		{
			if (self.lyricsText.hidden == YES)
			{
				self.textBackgroundImageView.hidden = NO;
				self.lyricsText.hidden = NO;
			}
			else
			{
				//self.textBackgroundImageView.hidden = YES;
				//self.lyricsText.hidden = YES;
			}
		}

		
		
		//if ([timeArray count]==1)
		//{
            
			if(self.slider.hidden == YES)
			{
				[self showSlider];
			}
			else 
			{
				[self hideSlider];
			}
			
		//}
	}
}

-(void)hideSlider
{
	
	self.slider.hidden = YES;
	self.scrubberView.hidden = YES;
	self.playedTime.hidden = YES;
	self.remaningTime.hidden = YES;
	
	if([playingItem.displayArray count]!=0)
	{
		//self.lyricsText.hidden = YES;
	    //self.textBackgroundImageView.hidden = YES;
	}
	//self.loopNumberLabel.hidden = YES;
	//BorderImageView.hidden = YES;
}
-(void)showSlider
{
	self.slider.hidden = NO;
	self.scrubberView.hidden = NO;
	self.playedTime.hidden = NO;
	self.remaningTime.hidden = NO;
	if([playingItem.displayArray count]!=0)
	{
	 self.lyricsText.hidden = NO;
	 self.textBackgroundImageView.hidden = NO;
	}
}

-(void) audioModeSetting
{
	if ([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] 
		 isEqualToString:@"paid"])
	{	
		audioSettingView.hidden=NO;
		audioSettingType.hidden=NO;
		
		
		
		if (selectedAudioSettingIndex==0) 
		{
			NSLog(@"selected audio setting is continuous");
			
			audioSettingType.text=@"Continuous";
			audioSettingCounter.hidden=YES;
			hhmmss.hidden=YES;
		}
		else if(selectedAudioSettingIndex==1)
		{
			NSLog(@"selected audio setting is number of times");
			noOfLoops=noOfTimes;
			audioSettingType.text=@"Number Of Times";
			audioSettingCounter.hidden=NO;
			audioSettingCounter.text=[NSString stringWithFormat:@"%d",noOfTimes];
			hhmmss.hidden=YES;
		}
		else 
		{
			NSLog(@"selected audio setting is for time duration");
			noOfSecs=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue];
			if (itemOrIntro==0) //To know the time duration of chant if introduction is playing
			{
				NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
				[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType 
				stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:
									directoryPath];
				NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
				player1=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
                player1.delegate = self;
				float nol=noOfSecs/(float)(player1.duration);
				NSLog(@"player.duration:%f",(float)(player1.duration));
				if(nol<1)
					nol=1;
				noOfLoops=(int)nol*[timeArray count];
				noOfSecs=(int)nol*(float)(player1.duration);
				
			}
			else
			{
				float nol=noOfSecs/(float)(player.duration);
				NSLog(@"player.duration:%f",(float)(player.duration));
				NSLog(@"nol:%f",nol);
				if(nol<1)
					nol=1;
				noOfLoops=(int)nol*[timeArray count];
				noOfSecs=(int)nol*(float)(player.duration);
				NSLog(@"Number of seconds:%d",noOfSecs);
				
			}
			int hh=noOfSecs/(60*60);
			int mm=(noOfSecs/60)-(hh*60);
			int ss=noOfSecs-(hh*60*60)-(mm*60);
			NSLog(@"Number of loops are:%d",noOfLoops);
			audioSettingType.text=@"For Time Duration";
			audioSettingCounter.hidden=NO;
			audioSettingCounter.text=[NSString stringWithFormat:@"%2.2d : %2.2d : %2.2d",hh,mm,ss];
			hhmmss.hidden=NO;
			
		}
		
		
		
	}
	else 
	{
		noOfLoops=freeBeadsCount;
	}

	
	
	
}

#pragma mark AudioSession methods
void RouteChangeListener(void * inClientData, AudioSessionPropertyID	inID, UInt32  inDataSize, const void *  inData)
{
	PlayerViewController* This = (__bridge PlayerViewController *)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];
		
		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
			
			NSLog(@"in route change listner player");
			[This pausePlayback];	
		}
	}
}
- (void)pausePlayback
{
	[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	[player stop];
	
	if(itemOrIntro==1)
	{
		[decrementLabel invalidate];
        decrementLabel=nil;
	}
}

- (void)setupAudioSession
{
	AVAudioSession *sess = [AVAudioSession sharedInstance];
	NSError *error = nil;
	
	[sess setCategory: AVAudioSessionCategoryPlayback error: &error];
	if (error != nil)
		NSLog(@"Failed to set category on AVAudioSession");
	
	// AudioSession and AVAudioSession calls can be used interchangeably
	OSStatus result = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, RouteChangeListener, (__bridge void *)(self));
	if (result) NSLog(@"Could not add property listener! %ld\n", result);
	
	BOOL active = [sess setActive: YES error: nil];
	if (!active)
		NSLog(@"Failed to set category on AVAudioSession");
	else 
		NSLog(@"set category on AVAudioSession");
}

-(IBAction) resetCounter
{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Counter" message:@"Are you sure , you want to reset the counter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"OK"];
	[alert show];
    
}

//Alert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
		beadsCounter=0;
		malasCounter=0;
		beadsLabel.text=@"0";
		malasLabel.text=@"0";
		[beadsArray replaceObjectAtIndex:playingItemIndex withObject:beadsLabel.text];
		[malasArray replaceObjectAtIndex:playingItemIndex withObject:malasLabel.text];
		
		
		if( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==2))//when audio mode is for time duration
		{
			if(player.playing==YES)
			[self.decrementLabel invalidate];
			noOfSecs=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue];
			if (itemOrIntro==0) //To know the time duration of chant if introduction is playing
			{
				NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
															  [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType 
																														 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:
									directoryPath];
				NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
				player1=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
				float nol=noOfSecs/(float)(player1.duration);
				if(nol<1)
					nol=1;
				noOfLoops=(int)nol*[timeArray count];
				noOfSecs=(int)nol*(float)(player1.duration);
				
			}
			else
			{
				float nol=noOfSecs/(float)(player.duration);
				if(nol<1)
					nol=1;
				noOfLoops=(int)nol*[timeArray count];
				noOfSecs=(int)nol*(float)(player.duration);
				
			}
			int hh=noOfSecs/(60*60);
			int mm=(noOfSecs/60)-(hh*60);
			int ss=noOfSecs-(hh*60*60)-(mm*60);
			
			audioSettingType.text=@"For Time Duration";
			audioSettingCounter.hidden=NO;
			audioSettingCounter.text=[NSString stringWithFormat:@"%2.2d : %2.2d : %2.2d",hh,mm,ss];
			hhmmss.hidden=NO;
		}
		else if( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==1))
		{
			noOfTimes=[[numberOfTimesArray objectAtIndex:playingItemIndex] intValue];
			noOfLoops=noOfTimes;
			audioSettingCounter.text=[NSString stringWithFormat:@"%d",noOfTimes];
			
		}
		[player stop];
		player.currentTime=0;
		timeArrayIndex=0;
		[self.playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	}
}
-(IBAction) playButtonClicked
{
	if (player.playing) 
	{
		NSLog(@"Came to pause");
		[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
		[player pause];
		
		if(itemOrIntro==1)
		{
			[decrementLabel invalidate];
			decrementLabel=nil;
		}
	}
	else 
	{
		NSLog(@"came to play");
		if (itemOrIntro==1)
        
        {
			loopTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(showUpdatedLoopNumber) userInfo:nil repeats:YES];
            player.delegate = self;
        }
		if (([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"paid"])&&(selectedAudioSettingIndex==2)&&(itemOrIntro==1))
            
            
			decrementLabel=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTimeDuration) userInfo:nil repeats:YES];
        
        
		if([timeArray count]==1)
            
            
		scrubberTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateScrubber) userInfo:nil repeats:YES];
		
		[playPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
		[player play];
        
	}
}
-(void) playItem
{
		if ([playingItem.itemArtistImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
		
			NSString *artistImageName=[NSBundle pathForResource:[playingItem.itemArtistImage stringByTrimmingCharactersInSet:
																 [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[[playingItem itemArtistImageType]stringByTrimmingCharactersInSet:
																															[NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
			upperView.hidden=NO;
			artistImageView.hidden=NO;
			artistName.hidden=NO;
			artistInfo.hidden=NO;
			
			
			beads.frame=CGRectMake(beads.frame.origin.x, 91, beads.frame.size.width, beads.frame.size.height);
			malas.frame=CGRectMake(malas.frame.origin.x, 91, malas.frame.size.width,malas.frame.size.height);
			beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,120, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
			malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 120, malasLabel.frame.size.width,malasLabel.frame.size.height);
			slider.frame=CGRectMake(slider.frame.origin.x, 161, slider.frame.size.width, slider.frame.size.height);
			playedTime.frame=CGRectMake(playedTime.frame.origin.x, 163, playedTime.frame.size.width, playedTime.frame.size.height);
			remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 163, remaningTime.frame.size.width, remaningTime.frame.size.height);
			scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 145, scrubberView.frame.size.width, scrubberView.frame.size.height);
			
			
			
		
		artistImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:artistImageName]];
		artistName.font=[UIFont boldSystemFontOfSize:16];
		artistInfo.font=[UIFont boldSystemFontOfSize:12];
		artistName.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
		artistInfo.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.jpg"]];
		artistName.text=[playingItem.itemArtistName stringByTrimmingCharactersInSet:
						 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		artistInfo.text=[playingItem.itemArtistInfo stringByTrimmingCharactersInSet:
						 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}
		else
		{
			upperView.hidden=YES;
			artistName.hidden=YES;
			artistInfo.hidden=YES;
			artistImageView.hidden=YES;
			
			beads.frame=CGRectMake(beads.frame.origin.x, 11, beads.frame.size.width, beads.frame.size.height);
			malas.frame=CGRectMake(malas.frame.origin.x, 11, malas.frame.size.width,malas.frame.size.height);
			beadsLabel.frame=CGRectMake(beadsLabel.frame.origin.x,40, beadsLabel.frame.size.width, beadsLabel.frame.size.height);
			malasLabel.frame=CGRectMake(malasLabel.frame.origin.x, 40, malasLabel.frame.size.width,malasLabel.frame.size.height);
			slider.frame=CGRectMake(slider.frame.origin.x, 81, slider.frame.size.width, slider.frame.size.height);
			playedTime.frame=CGRectMake(playedTime.frame.origin.x, 83, playedTime.frame.size.width, playedTime.frame.size.height);
			remaningTime.frame=CGRectMake(remaningTime.frame.origin.x, 83, remaningTime.frame.size.width, remaningTime.frame.size.height);
			scrubberView.frame=CGRectMake(scrubberView.frame.origin.x, 65, scrubberView.frame.size.width, scrubberView.frame.size.height);
			
		}
	
	if (itemOrIntro==0) 
	{
	
	
		NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:directoryPath];
		NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
		if(player!=nil)
			player=nil;
		player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
		NSLog(@"player duration is:%f",(float)(player.duration));
		player.numberOfLoops=-1;
        player.delegate=self;
		
		slider.minimumValue=0.0;
		slider.maximumValue=player.duration;

		
		
		[player play];
		itemOrIntro=1;
		loopTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(showUpdatedLoopNumber) userInfo:nil repeats:YES];
		if (([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"paid"])&&(selectedAudioSettingIndex==2))
			decrementLabel=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTimeDuration) userInfo:nil repeats:YES];
		if ([timeArray count]==1) 
		scrubberTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateScrubber) userInfo:nil repeats:YES];
	}
	
	[self updateScrubber];
		
}

-(void) showUpdatedLoopNumber//This method is to increase the beads and malas
{
	//NSLog(@"player.current time:%d",(int)player.currentTime);
	if ((int)(player.currentTime*timeFactor)==(int)([[timeArray objectAtIndex:timeArrayIndex] floatValue]*timeFactor))
	{
		NSLog(@"1 beads completed");
		beadsCounter++;
		beadsLabel.text=[NSString stringWithFormat:@"%d",beadsCounter];
		
		if (beadsCounter > 107) //To send facebook update whenever 1 mala completes
		{
			malasCounter++;
			beadsCounter=0;
			malasLabel.text=[NSString stringWithFormat:@"%d",malasCounter];
			//[self sendFacebookMalaUpdate];
			
		}
		timeArrayIndex++;
		if(timeArrayIndex==[timeArray count])
		{
			timeArrayIndex=0;
		}
		if( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==1))//To decrement the no. of times counter
		{
			noOfTimes--;
			audioSettingCounter.text=[NSString stringWithFormat:@"%d",noOfTimes];
			if (noOfTimes==0) //When counter reaches 'zero' it needed to set it to value by it initially was.
			{
				noOfTimes=[[numberOfTimesArray objectAtIndex:playingItemIndex] intValue];
				audioSettingCounter.text=[NSString stringWithFormat:@"%d",noOfTimes];
			}
			
		}
		
		if(( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==2))||( (audioSettingCounter.hidden==NO)&&
		(selectedAudioSettingIndex==1))||([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet 
														whitespaceAndNewlineCharacterSet]] isEqualToString:@"free"])) 
		{
			noOfLoops--;
			if (noOfLoops==0)
			{
								
				//if (selectedRowIndex==[chantDirectoryArray count]-1)
					if (1)
				{
					if( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==1))
					{
						noOfLoops=[[numberOfTimesArray objectAtIndex:playingItemIndex] intValue];
						timeArrayIndex=0;
						[player stop];
						player.currentTime=0;
						[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
					}
					else if( (audioSettingCounter.hidden==NO)&&(selectedAudioSettingIndex==2))
					{
						float nol=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue]/(float)(player.duration);
						if (nol<1) 
							nol=1;
						noOfLoops=(int)nol*[timeArray count];
						timeArrayIndex=0;
						[player stop];
						player.currentTime=0;
						[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
						
					}
					else
					{
						noOfLoops=freeBeadsCount;
						timeArrayIndex=0;
						[player stop];
						player.currentTime=0;
						[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
					}
					
				}
				
				else 
				{
					[player stop];
					[beadsArray replaceObjectAtIndex:playingItemIndex withObject:beadsLabel.text];
					[malasArray replaceObjectAtIndex:playingItemIndex withObject:malasLabel.text];
					[[NSUserDefaults standardUserDefaults] setObject:beadsArray forKey:kBeadsArray];
					[[NSUserDefaults standardUserDefaults] setObject:malasArray forKey:kMalaArray];
					selectedRowIndex++;
					
                [loopTimer invalidate];
					loopTimer=nil;
					
					[decrementLabel invalidate];
                    decrementLabel=nil;
					[self initializePlayerWithNextItem];
				}
				[beadsArray replaceObjectAtIndex:playingItemIndex withObject:beadsLabel.text];
				[malasArray replaceObjectAtIndex:playingItemIndex withObject:malasLabel.text];
				[[NSUserDefaults standardUserDefaults] setObject:beadsArray forKey:kBeadsArray];
				[[NSUserDefaults standardUserDefaults] setObject:malasArray forKey:kMalaArray];
				//selectedRowIndex++;
				
				[loopTimer invalidate];
				loopTimer=nil;
				
				[decrementLabel invalidate];
                decrementLabel=nil;
				
			}
		}
		
	}
	if (player.playing==NO) 
	{
		[loopTimer invalidate];
		loopTimer=nil;
	}    
	//NSLog(@"loopTimer is running");
}

-(void) decrementTimeDuration
{
	NSLog(@"decrement time duration called");
	//NSLog(@"No of seconds:%d",noOfSecs);
	if (noOfSecs>0)
	{
		noOfSecs--;
		int hh=noOfSecs/(60*60);
		int mm=(noOfSecs/60)-(hh*60);
		int ss=noOfSecs-(hh*60*60)-(mm*60);
		audioSettingCounter.text=[NSString stringWithFormat:@"%2.2d : %2.2d : %2.2d",hh,mm,ss];
		
	}
	else
	{
		if (selectedRowIndex==[chantDirectoryArray count]-1) {
		[decrementLabel invalidate];
		decrementLabel=nil;
		noOfSecs=[[numberOfSecondArray objectAtIndex:playingItemIndex] intValue];
		NSLog(@"No OF Second setted:%d",noOfSecs);
		NSLog(@"player duration:%d",(int)(player.duration));
		float nol=noOfSecs/(float)(player.duration);
		if (nol<1) 
			nol=1;
		noOfSecs=(int)nol*(float)(player.duration);
		NSLog(@"Now number of sec:%d",noOfSecs);
		}
	}
	
}

#pragma mark AudioPlayer Delgate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playe successfully:(BOOL)flag
{
	if (flag==YES) {
		NSLog(@"Came into didFinish of player and flag is YES");
	}
	else
		NSLog(@"flag is NO");
	
	NSLog(@"itemOrIntro values is:%d",itemOrIntro);
	if (itemOrIntro==0)
	{
		[scrubberTimer invalidate];
		scrubberTimer=nil;
		[self playItem];
	}
	
	//[scrubberTimer invalidate];
}


- (void) audioPlayerBeginInterruption:(AVAudioPlayer *)playe
{
	// the object has already been paused,	we just need to update UI
	NSLog(@"interruption occur");
	if (player.playing==YES) {
		NSLog(@"player.playing==YES");
	}	
	else {
		NSLog(@"player.playing==NO");
	}
	
	[playPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	//[player pause];
	
	if(itemOrIntro==1)
	{
		[decrementLabel invalidate];
        decrementLabel=nil;
	}
	
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)playe
{
	NSLog(@"interruption finished");
	if (player.playing==YES) {
		NSLog(@"player.playing==YES");
	}	
	else {
		NSLog(@"player.playing==NO");
	}
	if (itemOrIntro==1) 
		loopTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(showUpdatedLoopNumber) userInfo:nil repeats:YES];
	if (([[playingItem.itemCost stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"paid"])&&(selectedAudioSettingIndex==2)&&(itemOrIntro==1))
		decrementLabel=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTimeDuration) userInfo:nil repeats:YES];
	if([timeArray count]==1)
		scrubberTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateScrubber) userInfo:nil repeats:YES];
	
	[playPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	[player play];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


- (void)adViewDidLoadAd:(MPAdView *)view
{

}

-(void)adViewDidFailToLoadAd:(MPAdView *)view
{
    
    self.adView.hidden = YES;
    self.adView = nil;
 
    
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
    self.view.frame=CGRectMake(0, 0, 1024,768);
       volumeControler.frame=CGRectMake(467, 450, 150, 150);
 //   upperView.frame=CGRectMake(0, 0, 773, 90);
    artistName.frame=CGRectMake(113 +125, 10, 518, 21);
    artistInfo.frame=CGRectMake(113 + 125, 32, 573, 51);

    malas.frame=CGRectMake(20+ 125, 98, 60, 21);
    malasLabel.frame=CGRectMake(29+ 125, 122, 19, 21);
    beads.frame=CGRectMake(697+ 125, 98, 60, 21);
    beadsLabel.frame = CGRectMake(850, 122, 20, 21);
    upperView.frame=CGRectMake(0+ 125, 0, 768, 90);
    playedTime.frame=CGRectMake(15+ 125, 192, 42, 21);
    remaningTime.frame=CGRectMake(700+ 125, 192, 42, 21);
    artistImageView.frame=CGRectMake(20+ 125, 7, 76, 76);


        [volumeControler removeFromSuperview];
        [self.view addSubview:volumeControler];
        lyricsText.frame=CGRectMake(20, 249, 1000, 240);
        lyricsView.frame=CGRectMake(60, 165, 768, 676);
        
        // lyricsText.backgroundColor=[UIColor yellowColor];
        
        lyricsView.backgroundColor=[UIColor clearColor];
        audioSettingView.backgroundColor=[UIColor clearColor];
        
        audioSettingView.frame=CGRectMake(0, 490, 1024, 82);
        audioSettingType.frame=CGRectMake(30, 510, 216, 40);
        
        hhmmss.frame=CGRectMake(800, 500, 174, 21);

        audioSettingCounter.frame=CGRectMake(800, 520, 181, 21);
        
        playPauseBtn.frame=CGRectMake(30, 610, 73, 44);
        self.settingBtn.frame=CGRectMake(850, 610, 73, 44);
        volumeBtn.frame = CGRectMake(500, 610, 73, 44);
        bgView.frame=CGRectMake(0, 0, 1024,768);
        slider.frame=CGRectMake(200, 192, 610,29);
        self.footerBg.frame=CGRectMake(0, 605, 1024,49);
   // }
}

-(void)changeViewForPortraitMode
{
    self.view.frame=CGRectMake(0, 0, 768,1024);
    volumeControler.frame=CGRectMake(320, 725, 150, 150);
    artistImageView.frame=CGRectMake(20, 7, 76, 76);
    //   upperView.frame=CGRectMake(0, 0, 773, 90);
    artistName.frame=CGRectMake(113, 10, 518, 21);
    artistInfo.frame=CGRectMake(113 , 32, 573, 51);
    
    malas.frame=CGRectMake(20, 98, 60, 21);
    malasLabel.frame=CGRectMake(29, 122, 19, 21);
    beads.frame=CGRectMake(697, 98, 65, 21);
    beadsLabel.frame = CGRectMake(712, 122, 20, 21);
    upperView.frame=CGRectMake(0, 0, 768, 90);
    artistImageView.frame=CGRectMake(20, 7, 76, 76);
    
    
    volumeBtn.frame = CGRectMake(360, 867, 73, 44);
    
    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"packagePurchasedOrNot"])
//    {
////        [self.adView removeFromSuperview];
////        self.adView.hidden = YES;
////        self.adView.delegate = nil;
//        
//        self.footerBg.frame = CGRectMake(0, 911, 1024, 49);
//        self.playPauseBtn.frame = CGRectMake(20, 913, 73, 44);
//        self.settingBtn.frame = CGRectMake(666, 911, 73, 44);
//     
//        self.audioSettingView.frame = CGRectMake(0, 830, 768, 82);
//        self.audioSettingType.frame = CGRectMake(20, 860, 447, 21);
//        self.hhmmss.frame = CGRectMake(600, 840, 174, 21);
//        self.audioSettingCounter.frame = CGRectMake(600, 860, 174, 21);
//        self.slider.frame = CGRectMake(78, 192, 610, 29);
//        playedTime.frame=CGRectMake(23, 192, 42, 21);
//        remaningTime.frame=CGRectMake(700, 192, 42, 21);
//        self.lyricsText.frame = CGRectMake(50, 249, 719, 300);
//    }
//    else{
//        self.adView.hidden = YES;
//        self.adView = nil;
//        self.adView = [[MPAdView alloc] initWithAdUnitId:kSampleAdUnitIDForiPad                                                     size:MOPUB_LEADERBOARD_SIZE];
//        self.adView.delegate = self;
//        self.adView.frame = CGRectMake(0, 780,728, 90);
//        [self.view addSubview:self.adView];
//        
//        self.adView.backgroundColor=[UIColor redColor];
//        
//        [self.adView loadAd];
        
        self.footerBg.frame = CGRectMake(0, 870, 768, 49);
        self.playPauseBtn.frame = CGRectMake(20, 872, 73, 44);
        self.settingBtn.frame = CGRectMake(666, 872, 73, 44);
        lyricsText.frame=CGRectMake(10, 249, 730, 500);
        lyricsView.frame=CGRectMake(100, 165, 768, 676);
       // lyricsText.backgroundColor=[UIColor yellowColor];
        
        audioSettingView.frame=CGRectMake(0, 759, 768, 82);
        audioSettingType.frame=CGRectMake(20, 780, 216, 40);
        
        hhmmss.frame=CGRectMake(565, 766, 174, 21);
        audioSettingCounter.frame=CGRectMake(565, 790, 181, 21);
        
        bgView.frame=CGRectMake(0, 0, 768,1024);
        slider.frame=CGRectMake(78, 192, 610,29);
        [volumeControler removeFromSuperview];
        [self.view addSubview:volumeControler];
        self.playedTime.frame = CGRectMake(15, 192, 42, 21);
        self.remaningTime.frame = CGRectMake(700, 193, 42, 21);
  //  }

        

    
    
}
- (IBAction)NextBtnAction:(id)sender {
    //ItemParser *itemObj=[[ItemParser alloc]init];
    //playingItem=nil;
    //playingItem.itemAudio= itemObj.playingitemNameNew;
    NSLog(@"chant Dir Array %@", chantDirectoryArray);
	NSString *xmlPath=[NSBundle pathForResource:kChantXML ofType:@"xml" inDirectory:
                       [chantDirectoryArray objectAtIndex:1]];
	if (xmlPath!=nil)
	{
		
		NSData *data=[NSData dataWithContentsOfFile:xmlPath];
		NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithData:data];
		
		ItemParser *itemParser=[[ItemParser alloc] initAatmanXMLParser];
		[xmlParser setDelegate:itemParser];
		
		BOOL b=[xmlParser parse];
		if(b==YES)
			NSLog(@"Success");
		else
			NSLog(@"Error!!");
		//[itemParser release];
		//[xmlParser release];
	}
    
    NSLog(@"%@",[chantDirectoryArray objectAtIndex:1]);
    
   
  //  NSLog(@"%@",itemObj.playingitemNameNew);
    NSLog(@"%@",playingItem.itemAudio);
    NSLog(@"%@",playingItem.itemAudioType);
  //  NSLog(@"%@",directoryPath);
    
    NSString *itemPath=[NSBundle pathForResource:[playingItem.itemAudio stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]] ofType:[playingItem.itemAudioType stringByTrimmingCharactersInSet:
                                                                                                             [NSCharacterSet whitespaceAndNewlineCharacterSet]] inDirectory:[chantDirectoryArray objectAtIndex:1]];
    
    
    NSLog(@"%@",[playingItem.itemAudio stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    NSLog(@"%@",playingItem.itemAudio);
    NSLog(@"%@",playingItem.itemAudioType);
    NSLog(@"%@",itemPath);
    
    NSURL *itemURL=[[NSURL alloc] initFileURLWithPath:itemPath];
    
    if(player!=nil)
        player=nil;
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:itemURL error:nil];
    player.numberOfLoops=-1;
    player.delegate=self;
    itemOrIntro=1;
    [self audioModeSetting];
    [self playItem];
}

- (IBAction)previousBtnAction:(id)sender {
}

- (IBAction)volumeBtnAction:(id)sender {
    
    if(volumeEnable==YES)
    {
        volumeControler.hidden=YES;
        volumeEnable=NO;
    }else
    {
        volumeEnable=YES;
     //   [volumeBtn setImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
        volumeControler.hidden=NO;
    }
}
@end
