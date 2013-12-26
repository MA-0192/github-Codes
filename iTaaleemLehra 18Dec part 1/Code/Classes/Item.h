//
//  Item.h
//  iAatman
//
//  Created by iPhone Developer on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject {
	NSString *itemName;
	NSString *itemCost;			//free or paid
	NSString *itemType;			//ichant or iaatman
	NSString *itemFreeBeadsCount; //Number of beads that will play in free kind of chant
	NSString *itemAudio;
	NSString *itemAudioType;
	NSString *itemPlist;
	NSString *timeFactor;
	NSString *itembgImage;
	NSString *itembgImageType;
	NSString *itemArtistName;
	NSString *itemArtistInfo;
	NSString *itemArtistImage;
	NSString *itemArtistImageType;
	NSMutableArray *narrationArray;
	NSMutableArray *displayArray;
    NSString *itembgimageiPod;
    NSString *itembgimagetypeiPod;
    NSString *itembgimagePortrait;
    NSString *itembgimagetypePortrait;
    NSString *itembgimageLandscape;
    NSString *itembgimagetypeLandscape;
}
@property(nonatomic,strong)NSString *itemName;
@property(nonatomic,strong)NSString *itemCost;	
@property(nonatomic,strong)NSString *itemType;
@property(nonatomic,strong)NSString *itemFreeBeadsCount;
@property(nonatomic,strong)NSString *itemAudio;
@property(nonatomic,strong)NSString *itemAudioType;
@property(nonatomic,strong)NSString *itemPlist;
@property(nonatomic,strong)NSString *timeFactor;
@property(nonatomic,strong)NSString *itembgImage;
@property(nonatomic,strong)NSString *itembgImageType;
@property(nonatomic,strong)NSString *itemArtistName;
@property(nonatomic,strong)NSString *itemArtistInfo;
@property(nonatomic,strong)NSString *itemArtistImage;
@property(nonatomic,strong)NSString *itemArtistImageType;
@property(nonatomic,strong)NSMutableArray *narrationArray;
@property(nonatomic,strong)NSMutableArray *displayArray;
@property(nonatomic,strong)NSString *itembgimageiPod;
@property(nonatomic,strong)NSString *itembgimagetypeiPod;
@property(nonatomic,strong)NSString *itembgimagePortrait;
@property(nonatomic,strong)NSString *itembgimagetypePortrait;
@property(nonatomic,strong)NSString *itembgimageLandscape;
@property(nonatomic,strong)NSString *itembgimagetypeLandscape;


@end
