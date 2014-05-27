//
//  GZMyWeiboManager.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CALLBACK)(id obj);

@interface GZMyWeiboManager : NSObject
+(GZMyWeiboManager*)shareManager;
-(void)getUserInfoSelf:(CALLBACK)completion;
-(void)getFriendList:(CALLBACK)completion;
-(void)getUserInfoFromeUser:(NSString*)userName completion:(CALLBACK)completion;
-(void)removeUser:(NSString*)userName andListID:(NSString*)listID completion:(CALLBACK)completion;
-(void)addUser:(NSString*)userName andListID:(NSString*)listID completion:(CALLBACK)completion;
-(void)getUserTimeLineByUser:(NSString*)userName completion:(CALLBACK)completion;
-(void)getCommentByWeiboID:(NSString*)weiboID completion:(CALLBACK)completion;
-(void)addCommentsByInfo:(NSString *)infoString andWeiboID:(NSString *)weiboID completion:(CALLBACK)completion;
@end
