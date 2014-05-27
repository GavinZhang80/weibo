//
//  XMPPManager.m
//  day08Xmpp
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "XMPPManager.h"
#import "GZAppDelegate.h"
#import "GZIMViewController.h"
#import "GZMyWeiboManager.h"
#import "GZFriendsViewController.h"

@interface XMPPManager()
@property(strong,nonatomic) XMPPStream *xmppStream;
@end

static XMPPManager *_xmappManager;
@implementation XMPPManager
+(XMPPManager*)shareManager{
    if (!_xmappManager) {
        _xmappManager = [[XMPPManager alloc]init];
    }
    return _xmappManager;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initXMPP];
    }
    return self;
}

-(void)initXMPP{
    //xmpp初始化
    self.xmppStream = [[XMPPStream alloc]init];
    //设置delegate
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置主机地址：外网（远程同学）：124.207.192.18 内网地址：172.60.5.100
    [self.xmppStream setHostName:@"124.207.192.18"];
    //设置端口
    [self.xmppStream setHostPort:5222];
    //设置当前用户id
    NSString *userID = [NSString stringWithFormat:@"%@@tareng3gxmpp.com",@"yxwlzsh"];
    XMPPJID *jid = [XMPPJID jidWithString:userID];
    [self.xmppStream setMyJID:jid];
    //开始连接服务器
    //[self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:Nil];
    //    socket：效率高 长连接 消息传递实时
    //    http：容错性强 操作简单 开发效率高
    
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"login error = %@", error);
    }
}
//连接到了服务器
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"成功连接到服务器");
    //   连接到服务器后 用当前账号 登陆   发出登陆的请求
    [self.xmppStream authenticateWithPassword:@"aaaaaaaa" error:Nil];
}
//服务器断开
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"服务器断开连接");
}
//登陆成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登陆成功");
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}
//登陆失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登陆失败");
    //    如果登陆失败 开始注册
    [self.xmppStream registerWithPassword:@"aaaaaaaa" error:Nil];
}
//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功！！！");
    //    注册成功后 需要登陆
    [self.xmppStream authenticateWithPassword:@"aaaaaaaa" error:Nil];
}
//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
}

//接收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//    NSLog(@"%@说：%@",[[message from]user],[message body]);
    //self.messageTF.text = [NSString stringWithFormat:@"%@\n%@:%@",self.messageTF.text,[[message from]user],[message body]];
//    -(void)XMPPManager:(XMPPManager*)sender didReceiveMessage:(XMPPMessage*)message;
    if (self.delegate) {
        [self.delegate XMPPManager:self didReceiveMessage:message];
    }else{
        GZAppDelegate *app = [UIApplication sharedApplication].delegate;
        GZIMViewController *vc = [app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"IMVC"];
        GZFriendsViewController *vc2 = [app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"findsVC"];
        [[GZMyWeiboManager shareManager] getUserInfoFromeUser:[[message from] user] completion:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                vc.user = obj;
                [vc2.navigationController pushViewController:vc animated:YES];
            });
        }];
    }
}
-(void)sendMessage{
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendMess) userInfo:nil repeats:YES];
}
-(void)sendMess{
    XMPPJID *toJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@tareng3gxmpp.com",@"1402GavinZhang"]];
    XMPPMessage *message = [XMPPMessage messageWithType:@"text" to:toJid];
    [message addBody:@"这是第一个页面发送的消息"];
    [self.xmppStream sendElement:message];
    //self.messageTF.text = [NSString stringWithFormat:@"%@\n我说:%@",self.messageTF.text,self.messTF.text];
}
-(void)sendMessage:(NSString*)message toUser:(NSString*)account{
    XMPPJID *toJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@tareng3gxmpp.com",account]];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"text" to:toJid];
    [msg addBody:message];
    [self.xmppStream sendElement:msg];
}

@end
