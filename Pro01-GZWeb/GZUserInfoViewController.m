//
//  GZUserInfoViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-20.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZUserInfoViewController.h"
#import "GZUserInfo.h"
#import "GZMyWeiboManager.h"
#import "GZMyWeiboApi.h"
#import "GZTopicViewController.h"

@interface GZUserInfoViewController ()
@property (weak, nonatomic ) IBOutlet UIImageView *myICON;
@property (weak, nonatomic ) IBOutlet UILabel     *myName;
@property (weak, nonatomic ) IBOutlet UILabel     *myName2;
@property (weak, nonatomic ) IBOutlet UILabel     *myGender;
@property (weak, nonatomic ) IBOutlet UILabel     *myAge;
@property (weak, nonatomic ) IBOutlet UILabel     *myBirthDay;
@property (weak, nonatomic ) IBOutlet UILabel     *myAddress;
@property (weak, nonatomic ) IBOutlet UITextView  *myIntroduction;

@end

@implementation GZUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"boot yes = %d", YES);
    
    self.myICON.layer.cornerRadius = self.myICON.bounds.size.width/2;
    self.myICON.layer.masksToBounds = YES;
    self.myName.text = @"";  //空表示界面需要更新;
    
    if (!self.userInfo) {
        [[GZMyWeiboManager shareManager] getUserInfoSelf:^(id obj) {
            self.userInfo = obj;
            //回到主线程更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        }];
    }else{
        [[GZMyWeiboManager shareManager] getUserInfoFromeUser:self.userInfo.name2 completion:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInfo = obj;
                [self updateUI];
            });
        }];
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    //登录情况检测
    [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
        NSLog(@"GZTopicViewController obj = %d",[obj boolValue]);
    }];
}


-(void)updateUI{
    //把信息显示在界面上;
    self.myName.text         = self.userInfo.name;
    self.myName2.text        = self.userInfo.name2;
    self.myGender.text       = self.userInfo.gender;
    self.myAge.text          = [NSString stringWithFormat:@"%d",self.userInfo.age];
    self.myBirthDay.text     = self.userInfo.birhday;
    self.myAddress.text      = self.userInfo.location;
    self.myIntroduction.text = self.userInfo.introduction;
    self.myICON.image        = self.userInfo.iconImage;
}
- (IBAction)toTopic:(UIButton *)sender {
    GZTopicViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVCTpic"];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)sendMessage:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
