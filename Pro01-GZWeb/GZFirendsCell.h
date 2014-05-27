//
//  GZFirendsCell.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZUserInfo.h"

@interface GZFirendsCell : UITableViewCell
@property(strong,nonatomic) GZUserInfo *userInfo;
@property(strong,nonatomic) id delegate;
@end
