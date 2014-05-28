//
//  XMPPManager.h
//  day08Xmpp
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@class XMPPManager;
@protocol XMPPManagerDelegate <NSObject>
@required
-(void)XMPPManager:(XMPPManager*)sender didReceiveMessage:(XMPPMessage*)message;
@end

@interface XMPPManager : NSObject
+(XMPPManager*)shareManager;
-(void)sendMessage;
@property(strong,nonatomic) id<XMPPManagerDelegate> delegate;
-(void)sendMessage:(XMPPMessage*)XMPPMessage;
@end
