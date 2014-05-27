//
//  Comment.m
//  Day10WeiboDemo
//
//  Created by apple on 13-11-27.
//  Copyright (c) 2013年 tarena. All rights reserved.
//

#import "Comment.h"
//#import "RTLabel.h"

@implementation Comment
-(float)getCommentHight{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 0)];
    label.text = self.text;
    return [label sizeThatFits:CGSizeMake(240, FLT_MAX)].height;
}
@end
