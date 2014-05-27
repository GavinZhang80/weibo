//
//  GZMyWeiboAip.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZMyWeiboApi.h"
#import "constant.h"


static WeiboApi *_weiboApi;
static GZMyWeiboApi *_myWeiboApi;


@interface GZMyWeiboApi()
@property(strong,nonatomic) UIViewController *rootContoroller;
@property(unsafe_unretained,nonatomic) BOOL loginState;
@property(unsafe_unretained,nonatomic) BOOL didLoginStateCheck;
@end


@implementation GZMyWeiboApi

//官方库
+(WeiboApi*)shareWeiboApi{
    if (!_weiboApi) {
        _weiboApi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
    return _weiboApi;
}

//自定义
+(GZMyWeiboApi*)shareMyWeiboApi{
    if (!_myWeiboApi) {
        _myWeiboApi = [[GZMyWeiboApi alloc]init];
    }
    return _myWeiboApi;
}

//==========================================
//登录情况检测
//==========================================
-(void)checkAuthValidWithRootController:(UIViewController*)rootContoroller andCallback:(CALLBACK)completion{
    self.rootContoroller = rootContoroller;
    self.loginState = NO;
    self.didLoginStateCheck = NO;
    
    //检查登录有效性;
    //[[GZMyWeiboApi shareWeiboApi] checkAuthValid:TCWBAuthCheckServer andDelegete:self];
    [[GZMyWeiboApi shareWeiboApi] loginWithDelegate:self andRootController:self.rootContoroller];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i=0;
        for (; i<30; i++) {
            if (self.didLoginStateCheck) break;
            [NSThread sleepForTimeInterval:1];
        }
        if (i>=30) {
            NSLog(@"子线程请求了太久没有得到服务器反回结果,请检查你的登录情况!");
        }else if(self.loginState){
            NSLog(@"子线程检测到登录状态正常!");
        }else{
            NSLog(@"子线程检测到登录状态失败,请确认登录状态是否正常!");
        }
        completion([NSNumber numberWithBool:self.loginState]);
    });
}

- (void)didCheckAuthValid:(BOOL)bResult suggest:(NSString*)strSuggestion{
    //NSLog(@"bResult = %d, strSuggestion = %@",bResult,strSuggestion);
    if (!bResult) {
        NSLog(@"没有登录,马上开始登录...:didCheckAuthValid");
        dispatch_async(dispatch_get_main_queue(), ^{  //loginWithDelegate官方要求回主动强制回到主线程使用
            [[GZMyWeiboApi shareWeiboApi] loginWithDelegate:self andRootController:self.rootContoroller];
        });
    }else{
        NSLog(@"登录有效:didCheckAuthValid");
        self.loginState = YES;
        self.didLoginStateCheck = YES;
    }
}
- (void)DidAuthFinished:(WeiboApiObject *)wbobj{
    NSLog(@"成功登录! :DidAuthFinished");
    self.loginState = YES;
    self.didLoginStateCheck = YES;
}
- (void)DidAuthCanceled:(WeiboApiObject *)wbobj{
    NSLog(@"取消登录... :DidAuthCanceled");
    self.loginState = NO;
    self.didLoginStateCheck = YES;
    
}
- (void)DidAuthFailWithError:(NSError *)error{
    NSLog(@"登录失败! :DidAuthCanceled");
    self.loginState = NO;
    self.didLoginStateCheck = YES;
}
@end
