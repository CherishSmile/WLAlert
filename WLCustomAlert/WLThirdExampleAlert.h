//
//  WLThirdExampleAlert.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WLAlertBlock)(NSString * title);
@interface WLThirdExampleAlert : UIView
@property (nonatomic,copy) WLAlertBlock strBlcok;
@property (nonatomic,strong)UIColor * alertTitleColor;
@property (nonatomic,strong)UIFont * alertTitleFont;
-(instancetype)initWithTile:(NSString *)title cancleTitle:(NSString *)cancle otherTitle:(NSString *)other,...NS_REQUIRES_NIL_TERMINATION;
-(instancetype)initWithTile:(NSString *)title cancleTitle:(NSString *)cancle otherTitles:(NSArray *)others;
@end
