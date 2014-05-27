//
//  GZCommentCell.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-26.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZWeibo.h"
#import "Comment.h"

@interface GZCommentCell : UITableViewCell

@property (nonatomic,strong)Comment *comment;
-(float)getHeight;
@end
