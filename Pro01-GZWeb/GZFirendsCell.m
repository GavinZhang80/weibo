//
//  GZFirendsCell.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZFirendsCell.h"
#import "GZIMViewController.h"
@interface GZFirendsCell()
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;

@end
@implementation GZFirendsCell
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)sendSession:(UIButton *)sender {
    NSLog(@"发起会话");
    GZIMViewController *iv = [((UIViewController*)self.delegate).storyboard instantiateViewControllerWithIdentifier:@"IMVC"];
    iv.user = self.userInfo;
    [((UIViewController*)self.delegate).navigationController pushViewController:iv animated:YES];
}

-(void)layoutSubviews{
    self.sendBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.cornerRadius = 5;
    
    self.name1.text = self.userInfo.name;
    self.name2.text = self.userInfo.name2;
    self.icon.image = self.userInfo.iconImage;
}

@end
