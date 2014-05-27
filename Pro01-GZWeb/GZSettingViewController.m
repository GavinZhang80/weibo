//
//  GZSettingViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZSettingViewController.h"

@interface GZSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myLoginOrLogout;
@end

@implementation GZSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

    //登录情况检测
    [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
        
        NSLog(@"GZSettingViewController obj = %d",[obj boolValue]);
        
        self.myLoginOrLogout.tag = [obj boolValue];
        
        switch (self.myLoginOrLogout.tag) {
            case 0: //需要登录
            {
                [self.myLoginOrLogout setTitle:@"login..." forState:UIControlStateNormal];
                break;
            }
            case 1: //需要注销
            {
                [self.myLoginOrLogout setTitle:@"logout" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        
    }];
}


- (IBAction)myLoginOrLogoutAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0: //需要登录
        {
            [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
                if ([obj boolValue]) {
                    NSLog(@"loged!");
                }else{
                    NSLog(@"login failed");
                }
            }];
            break;
        }
        case 1: //需要注销
        {
            [[GZMyWeiboApi shareWeiboApi] cancelAuth];
            [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
                NSLog(@"myLoginOrLogoutAction obj = %d",[obj boolValue]);
            }];
            break;
        }
        default:
            break;
    }
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
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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