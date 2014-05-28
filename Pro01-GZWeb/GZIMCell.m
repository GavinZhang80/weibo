//
//  GZIMCell.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-27.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZIMCell.h"
#import "UIImageView+WebCache.h"
#import "GZIMCellTextView.h"

#define messBoundsWidth 250

@interface GZIMCell()
@property(strong,nonatomic) GZIMCellTextView *myTV;
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
    self.myTV = [[GZIMCellTextView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.myTV];
}



-(void)setMessage:(NSString *)message{
    _message = message;
    
    self.myTV.text = self.message;
    
    CGRect frame = self.myTV.frame;
    if ([self.message hasPrefix:@"我说:"]) {
        self.myTV.image = [UIImage imageNamed:@"huihua2"];
        frame = CGRectMake(self.contentView.bounds.size.width - frame.size.width, 0, frame.size.width, frame.size.height);
        
    }else{
        self.myTV.image = [UIImage imageNamed:@"huihua1"];
        frame = CGRectMake(10, 0, frame.size.width, frame.size.height);
    }
    self.myTV.frame = frame;
}

-(float)getHeight{
    self.myTV.text = self.message;
    float cellHeight = [self.myTV getHeight];
    return cellHeight+10;
}

@end
