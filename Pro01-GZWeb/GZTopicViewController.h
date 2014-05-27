//
//  GZTopicViewController.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZUserInfo.h"
#import "GZCustomTextView.h"
#import "GZWeibo.h"

@interface GZTopicViewController : UITableViewController <GZCustomeTextViewDelegat>
@property(strong,nonatomic) GZUserInfo *userInfo;
@property(strong,nonatomic) GZWeibo *weibo;
@end
