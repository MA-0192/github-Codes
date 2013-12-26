//
//  MPHTMLBannerCustomEvent.h
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPBannerCustomEvent.h"
#import "MPAdWebViewAgent.h"
#import "MPPrivateBannerCustomEventDelegate.h"

@interface MPHTMLBannerCustomEvent : MPBannerCustomEvent <MPAdWebViewAgentDelegate>

@property (nonatomic, unsafe_unretained) id<MPPrivateBannerCustomEventDelegate> delegate;

@end
