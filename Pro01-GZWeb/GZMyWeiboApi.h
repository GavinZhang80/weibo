//
//  GZMyWeiboAip.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboApi.h"

typedef void (^CALLBACK)(id obj);

@interface GZMyWeiboApi : NSObject
+(WeiboApi*)shareWeiboApi;
+(GZMyWeiboApi*)shareMyWeiboApi;
-(void)checkAuthValidWithRootController:(UIViewController*)rootContoroller andCallback:(CALLBACK)completion;
@end
