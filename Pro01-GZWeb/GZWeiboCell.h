//
//  GZWeiboCell.h
//  Pro01-GZWeb
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZWeibo.h"
#import "GZCustomTextView.h"
#import "GZUserInfo.h"

@interface GZWeiboCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIButton *chat;

@property(strong,nonatomic) GZWeibo *weibo;
@property(strong,nonatomic) GZCustomTextView *tv;
@end
