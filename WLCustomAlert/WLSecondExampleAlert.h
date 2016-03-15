//
//  WLSecondExampleAlert.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WLCAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

@interface WLSecondExampleAlert : UIView

@property (nonatomic,assign) CGFloat alertCornerRadius;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *messageColor;
@property (nonatomic,strong) UIColor *cancleTitleColor;
@property (nonatomic,strong) UIColor *otherTitleColor;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(WLCAlertViewCompletionBlock)completion;
-(void)setAlertTitleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont;
-(void)setAlertMessageColor:(UIColor*)messageColor messageFont:(UIFont*)messageFont;
-(void)setAlertCancleTitleColor:(UIColor*)cancleTitleColor cancleTitleFont:(UIFont*)cancleTitleFont;
-(void)setAlertOtherTitleColor:(UIColor*)otherTitleColor otherTitleFont:(UIFont*)otherTitleFont;

@end
