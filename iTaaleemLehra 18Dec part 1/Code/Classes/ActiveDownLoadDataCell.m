//
//  ActiveDownLoadDataCell.m
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 _eBusinessware__. All rights reserved.
//

#import "ActiveDownLoadDataCell.h"
#import "ActiveDownload.h"
//#import "AppDelegate.h"
#import "GlobalValues_InApp.h"

@implementation ActiveDownLoadDataCell

@synthesize productName;
@synthesize productSize;
@synthesize progressView;
@synthesize objActiveDownload;
@synthesize ActiveDownLoadArray;

GlobalValues_InApp *globalValues_InApp;

-(void)setCellData:(NSInteger )cellNo
{
    globalValues_InApp = [GlobalValues_InApp sharedManager];
    
	self.productName.text = objActiveDownload.productName;
    MyLog(@"Product Name:%@",self.productName.text);
    
    
    
    if ([globalValues_InApp.updatedDownLoadSizeArray count] == 0)
    {
        self.productSize.text =  [NSString stringWithFormat:@"0 MB  / 0 MB"];
        self.progressView.progress = 0.0f;
        
    }
    else
    {
        
        //MyLog(@"globalValues_InApp.totalSizeArray %@",globalValues_InApp.totalSizeArray);
        
        //MyLog(@"globalValues_InApp.updatedDownLoadSizeArray %@",globalValues_InApp.updatedDownLoadSizeArray);
        
        self.progressView.progress = [[globalValues_InApp.progressValueArray objectAtIndex:cellNo] floatValue];
        
        self.productSize.text =  [NSString stringWithFormat:@"%0.2f MB  / %0.2f MB",[[globalValues_InApp.updatedDownLoadSizeArray objectAtIndex:cellNo] floatValue],[[globalValues_InApp.totalSizeArray objectAtIndex:cellNo] floatValue]];
    }
}




@end