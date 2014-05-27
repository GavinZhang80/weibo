//
//  GZParseUserInfo.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZParseInfo.h"
#import "UIImageView+WebCache.h"

@implementation GZParseInfo
+(GZUserInfo *)parseUserInfo:(NSDictionary *)userInfoDic andListID:(NSString*)listID{
    //NSLog(@"parseUserInfo dic = %@",dic);
    
    
    NSDictionary *dic = userInfoDic;
    
    //给用户消息对象赋值;
    GZUserInfo *userInfo = [[GZUserInfo alloc]init];
    if ([dic isMemberOfClass:[NSNull class]]) {
        NSLog(@"源数据无效:parseUserInfo");
        return userInfo;
    }
    
    //账户名
    userInfo.name = [dic valueForKey:@"nick"];
    //昵称
    userInfo.name2 = [dic valueForKey:@"name"];
    //公司/所在地
    userInfo.location = [dic valueForKey:@"location"];
    //当前位置
    userInfo.location2 = [[dic valueForKey:@"tweetinfo"] valueForKey:@"location"];
    //个人介绍
    userInfo.introduction = ((NSString*)[dic valueForKey:@"introduction"]).length>0 ? [dic valueForKey:@"introduction"] : @"这家伙很懒,什么都没有留下!";
    //生日
    userInfo.birhday = [NSString stringWithFormat:@"%@.%@",[dic valueForKey:@"birth_month"],[dic valueForKey:@"birth_day"]];
    //用户唯一id，与name相对应;
    userInfo.openid = [dic valueForKey:@"openid"];
    //用所在名单ID;
    userInfo.listid = listID;
    //头像
    NSURL *url = [NSURL URLWithString:[[dic valueForKey:@"head"] stringByAppendingString:@"/100"]];
    NSData *dataIcon = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
    userInfo.iconImage = [UIImage imageWithData:dataIcon];
    //改别
    int sex = [[dic valueForKey:@"sex"]intValue];
    userInfo.gender  = sex == 1 ? @"男" : (sex == 0 ? @"未知" : @"女");
    //年龄
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    userInfo.age = [[formatter stringFromDate:[NSDate date]]intValue] - [[dic valueForKey:@"birth_year"]intValue];
    
    return userInfo;
}

//listID解析
+(NSMutableDictionary *)parseListID:(NSData *)listData{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:listData options:0 error:nil];
    
    //NSLog(@"getFriendsList dic = %@",[dic valueForKey:@"data"]);
    if ([dic isMemberOfClass:[NSNull class]]) {
        return [NSMutableDictionary dictionary];
    }
    
    
    NSArray *listIDs = [[dic valueForKey:@"data"] valueForKey:@"info"];
    //NSLog(@"parseList list = %@",list);
    NSMutableDictionary *listIDDic = [NSMutableDictionary dictionary];
    
    
    for (NSDictionary *listID in listIDs) {
        //获取成员数大于1的名单
        NSString *membernums = [listID valueForKey:@"membernums"];
        if ([membernums intValue] > 0) {
            [listIDDic setObject:membernums forKey:[listID valueForKey:@"listid"] ];
        }
    }
    

    //如果所有名单都没有成员,就返回第一个名单
    if (listIDDic.allKeys.count == 0) {
        return listIDs[0];
    }else{
        return listIDDic;
    }
    
    
}

+(NSDictionary *)parseCreateListID:(NSData *)creatListData{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:creatListData options:0 error:nil];
    dic = [dic valueForKey:@"data"];
    NSDictionary *listIDDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [dic valueForKey:@"membernums"],[dic valueForKey:@"listid"], nil];
    return listIDDic;
}

//解析用户列表
+(NSArray*)parseUserList:(NSDictionary*)userListDic andListID:(NSString*)listID{
    
    NSArray *array = [userListDic valueForKey:@"data"];
    
    NSMutableArray *users = [NSMutableArray array];
    if ([array isMemberOfClass:[NSNull class]]) {
        return  [NSArray array];
    }
    
    for (NSDictionary *userDic in array) {
        GZUserInfo *userInfo = [GZParseInfo parseUserInfo:userDic andListID:(NSString*)listID];
        [users addObject:userInfo];
    }
    
    return users;
}

//解析weibo数据
/*
+(GZWeibo*)parseWeiboByWeiboDic:(NSDictionary*)weiboDic{
    
    GZWeibo *weibo = [[GZWeibo alloc]init];
    if ([weiboDic isMemberOfClass:[NSNull class]]) {
        return weibo;
    }
    //微博的创建时间
    weibo.createDate = [weiboDic valueForKey:@"timestamp"];
    //微博id
    weibo.weiboId = [weiboDic valueForKey:@"id"];
    //微博内容
    weibo.text = [weiboDic valueForKey:@"text"];
    //微博来源
    weibo.source = [weiboDic valueForKey:@"from"];
    //微博经纬度
    weibo.longitude = [weiboDic valueForKey:@"longitude"];
    weibo.latitude = [weiboDic valueForKey:@"latitude"];
    
    
    //获取用户信息
    GZUserInfo *user = [[GZUserInfo alloc]init];
    //头像图片
    user.iconURL  = [[weiboDic objectForKey:@"head"]stringByAppendingString:@"/100"];
    user.name     = [weiboDic objectForKey:@"name"];//昵称
    user.name2    = [weiboDic objectForKey:@"nick"];
    user.gender   = [weiboDic objectForKey:@"sex"];
    user.openid   = [weiboDic objectForKey:@"openid"];
    user.location = [weiboDic objectForKey:@"location"];//地址
    weibo.user    = user;
    
    //缩略图片地址，没有时不返回此字段
    NSArray *images = [weiboDic objectForKey:@"image"];
    if (![images isMemberOfClass:[NSNull class]]&&images.count>0) {
        weibo.thumbnailImage = [[images objectAtIndex:0]stringByAppendingString:@"/160"];
    }
    
    //被转发的原微博
    NSDictionary *reWeiboDic = [weiboDic objectForKey:@"source"];
    //判断是否有转发
    if (reWeiboDic && ![reWeiboDic isMemberOfClass:[NSNull class]]) {
        
        weibo.relWeibo = [GZParseInfo parseWeiboByWeiboDic:reWeiboDic];
        //是转发的微博
        //weibo.isRepost = [[weiboDic valueForKey:@"self"]boolValue];
        weibo.relWeibo.isRepost = YES;
    }
    
    return weibo;
}*/

+(GZWeibo *)parseWeiboByWeiboDic:(NSDictionary*)dic{
    GZWeibo *myWeibo = [[GZWeibo alloc]init];
    NSString *timestamp = [dic objectForKey:@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH点mm分"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    myWeibo.createDate = dateStr;
    
    myWeibo.text = [dic objectForKey:@"text"];
    
    myWeibo.source = [dic objectForKey:@"from"];
    myWeibo.latitude = [dic objectForKey:@"latitude"];
    myWeibo.longitude = [dic objectForKey:@"longitude"];
    NSArray *images = [dic objectForKey:@"image"];
    if (![images isMemberOfClass:[NSNull class]]&&images.count>0) {
        myWeibo.thumbnailImage = [[images objectAtIndex:0]stringByAppendingString:@"/160"];
        
    }
    id weiboID  = [dic objectForKey:@"id"];
    myWeibo.weiboId = [NSString stringWithFormat:@"%@",weiboID];
    
    
    //获取用户信息
    GZUserInfo *user = [[GZUserInfo alloc]init];
    //头像图片
    user.iconURL = [[dic objectForKey:@"head"]stringByAppendingString:@"/100"];
    //昵称
    user.name2 = [dic objectForKey:@"name"];
    user.name = [dic objectForKey:@"nick"];
    
    user.gender = [dic objectForKey:@"sex"];
    user.openid = [dic objectForKey:@"openid"];
    //地址
    user.location = [dic objectForKey:@"location"];
    myWeibo.user = user;
    
    
    
    NSDictionary *reWeiboDic = [dic objectForKey:@"source"];
    //判断是否有转发
    if (reWeiboDic && ![reWeiboDic isMemberOfClass:[NSNull class]]) {
        
        myWeibo.relWeibo = [GZParseInfo parseWeiboByWeiboDic:reWeiboDic];
        myWeibo.relWeibo.isRepost = YES;
        NSLog(@"myWeibo.relWeibo.isRepost = %d", myWeibo.relWeibo.isRepost);
    }
    return myWeibo;
}

//==========================================
//解释评论列表
//==========================================
+ (Comment*)paseCommentsByDictionary:(NSDictionary*)dic {
    Comment *comment = [[Comment alloc]init];
    NSString *timestamp = [dic objectForKey:@"timestamp"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM.dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    comment.createdDate = dateStr;
    comment.text = [dic objectForKey:@"text"];
    comment.source = [dic objectForKey:@"from"];
    //获取用户信息
    GZUserInfo *user = [[GZUserInfo alloc]init];
    //头像图片
    user.iconURL = [[dic objectForKey:@"head"] stringByAppendingString:@"/100"];
    //昵称
    user.name = [dic objectForKey:@"nick"];
    
    user.gender = [dic objectForKey:@"sex"];
    user.openid = [dic objectForKey:@"openid"];
    //地址
    user.location = [dic objectForKey:@"location"];
    
    comment.user = user;
    return comment;
}
@end
