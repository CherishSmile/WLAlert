//
//  WLShareCell.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLShareCell.h"
#import "Masonry.h"

@interface WLShareCell ()
{
    UIImageView *shareImageView;
    UILabel *shareLbl;
    UILabel *vLineLbl;
    UILabel *hLineLbl;
}
@end

@implementation WLShareCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self showUI];
    }
    return self;
}
-(void)showUI{
    shareImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:shareImageView];
    
    shareLbl=[[UILabel alloc] init];
    shareLbl.font=[UIFont systemFontOfSize:12];
    shareLbl.textColor=[UIColor blackColor];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:shareLbl];
    
    vLineLbl=[[UILabel alloc] init];
    vLineLbl.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:vLineLbl];
    vLineLbl.backgroundColor=[UIColor grayColor];
    
    hLineLbl=[[UILabel alloc] init];
    hLineLbl.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:hLineLbl];
    hLineLbl.backgroundColor=[UIColor grayColor];
}
-(void)layoutSubviews
{
    CGFloat padding=10.f;
    
    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(shareImageView.image.size);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(0);
    }];
    [shareLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@21);
        make.top.equalTo(shareImageView.mas_bottom).offset(padding*0.5);
    }];
    [vLineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
    [hLineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(-2);
    }];
}

-(void)showDateWithArr:(NSArray *)shareArr indexPath:(NSIndexPath *)index{
    shareImageView.image=[UIImage imageNamed:[shareArr[index.row] firstObject]];
    shareLbl.text=[shareArr[index.row] lastObject];
    if (index.row%3==2) {
        vLineLbl.hidden=YES;
    }else{
        vLineLbl.hidden=NO;
    }
    
    if (index.row>2) {
        hLineLbl.hidden=YES;
    }else{
        hLineLbl.hidden=NO;
    }
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}


@end
