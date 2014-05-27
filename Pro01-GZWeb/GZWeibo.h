//
//  GZWeibo.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-22.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZUserInfo.h"

@interface GZWeibo : NSObject

@property (nonatomic) BOOL isRepost;//是转发的微博

@property (nonatomic,copy  ) NSString *createDate;//微博的创建时间
@property (nonatomic,copy  ) NSString *weiboId;//微博id
@property (nonatomic,copy  ) NSString *text;//微博内容
@property (nonatomic,copy  ) NSString *source;//微博来源
@property (nonatomic,copy  ) NSString *thumbnailImage;//缩略图片地址，没有时不返回此字段

@property (nonatomic,strong) GZWeibo    *relWeibo;//被转发的原微博
@property (nonatomic,strong) GZUserInfo *user;//微博的作者用户

//微博经纬度
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,unsafe_unretained) float height;


-(float)getHeight;
@end
