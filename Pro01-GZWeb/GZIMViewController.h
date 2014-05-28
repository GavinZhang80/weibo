//
//  GZIMViewController.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"
#import "GZUserInfo.h"

@interface GZIMViewController : UIViewController <XMPPManagerDelegate,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>
@property(strong,nonatomic) GZUserInfo *user;
@end
