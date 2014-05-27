//
//  GZAddTopicViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZAddTopicViewController.h"
#import "GZMyWeiboApi.h"

@interface GZAddTopicViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentLocation;
@property (weak, nonatomic) IBOutlet UITableViewCell *addTopicContent;
@property (weak, nonatomic) IBOutlet GZCustomTextView *addTopicTF;
@property (unsafe_unretained,nonatomic) int rowHeight;

@property (weak, nonatomic) IBOutlet UIImageView *MyIconIV;

@property (strong, nonatomic) UIImagePickerController *ipc;

@end

@implementation GZAddTopicViewController

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendWeiboAction)];
    
    self.addTopicTF.delegateSzie = self;
}



//发送Weibo
-(void)sendWeiboAction{
    NSLog(@"sendWeiboAction...");
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   self.addTopicTF.text, @"content",
                                   self.MyIconIV.image, @"pic",
                                   nil];
    [[GZMyWeiboApi shareWeiboApi] requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    [self.addTopicTF resignFirstResponder];
}


//添加图片
- (IBAction)addPhotoBtnAction:(UIButton *)sender {
    self.ipc = [[UIImagePickerController alloc]init];
    self.ipc.delegate = self;
    self.ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.ipc animated:YES completion:Nil];
}


//图片获取
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"NSDictionary= %@",info);
    self.MyIconIV.image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    [self.ipc dismissViewControllerAnimated:YES completion:nil];
}


//单元格自动调整高度
-(void)didContentSizeChange:(GZCustomTextView *)textView andSize:(CGSize)sizeOfTV{
    self.rowHeight = sizeOfTV.height;
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    NSLog(@"sizeOfTV.height = %f",sizeOfTV.height);
}


-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    //登录情况检测
    [[GZMyWeiboApi shareMyWeiboApi] checkAuthValidWithRootController:self andCallback:^(id obj) {
        NSLog(@"GZAddTopicViewController obj = %d",[obj boolValue]);
    }];
}




//#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if (self.rowHeight > 180) {
            return 180;
        }else if (self.rowHeight > 85){
            return self.rowHeight;
        }else{
            return 85;
        }
    }
    return 85;
}


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
