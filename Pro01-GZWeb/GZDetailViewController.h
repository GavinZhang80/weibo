//
//  GZDetailViewController.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-26.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZWeibo.h"
#import "GZWeiboCell.h"

@interface GZDetailViewController : UITableViewController <UIAlertViewDelegate>
@property(strong,nonatomic) GZWeibo *weibo;
@property(strong,nonatomic) GZWeiboCell *header;
@end
