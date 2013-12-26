//
//  ActiveDownLoadDataCell.h
//  iPooja
//
//  Created by Aditya A. Kamble on 07/06/11.
//  Copyright 2010 ebusinessware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActiveDownload;

@class AppDelegate;

@interface ActiveDownLoadDataCell : UITableViewCell
{
	UILabel *productName;
	UILabel *productSize;
	UIProgressView *progressView;
	ActiveDownload *objActiveDownload;
	AppDelegate *appDelegate;
	NSMutableArray *ActiveDownLoadArray;
}

@property(nonatomic,strong) NSMutableArray *ActiveDownLoadArray;
@property (nonatomic,strong) IBOutlet UILabel *productName;
@property (nonatomic,strong) IBOutlet UILabel *productSize;
@property (nonatomic,strong) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong) ActiveDownload *objActiveDownload;

//-(void)setCellData;
-(void)setCellData:(NSInteger )cellNo;


@end
