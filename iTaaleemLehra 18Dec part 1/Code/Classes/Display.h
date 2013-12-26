//
//  Display.h
//  iAatman
//
//  Created by iPhone Developer on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Display : NSObject {
	NSString *displayLanguageName;
	NSString *displayText;
	NSString *displayImage;
	NSString *displayImageType;

}
@property(nonatomic,strong)NSString *displayLanguageName;
@property(nonatomic,strong)NSString *displayText;
@property(nonatomic,strong)NSString *displayImage;
@property(nonatomic,strong)NSString *displayImageType;
@end
