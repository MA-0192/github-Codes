//
//  GlobalValues_InApp.h
//  iPadInApps
//
//  Created by User on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalValues_InApp : NSObject

@property (strong, nonatomic) NSString                  *strUnzipPackagePath;
@property (nonatomic, strong) NSMutableArray            *marrProductRequest;
@property (nonatomic, strong) NSMutableArray            *totalSizeArray;
@property (nonatomic, strong) NSMutableArray            *updatedDownLoadSizeArray;
@property (nonatomic, strong) NSMutableArray            *productArray;
@property (nonatomic, strong) NSMutableArray            *progressValueArray;
@property (nonatomic, strong) NSMutableArray            *remainingDownloadArray;
@property (nonatomic, strong) NSMutableArray            *updatesProductArray;
@property (nonatomic)         BOOL                       activeDownLoadBool;
@property (strong, nonatomic) NSMutableArray            *purchasedItemIDs;
@property (nonatomic)         BOOL                       activeDownLoadClicked;
@property (nonatomic) BOOL boolAudioPackageDownloading;

+ (id)sharedManager;

@end
