//
//  GZCustomTextView.h
//  Pro01-GZWeibo
//
//  Created by tarena on 14-5-19.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCustomTextView;
@protocol GZCustomeTextViewDelegat <NSObject>
-(void)didContentSizeChange:(GZCustomTextView*)textView andSize:(CGSize)sizeOfTV;
@end


@interface GZCustomTextView : UITextView
@property(weak,nonatomic) id<GZCustomeTextViewDelegat>delegateSzie;
@property (strong, nonatomic) NSIndexPath *indexP;
@property (strong, nonatomic) GZCustomTextView *subTV;

-(float)getHeight;
@end
