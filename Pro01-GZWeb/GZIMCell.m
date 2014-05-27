//
//  GZIMCell.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZIMCell.h"
#import "UIImageView+WebCache.h"


#define messBoundsWidth 250

@interface GZIMCell()
@property(strong,nonatomic) UIImageView *backIV;
@property(strong,nonatomic) UIImageView *iconIV;
@property(strong,nonatomic) UILabel *messLabel;
@end

@implementation GZIMCell
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)initUI{
    self.backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, messBoundsWidth, 20)];
    self.iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.messLabel = [[UILabel alloc]initWithFrame:self.backIV.bounds];
    [self.messLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.messLabel setNumberOfLines:0];
    [self.messLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.backIV];
    [self.backIV addSubview:self.messLabel];
    [self.backIV setImage:[UIImage imageNamed:@"huihua"]];
//    [self.backIV addSubview:self.iconIV];
}

-(void)layoutSubviews{
    self.messLabel.text = self.message;
    CGSize size = [self.messLabel sizeThatFits:CGSizeMake(messBoundsWidth-2,0)];
    self.messLabel.frame = CGRectMake(10, 10, size.width, size.height);
    if ([self.message hasPrefix:@"我说:"]) {
        [self.backIV setTransform:CGAffineTransformScale(self.transform,1,1)];
        [self.messLabel setTransform:CGAffineTransformScale(self.transform,1,1)];
        self.backIV.frame = CGRectMake(self.contentView.bounds.size.width - size.width-30, 0, size.width+20, size.height+20);
    }else{
        self.backIV.frame = CGRectMake(0, 0, size.width+20, size.height+20);
        [self.backIV setTransform:CGAffineTransformScale(self.transform,-1,1)];
        [self.messLabel setTransform:CGAffineTransformScale(self.transform,-1,1)];
    }
//    [self.iconIV setImage:self.user.iconImage];
}
-(float)getHeight{
    self.messLabel.text = self.message;
    CGSize size = [self.messLabel sizeThatFits:CGSizeMake(messBoundsWidth-2,0)];
    return size.height+20;
}

@end
