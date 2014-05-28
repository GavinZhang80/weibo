//
//  GZIMCellTextView.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-28.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZIMCellTextView.h"


#define messWidth 250

@interface GZIMCellTextView()
@property(strong,nonatomic) UITextView *tv;
@end

@implementation GZIMCellTextView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //initializations
        [self initUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.tv = [[UITextView alloc]initWithFrame:self.bounds];
    self.tv.backgroundColor = [UIColor clearColor];
    self.tv.editable = NO;
    self.tv.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.tv];
}
-(void)setImage:(UIImage *)image{
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    [super setImage:image];
}
-(void)setText:(NSString *)text{
    _text = text;
    self.tv.text  = self.text;
    CGSize size   = [self.tv sizeThatFits:CGSizeMake(messWidth-2, 0)];
    self.frame   = CGRectMake(0, 0, size.width, size.height);
    self.tv.frame = CGRectMake(0, 0, size.width, size.height);
}
-(float)getHeight{
    self.tv.text = self.text;
    CGSize size  = [self.tv sizeThatFits:CGSizeMake(messWidth-2, 0)];
    return size.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
