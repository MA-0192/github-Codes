//
//  GlobalValues_InApp.m
//  iPadInApps
//
//  Created by User on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalValues_InApp.h"

static GlobalValues_InApp *sharedGlobalValues = nil;

@implementation GlobalValues_InApp

@synthesize strUnzipPackagePath;
@synthesize marrProductRequest;
@synthesize totalSizeArray;
@synthesize updatedDownLoadSizeArray;
@synthesize progressValueArray;
@synthesize productArray;
@synthesize remainingDownloadArray;
@synthesize updatesProductArray;
@synthesize activeDownLoadBool;
@synthesize activeDownLoadClicked;
@synthesize purchasedItemIDs;
@synthesize boolAudioPackageDownloading = _boolAudioPackageDownloading;

#pragma mark Singleton Methods

+ (id)sharedManager {
    @synchronized(self) {
        if(sharedGlobalValues == nil)
            sharedGlobalValues = [[super allocWithZone:NULL] init];
    }
    return sharedGlobalValues;
}

+ (id)allocWithZone:(NSZone *)zone {
    //return [[self sharedManager] retain];
	return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (self = [super init]) {
        //self.popOver = [[UIPopoverController alloc] init];
        //self.barButton = [[UIBarButtonItem alloc] init];
        self.marrProductRequest = [[NSMutableArray alloc] init];
		self.totalSizeArray = [[NSMutableArray alloc] init];
		self.updatedDownLoadSizeArray = [[NSMutableArray alloc] init];
		self.productArray = [[NSMutableArray alloc] init];
		self.remainingDownloadArray = [[NSMutableArray alloc] init];
        self.updatesProductArray = [[NSMutableArray alloc]init];
        self.strUnzipPackagePath = [[NSString alloc]init];
        self.purchasedItemIDs = [[NSMutableArray alloc]init];
        self.boolAudioPackageDownloading = NO;
    }
	
    return self;
}

@end


