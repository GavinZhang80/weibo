//
//  GZCustomTextView.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZCustomTextView.h"
@interface GZCustomTextView()
@end

@implementation GZCustomTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
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
//    [self setScrollIndicatorInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self setContentInset:UIEdgeInsetsMake(10, 10, 10, 10)];    //设置UITextView的内边距
//    [self setTextAlignment:NSTextAlignmentLeft];    //并设置左对齐
//    self.userInteractionEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
//    self.selectable = YES;
//    self.editable = NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self getAllViewHeight:self];
}



//==========================================
//按自己拥有的图片和子视图数量大小,  计算自己的大小!
//==========================================
//公开方法
-(float)getHeight{
    return [self getAllViewHeight:self];
}
//私有方法
-(void)sortSubviews{
    [self getAllViewHeight:self];
}
//私有方法
-(float)getAllViewHeight:(GZCustomTextView*)tv{

    //****调整子视图位置****
    //没有文本的tv隐藏
    if (tv.text.length==0) {
        tv.hidden = YES;
        return 0;
    }

    //内容高度,-1是为了计算出来的高度尽量大一点,否则可能会出现文字显示不全的现象!!!
    float countHeight = [tv sizeThatFits:CGSizeMake(tv.bounds.size.width-2, FLT_MAX)].height;

    //是图片
    for (UIView *subview in tv.subviews) {
        if (subview.hidden) continue;
        if ([subview isMemberOfClass:[UIImageView class]] ){
            //排除滚动条
            if (!(subview.bounds.size.height <= 5 ||
                  subview.bounds.size.width <= 5)) {

                CGRect frameSubview = subview.frame;
                frameSubview.origin.y = countHeight;
                subview.frame = frameSubview;
                countHeight += subview.bounds.size.height+1;
            }
        }
    }

    //子tv
    for (UIView *subview in tv.subviews) {
        if (subview.hidden) continue;
        if ([subview isMemberOfClass:[GZCustomTextView class]] ){

            CGRect frameSubview = subview.frame;
            frameSubview.origin.y = countHeight;
            subview.frame = frameSubview;
            //递归
            countHeight += [tv getAllViewHeight:(GZCustomTextView*)subview];
        }
    }
    
    //根据子视图调整自己的大小
    CGRect frame = tv.frame;
    frame.size.height = countHeight;
    tv.frame = frame;

    return frame.size.height;
}


@end
