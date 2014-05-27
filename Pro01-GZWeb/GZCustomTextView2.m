//
//  GZCustomTextView.m
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "GZCustomTextView.h"
@interface GZCustomTextView()
@property(unsafe_unretained,nonatomic) CGSize maxSize;
@property(unsafe_unretained,nonatomic) CGSize minSize;
@end

@implementation GZCustomTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.minSize.height == 0 && self.minSize.width == 0) {
        self.minSize = self.superview.bounds.size;
        self.maxSize = CGSizeMake(self.minSize.width, self.minSize.height+100);
        [self setContentSize:self.minSize];
    }
}

-(void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    NSLog(@"contentSize.height = %f",contentSize.height);

    CGRect frame = CGRectZero;
    if (contentSize.height > self.maxSize.height){
        frame = self.frame;
        frame.size.height = self.maxSize.height;
        self.frame = frame;
    }else if (contentSize.height < self.minSize.height){
        frame = self.frame;
        frame.size.height = self.minSize.height;
        self.frame = frame;
    }else{
        frame = self.frame;
        frame.size.height = contentSize.height;
        self.frame = frame;
    }
    
    [self.delegateSzie didContentSizeChange:self andSize:self.bounds.size];
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
