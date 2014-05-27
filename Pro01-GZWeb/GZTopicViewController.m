//
//  GZTopicViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZTopicViewController.h"
#import "GZWeiboCell.h"
#import "GZMyWeiboApi.h"
#import "GZMyWeiboManager.h"
#import "GZDetailViewController.h"

@interface GZTopicViewController ()
@property(strong,nonatomic) NSArray *weibos;
@property(strong,nonatomic) NSMutableArray *indexPs;
@property(strong,nonatomic) NSMutableDictionary *dic;
@property(strong,nonatomic) GZWeiboCell *cell; //test cell

@end

@implementation GZTopicViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexPs = [NSMutableArray array];
    self.dic = [NSMutableDictionary dictionary];
    self.cell = [[[NSBundle mainBundle]loadNibNamed:@"GZWeiboCell" owner:self options:nil]firstObject];
    
    //和微博列表共用VC
    if (!self.userInfo) {
        //navigationBar设置
        UIBarButtonItem *leftBtn1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new"] style:UIBarButtonItemStyleDone target:self action:@selector(toAddTopicVC)];
        UIBarButtonItem *leftBtn2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
        self.navigationItem.leftBarButtonItems = @[leftBtn1,leftBtn2];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.title = self.userInfo.name;
        [[GZMyWeiboManager shareManager] getUserTimeLineByUser:self.userInfo.openid completion:^(id obj) {
            self.weibos = obj;
            NSLog(@"obj = %@", obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
    
    //临时跳转
    //[self performSegueWithIdentifier:@"toAddTopicVC" sender:self];
    
}

-(void)toAddTopicVC{
    [self performSegueWithIdentifier:@"toAddTopicVC" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}


-(void)viewDidAppear:(BOOL)animated{
    //登录情况检测
    [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
        NSLog(@"GZTopicViewController obj = %d",[obj boolValue]);
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userInfo) {
        GZDetailViewController *iv = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        iv.weibo = self.weibos[indexPath.row];
        iv.title = @"微博内容";
        [self.navigationController pushViewController:iv animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cell.weibo = self.weibos[indexPath.row];
    [self.cell layoutSubviews];
    return [self.cell.tv getHeight]+50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.weibos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeiboCell";
    GZWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GZWeiboCell" owner:self options:nil]firstObject];
    }
    
    // Configure the cell...
    cell.weibo = self.weibos[indexPath.row];
    cell.icon.image = self.userInfo.iconImage;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
