//
//  GZParseInfo.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZUserInfo.h"
#import "GZWeibo.h"
#import "Comment.h"

@interface GZParseInfo : NSObject
+(GZUserInfo*)parseUserInfo:(NSDictionary*)userInfoDic andListID:(NSString*)listID;
+(NSArray*)parseUserList:(NSDictionary*)userListDic andListID:(NSString*)listID;             //用户列表

+(NSMutableDictionary*)parseListID:(NSData*)listData;                       //名单ID列表
+(NSDictionary*)parseCreateListID:(NSData *)creatListData;
+(GZWeibo*)parseWeiboByWeiboDic:(NSDictionary*)weiboDic;
+(Comment*)paseCommentsByDictionary:(NSDictionary*)dic;
@end
