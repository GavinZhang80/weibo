//
//  GZDetailViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-26.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZDetailViewController.h"
#import "GZWeiboCell.h"
#import "GZCustomTextView.h"
#import "UIImageView+WebCache.h"
#import "GZMyWeiboManager.h"
#import "GZCommentCell.h"

@interface GZDetailViewController ()
@property(strong,nonatomic) NSArray *comments;
@property(strong,nonatomic) GZCommentCell *commentCell;
@end

@implementation GZDetailViewController

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
    self.commentCell = [[GZCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    [self addHeaderView];
    [self getComment];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getComment{
    [[GZMyWeiboManager shareManager]getCommentByWeiboID:self.weibo.weiboId  completion:^(id obj) {
        self.comments = obj;
        NSLog(@"self.comments = %@", self.comments);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

//添加评论
-(void)messageAction{
    UIAlertView *messageAV = [[UIAlertView alloc]initWithTitle:@"请输入评论内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [messageAV setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [messageAV show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *commentString = [alertView textFieldAtIndex:0].text;
    if (buttonIndex==1) {
        if (commentString&&![commentString isEqualToString:@""]) {
            //添加评论
            [[GZMyWeiboManager shareManager]addCommentsByInfo:commentString andWeiboID:self.weibo.weiboId completion:^(id obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getComment];
                });
            }];
            
            
        }
        
    }
}


//添加表头,被评论的weibo
-(void)addHeaderView{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    //icon
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSURL *url = [NSURL URLWithString:self.weibo.user.iconURL];
    [icon setImageWithURL:url];
    icon.backgroundColor = [UIColor grayColor];
    [header addSubview:icon];
    
    //nick
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0,280,50)];
    nickLabel.text = self.weibo.user.name;
    [header addSubview:nickLabel];
    
    //chat
    UIButton *chat=[UIButton buttonWithType:UIButtonTypeCustom];
    chat.frame=CGRectMake(130, 35, 110, 20);
    [chat setTitle:@"和TA聊天" forState:UIControlStateNormal];
    [chat.titleLabel setHighlightedTextColor:[UIColor blackColor]];
    [chat.titleLabel setHighlighted:YES];
    [chat setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
    [chat addTarget:self action:@selector(talkAction) forControlEvents:UIControlEventTouchUpInside];
    [chat.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [chat.titleLabel setTextColor:[UIColor blackColor]];
    [header addSubview:chat];
    
    //message
    UIButton *messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame=CGRectMake(45, 35, 110, 20);
    [messageBtn setTitle:@"添加评论" forState:UIControlStateNormal];
    [messageBtn.titleLabel setHighlightedTextColor:[UIColor blackColor]];
    [messageBtn.titleLabel setHighlighted:YES];
    [messageBtn setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [messageBtn.titleLabel setTextColor:[UIColor blackColor]];
    [header addSubview:messageBtn];
    
    //***weiboview***
    GZCustomTextView *tv1 = [[GZCustomTextView alloc]initWithFrame:CGRectMake(0, 55, 320, 0)];
    GZCustomTextView *tv2 = [[GZCustomTextView alloc]initWithFrame:CGRectMake(10, 0, 300, 0)];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    tv2.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [header addSubview:tv1];
    tv1.subTV = tv2;
    [tv1 addSubview:tv2];
    tv1.editable = NO;
    tv2.editable = NO;
    
    tv1.text = self.weibo.text;
    tv1.subTV.text = self.weibo.relWeibo.text;
    GZWeibo *relWeibo = self.weibo.relWeibo;
    if (relWeibo != Nil) {
        tv1.subTV.hidden = NO;
        NSMutableString *text = [NSMutableString string];
        NSString *nickName = self.weibo.relWeibo.user.name;
        [text appendString:nickName];
        [text appendString:@":"];
        NSString *sourceWeiboText = self.weibo.relWeibo.text;
        sourceWeiboText = sourceWeiboText;
        [text appendString:sourceWeiboText];
        tv1.subTV.text = text;
        
        NSString *thumbnailImage = self.weibo.relWeibo.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            NSURL *url = [NSURL URLWithString:thumbnailImage];
            [iv setImageWithURL:url];
            [tv1.subTV addSubview:iv];
        }
        
    }else{
        tv1.subTV.hidden = YES;
        tv1.subTV.text = @"";
        
        NSString *thumbnailImage = self.weibo.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            NSURL *url = [NSURL URLWithString:thumbnailImage];
            [iv setImageWithURL:url];
            [tv1 addSubview:iv];
        }
    }
    
    CGRect frame = header.frame;
    frame.size.height = [tv1 getHeight]+55;
    header.frame = frame;
    self.tableView.tableHeaderView = header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    self.commentCell.comment = self.comments[indexPath.row];
    float cellHeight = [self.commentCell getHeight];
    NSLog(@"cellHeight = %f", cellHeight);
    return cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.comment = self.comments[indexPath.row];
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
