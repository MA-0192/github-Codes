//
//  MPMRAIDBannerCustomEvent.h
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPBannerCustomEvent.h"
#import "MRAdView.h"
#import "MPPrivateBannerCustomEventDelegate.h"

@interface MPMRAIDBannerCustomEvent : MPBannerCustomEvent <MRAdViewDelegate>

@property (nonatomic, unsafe_unretained) id<MPPrivateBannerCustomEventDelegate> delegate;

@end
