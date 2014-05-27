//
//  GZWeiboCell.m
//  Pro01-GZWeb
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZWeiboCell.h"
#import "UIImageView+WebCache.h"
//#import "GZDetailViewController.h"

@interface GZWeiboCell()
@property(strong,nonatomic) UIImageView *iv;
@end

@implementation GZWeiboCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //initializations
        [self initUI];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];

    }
    return self;
}


-(void)initUI{
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    GZCustomTextView *tv1 = [[GZCustomTextView alloc]initWithFrame:CGRectMake(59, 22, 260, 100)];
    self.tv = tv1;
    tv1.backgroundColor = [UIColor whiteColor];
    GZCustomTextView *subTV = [[GZCustomTextView alloc]initWithFrame:CGRectMake(5, 0, 250, 0)];
    subTV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:tv1];
    [subTV setHidden:YES];
    [tv1 addSubview:subTV];
    [tv1 setSubTV:subTV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction:)];
    
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(80, 0, 100, 80)];
    [self.iv setContentMode:UIViewContentModeScaleAspectFit];
    [self.iv addGestureRecognizer:tap];
    
    [tv1 setUserInteractionEnabled:YES];
    [subTV setUserInteractionEnabled:YES];
    [self.iv setUserInteractionEnabled:YES];
}

-(void)photoAction:(UITapGestureRecognizer*)tap{
    NSLog(@"tap");
    UIImageView *iv = (UIImageView*)tap.view;
    UIImageView *scaleIV = [[UIImageView alloc]initWithFrame:self.superview.bounds];
    scaleIV.image = iv.image;
    [self.superview addSubview:scaleIV];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction2:)];
    [scaleIV addGestureRecognizer:tap2];
}
-(void)photoAction2:(UITapGestureRecognizer*)tap2{
    NSLog(@"tap2");
    [tap2.view removeFromSuperview];
}
-(void)layoutSubviews{
    self.nick.text = self.weibo.user.name;
    self.tv.text = self.weibo.text;
    [self.iv removeFromSuperview];
    
    //判断当前视图是否为转发视图
    GZWeibo *relWeibo = self.weibo.relWeibo;
    if (relWeibo != Nil) {
        self.tv.subTV.hidden = NO;
        NSMutableString *text = [NSMutableString string];
        NSString *nickName = self.weibo.relWeibo.user.name;
        [text appendString:nickName];
        [text appendString:@":"];
        NSString *sourceWeiboText = self.weibo.relWeibo.text;
        sourceWeiboText = sourceWeiboText;
        [text appendString:sourceWeiboText];
        self.tv.subTV.text = text;
        
        NSString *thumbnailImage = self.weibo.relWeibo.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            NSURL *url = [NSURL URLWithString:thumbnailImage];
            [self.iv setImageWithURL:url];
            [self.tv.subTV addSubview:self.iv];
        }
        
        
    }else{
        self.tv.subTV.hidden = YES;
        self.tv.subTV.text = @"";
        
        NSString *thumbnailImage = self.weibo.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            NSURL *url = [NSURL URLWithString:thumbnailImage];
            [self.iv setImageWithURL:url];
            [self.tv addSubview:self.iv];
        }
        
        //NSURL *url = [NSURL URLWithString:self.weibo.user.iconURL];
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //dispatch_async(dispatch_get_main_queue(), ^{
//        self.icon.image = self.weibo.user.iconImage;
                //[self.icon setImageWithURL:url];
                //[self setNeedsLayout];
            //});
        //});
        
    }
    CGRect frame = self.createTime.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height-2;
    self.createTime.frame = frame;
    
    frame = self.source.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height-2;
    self.source.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
//    GZDetailViewController *iv = 
}
@end
