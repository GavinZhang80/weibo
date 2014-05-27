//
//  GZMyWeiboManager.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZMyWeiboManager.h"
#import "GZMyWeiboApi.h"
#import "GZParseInfo.h"
#import "Comment.h"

#define BASE_URL @"http://open.t.qq.com/api/"


static GZMyWeiboManager *_WeiboManager;

@interface GZMyWeiboManager()
@property(copy,nonatomic) NSString *normalParams;  //请求能用参数
@property(copy,nonatomic) NSDictionary *listIDDic; //单名列表

@property(strong,nonatomic) NSOperationQueue *queue;

@property(unsafe_unretained,nonatomic) int asyncRequestCount; //判断是不所有子线程是否执行完成.
@property(unsafe_unretained,nonatomic) int asyncResbonseCount; //判断是不所有子线程是否执行完成.
@end


@implementation GZMyWeiboManager

//单例
+(GZMyWeiboManager *)shareManager{
    if (!_WeiboManager) {
        _WeiboManager = [[GZMyWeiboManager alloc]init];
    }
    return _WeiboManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc]init];
    }
    return self;
}

//网络请求通用参数
-(NSString *)normalParams{
    if (!_normalParams) {
        WeiboApiObject *weiboObj = [[GZMyWeiboApi shareWeiboApi] getToken];
        _normalParams = [NSString stringWithFormat:@"accesstoken=%@&openid=%@&appkey=%@&appsecret=%@",weiboObj.accessToken,weiboObj.openid,weiboObj.appKey,weiboObj.appSecret];
    }
   return _normalParams;
}


//get userInfo
-(void)getUserInfoSelf:(CALLBACK)completion{
    NSString *path = [NSString stringWithFormat:@"%@user/info?%@&format=json",BASE_URL,self.normalParams];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"requestUserInfo = %@",data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        completion([GZParseInfo parseUserInfo:[dic valueForKey:@"data"] andListID:nil]);
    }];
    
}


//get userInfo frome user id
-(void)getUserInfoFromeUser:(NSString*)userName completion:(CALLBACK)completion{
    
    NSString *path = [NSString stringWithFormat:@"%@user/other_info?%@&format=json&name=%@",BASE_URL,self.normalParams,userName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //NSLog(@"openid = %@, data = %d, path = %@", fopenid,data.length,path);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        GZUserInfo *user = [GZParseInfo parseUserInfo:[dic valueForKey:@"data"] andListID:nil];
        completion(user);
    }];
    
}



//create listID
-(void)createLists:(CALLBACK)completion{
    NSString *path = [NSString stringWithFormat:@"%@list/create",BASE_URL];
    NSString *params = [NSString stringWithFormat:@"?%@&format=json&name=我的名单&description=weiboFrends&tag=gzWeibo&access=1",self.normalParams];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *lists = [GZParseInfo parseCreateListID:data];
        completion(lists);
    }];
}


//get listID
-(void)getLists:(CALLBACK)completion{
    NSString *path = [NSString stringWithFormat:@"%@list/get_list",BASE_URL];
    NSString *params = [NSString stringWithFormat:@"?%@&format=json",self.normalParams];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"data.length = %d",data.length);
        NSDictionary *listIDic = [GZParseInfo parseListID:data];
        NSLog(@"list = %@", listIDic);
        
        if (listIDic.allKeys.count == 0) {  //没有listID
            NSLog(@"listIDic.allKeys.count == 0) {  //没有listID");
            
            [self createLists:^(id obj) {
                
                //新创建的listID没有用户,是一个字符串.
                completion(obj);
            }];
        }else{  //有listID
            
            completion(listIDic);
        }
        
        
        
    }];
}

//get friendsList
-(void)getFriendList:(CALLBACK)completion{
    NSLog(@"listIDDic = %@",self.listIDDic);
    
    if (self.listIDDic) {  //直接查询好友列表
        NSLog(@"//直接查询好友列表 self.listID = %@",self.listIDDic);
        
        //多个listID循环取用户
        for (NSString *listID in self.listIDDic) {
            
            //需要请求的次数
            int j = [[self.listIDDic valueForKey:listID] intValue];
            int h = (j%15)==0 ? (j/15) : j/15+1;
            
            //取完每个listID的所有用户,接口限制每次只能取1页(即15个)
            for (int i=0; i<h; i++) {
                NSString *path = [NSString stringWithFormat:@"%@list/listusers",BASE_URL];
                NSString *params = [NSString stringWithFormat:@"?%@&format=json&listid=%@&pageflag=%d",self.normalParams,listID,i];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
                
                [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                        NSArray *users = [GZParseInfo parseUserList:dic andListID:listID];
                        NSLog(@"users = %@", users);
                        completion(users);
                    });
                    
                    
                }];
            }
        }
        
        
    }else{  //获得列表ID
        NSLog(@"///获得列表ID");

        [self getLists:^(id obj) {
        
            self.listIDDic = obj;
            [self getFriendList:completion];
        }];
    }
    
}


//从名单列表删除指定用户
-(void)removeUser:(NSString*)userName andListID:(NSString*)listID completion:(CALLBACK)completion{
    
        NSString *path = [NSString stringWithFormat:@"%@list/del_from_list",BASE_URL];
        NSString *params = [NSString stringWithFormat:@"?%@&format=json&names=%@&listid=%@",self.normalParams,userName,listID];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
         NSLog(@"userName = %@, andListID = %@",userName,listID);
        [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"retDic = %@ ",retDic);
            NSString *retStr = [retDic valueForKey:@"ret"];
            completion(retStr);
            
        }];
    
}

//从名单中添加用户
-(void)addUser:(NSString*)userName andListID:(NSString*)listID completion:(CALLBACK)completion{
    
    NSString *path = [NSString stringWithFormat:@"%@list/add_to_list",BASE_URL];
    NSString *params = [NSString stringWithFormat:@"?%@&format=json&names=%@&listid=%@",self.normalParams,userName,self.listIDDic.allKeys[0]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"userName = %@, andListID = %@",userName,listID);
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"addUser retDic = %@ ",[retDic valueForKey:@"msg"]);
        NSString *retStr = [retDic valueForKey:@"ret"];
        completion(retStr);
        
    }];
    
}


/*
//获取用户最新微博
-(void)getUserTimeLineByUser:(NSString*)userName completion:(CALLBACK)completion;{
    
    NSMutableArray *weibos = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"%@statuses/user_timeline?%@&format=json&name=%@&pageflag=0&pagetime=0&reqnum=10&lastid=0&type=0&contenttype=0",BASE_URL,self.normalParams,userName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *weiboDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"getUserTimeLineByUserOpenid retDic = %@ ",weiboDic);
        NSDictionary *weiboDicWithDate = [weiboDic valueForKey:@"data"];
        NSArray *weiboArray = [weiboDicWithDate valueForKey:@"info"];
        
        for (NSDictionary *dic in weiboArray) {
            GZWeibo *weibo = [GZParseInfo parseWeiboByWeiboDic:dic];
            NSLog(@"getUserTimeLineByUser = %@", weibo);
            [weibos addObject:weibo];
        }
        completion(weibos);
        
    }];
}**/

//获取用户所发微博接口
-(void)getUserTimeLineByUser:(NSString *)userName completion:(CALLBACK)completion{
    
    NSString *path = [NSString stringWithFormat:@"%@statuses/user_timeline",BASE_URL];
    NSString *params = [NSString stringWithFormat:@"?%@&format=json&fopenid=%@&listid=0&reqnum=20&pageflag=0&type=0&contenttype=0&pageTime=0",self.normalParams,userName];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *listsDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
        
        NSDictionary *dic = [listsDic objectForKey:@"data"];
        NSArray *weibosDic = [dic objectForKey:@"info"];
        NSMutableArray *weibos = [NSMutableArray array];
        for (NSDictionary *weiboDic in weibosDic) {
            GZWeibo *w = [GZParseInfo parseWeiboByWeiboDic:weiboDic];
            NSLog(@"w = %@", w);
            [weibos addObject:w];
        }
        completion(weibos);
        
    }];
}


//获取微博评论列表
-(void)getCommentByWeiboID:(NSString*)weiboID completion:(CALLBACK)completion{
    NSString *path = [NSString stringWithFormat:@"%@t/re_list?%@&format=json&flag=2&rootid=%@&reqnum=100&pagetime=0&pageflag=0&",BASE_URL,self.normalParams,weiboID];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([dataDic isMemberOfClass:[NSNull class]]) {
            NSLog(@"getCommentByWeiboID:%@",[dic valueForKey:@"msg"]);
            return ;
        }
        NSArray *commentsDic = [dataDic objectForKey:@"info"];
        NSMutableArray *comments =[NSMutableArray array];
        for (NSDictionary *commentDic in commentsDic) {
            Comment *c = [GZParseInfo paseCommentsByDictionary:commentDic];
            [comments addObject:c];
        }
        completion(comments);
    }];

}


//==========================================
//发一条微博 待完成
//==========================================
//-(void)sendWeiboAction{
//    NSLog(@"sendWeiboAction...");
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
//                                   self.addTopicTF.text, @"content",
//                                   self.MyIconIV.image, @"pic",
//                                   nil];
//    [[GZMyWeiboApi shareWeiboApi] requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
//    [self.addTopicTF resignFirstResponder];
//}

//添加一条评论
-(void)addCommentsByInfo:(NSString *)infoString andWeiboID:(NSString *)weiboID completion:(CALLBACK)completion{
    
    NSString *path = [NSString stringWithFormat:@"%@t/comment",BASE_URL];
    NSString *params = [NSString stringWithFormat:@"?%@&format=json&content=%@&reid=%@",self.normalParams,infoString,weiboID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *addCommentRelDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
        if ([[addCommentRelDic valueForKey:@"ret"]intValue] == 0) {
            NSLog(@"评论成功...");
        }else{
            NSLog(@"评论失败:%@",[addCommentRelDic valueForKey:@"msg"]);
        }
        //服务器返回数据时调回这里从这里可以判断是否评论成功
        completion([addCommentRelDic valueForKey:@"ret"]);
        
    }];
    
    
}
@end



