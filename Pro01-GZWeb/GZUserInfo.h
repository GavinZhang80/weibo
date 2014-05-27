//
//  GZUserInfo.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZUserInfo : NSObject
@property(copy,nonatomic) NSString *name;           //昵称
@property(copy,nonatomic) NSString *name2;          //账户名称
@property(copy,nonatomic) NSString *gender;         //性别
@property(copy,nonatomic) NSString *location;       // 公司/所在地
@property(copy,nonatomic) NSString *location2;      // 当前位置
@property(copy,nonatomic) NSString *introduction;   // 个人介绍
@property(copy,nonatomic) NSString *birhday;        //生日
@property(copy,nonatomic) NSString *openid; //用户唯一id，与name相对应;
@property(copy,nonatomic) NSString *listid; //用所在名单ID;
@property(copy,nonatomic) NSString *iconURL;         //头像


@property(strong,nonatomic) UIImage *iconImage;      //头像
@property(unsafe_unretained,nonatomic) int age;     //年龄

@end
