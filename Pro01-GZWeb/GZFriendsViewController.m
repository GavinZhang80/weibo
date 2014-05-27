//
//  GZFriendsViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZFriendsViewController.h"
#import "GZMyWeiboApi.h"
#import "GZMyWeiboManager.h"
#import "GZFirendsCell.h"
#import "GZUserInfoViewController.h"

@interface GZFriendsViewController ()
@property(strong,nonatomic) NSMutableArray *users;
@property(unsafe_unretained,nonatomic) int usersIndex;
@property(strong,nonatomic) NSMutableArray *usersIndexPathes;
@end

@implementation GZFriendsViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *lightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
    self.navigationItem.rightBarButtonItem = lightBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addUser{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"添加好友" message:@"请输入好友的name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {//添加好友
        NSString* userName = [alertView textFieldAtIndex:0].text;
        
        [[GZMyWeiboManager shareManager] addUser:userName andListID:nil completion:^(id obj) {
            [self getFriends];
        }];
            
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"self.users.count = %d", self.users.count);
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendsCell";
    GZFirendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.userInfo = self.users[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GZUserInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoVC"];
    vc.userInfo = self.users[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)getFriends{
    [self viewWillAppear:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    //获得好友列表
    self.users = [NSMutableArray array];
    [[GZMyWeiboManager shareManager] getFriendList:^(id obj) {
        [self.users addObjectsFromArray: obj];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"self.users = %@", self.users);
            [self.tableView reloadData];
        });
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    //登录情况检测
    [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
        //NSLog(@"GZTopicViewController obj = %d",[obj boolValue]);
    }];
    //[[GZMyWeiboApi shareWeiboApi]loginWithDelegate:self andRootController:self];
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        GZUserInfo *user = self.users[indexPath.row];
        [[GZMyWeiboManager shareManager] removeUser:user.name2 andListID:user.listid completion:^(id obj) {
            NSLog(@"obj = %@, user.listed = %@", obj,user.listid);
            dispatch_async(dispatch_get_main_queue(), ^{
                //从服务器上删除成功
                if ([obj intValue] == 0) {
                    [self.users removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            });
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
