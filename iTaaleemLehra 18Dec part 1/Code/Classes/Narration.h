//
//  Narration.h
//  iAatman
//
//  Created by iPhone Developer on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Narration : NSObject {
	NSString *languageName;
	NSString *artistName;
	NSString *artistInfo;
	NSString *artistImage;
	NSString *artistImageType;
	NSString *audioName;
	NSString *audioType;
	
	
	

}
@property(nonatomic,strong)NSString *languageName;
@property(nonatomic,strong)NSString *artistName;
@property(nonatomic,strong)NSString *artistInfo;
@property(nonatomic,strong)NSString *artistImage;
@property(nonatomic,strong)NSString *artistImageType;
@property(nonatomic,strong)NSString *audioName;
@property(nonatomic,strong)NSString *audioType;

@end
