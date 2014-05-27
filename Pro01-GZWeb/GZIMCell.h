//
//  GZIMCell.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZUserInfo.h"

@interface GZIMCell : UITableViewCell
@property(strong,nonatomic) NSString *message;
@property(strong,nonatomic) GZUserInfo *user;
-(float)getHeight;
@end
