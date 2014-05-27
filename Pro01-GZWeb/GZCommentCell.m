//
//  GZCommentCell.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-26.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZCommentCell.h"
#import "UIImageView+WebCache.m"


@interface GZCommentCell()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nickLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *commentLabel;
@end

@implementation GZCommentCell
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
    self.iconIV     = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
    self.nickLabel  = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 100, 20)];
    self.timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(210, 5, 100, 20)];
    self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 35, 255, 20)];
    
    [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.timeLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.commentLabel setNumberOfLines:0];
    [self.commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.commentLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentLabel];
}
-(void)layoutSubviews{
    [self.iconIV setImageWithURL:[NSURL URLWithString:self.comment.user.iconURL]];
    self.nickLabel.text = self.comment.user.name;
    self.timeLabel.text = self.comment.createdDate;
    self.commentLabel.text = self.comment.text;
    CGRect frame = self.commentLabel.frame;
    frame.size.height = [self.commentLabel sizeThatFits:CGSizeMake(self.commentLabel.bounds.size.width-2, 0)].height;
    self.commentLabel.frame = frame;
}
-(float)getHeight{
    self.commentLabel.text = self.comment.text;
    float commentLabelHeight = [self.commentLabel sizeThatFits:CGSizeMake(self.commentLabel.bounds.size.width-2, 0)].height;
    return commentLabelHeight + 45;
}
@end
