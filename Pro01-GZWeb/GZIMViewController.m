//
//  GZIMViewController.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZIMViewController.h"
#import "GZIMCell.h"

@interface GZIMViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (weak, nonatomic) IBOutlet UITextView *messTF;
@property (weak, nonatomic) IBOutlet UIButton *sendMessBtn;
@property(strong,nonatomic) GZIMCell *imCell;
@property(strong,nonatomic) NSMutableArray *messages;
@end

@implementation GZIMViewController

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
	// Do any additional setup after loading the view.
    [self initUI];
    
}
-(void)initUI{
    
    self.title = self.user.name;
    self.imCell = [[GZIMCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    self.messages = [NSMutableArray array];
    
    //hidden tablebar
    [self setHidesBottomBarWhenPushed:YES];
    //tableview设置
    CGRect  frame = self.view.bounds;
    frame.size.height -= self.inputBackView.bounds.size.height;
    self.tableView.frame = frame;
    
    //发送窗口设置
    frame = self.inputBackView.frame;
    frame.origin.y = self.view.frame.origin.y+self.view.bounds.size.height-frame.size.height;
    self.inputBackView.frame = frame;
    self.inputBackView.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputBackView.layer.borderWidth = .3;
    
    //messTF
    self.messTF.layer.borderColor = [UIColor grayColor].CGColor;
    self.messTF.layer.borderWidth = .3;
    
    //sendMessBtn
    self.sendMessBtn.layer.cornerRadius = 3;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeKeyboardFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
-(void)didChangeKeyboardFrame:(NSNotification*)ntf{
    [UIView animateWithDuration:.01 animations:^{
        //从通知中得到字典 从字典中得到键盘的高度
        CGRect keyboardFrame=[[ntf.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        //tableview设置
        CGRect  frame = self.tableView.frame;
        frame.size.height = keyboardFrame.origin.y - frame.origin.y - self.inputBackView.bounds.size.height;
        self.tableView.frame = frame;
        
        //发送窗口设置
        frame = self.inputBackView.frame;
        frame.origin.y = keyboardFrame.origin.y - frame.size.height;
        self.inputBackView.frame = frame;
    }];
}
- (IBAction)micActionBtn:(UIButton *)sender {
    NSLog(@"mic");
}
- (IBAction)picActionBtn:(UIButton *)sender {
    NSLog(@"pic");
}
- (IBAction)sendMessActionBtn:(UIButton *)sender {
    NSLog(@"sendMess userName = %@",self.user.name2);
    [[XMPPManager shareManager] sendMessage:self.messTF.text toUser:self.user.name2];
    NSString *msg = [@"我说: " stringByAppendingString:self.messTF.text];
    [self.messages addObject:msg];
    //[self.messTF resignFirstResponder];
    [self.tableView reloadData];
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height-50) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.bounds.size.height) animated:NO];
    }
}

//收到消息
-(void)XMPPManager:(XMPPManager*)sender didReceiveMessage:(XMPPMessage*)message{
    NSLog(@"receiveMess");
    NSString *msg = [NSString stringWithFormat:@"%@说: %@",[[message from] user],[message body]];
    NSLog(@"msg = %@", msg);
    [self.messages addObject:msg];
    [self.tableView reloadData];
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height-50) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.bounds.size.height) animated:NO];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"didEndEdit");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.imCell.message = self.messages[indexPath.row];
    float height = [self.imCell getHeight];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GZIMCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.message = self.messages[indexPath.row];
    cell.user = self.user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.messTF resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [XMPPManager shareManager].delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [XMPPManager shareManager].delegate = Nil;
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
