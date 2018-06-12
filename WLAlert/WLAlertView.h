//
//  WLAlertView.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//


#import <UIKit/UIKit.h>

@class WLAlertView;
typedef void(^WLAlertViewHandler)(WLAlertView *alertView);

/**
 alert弹出的动画样式
 
 - WLAlertViewTransitionStyleSlideFromBottom: 从底部弹出
 - WLAlertViewTransitionStyleSlideFromTop: 从顶部弹出
 - WLAlertViewTransitionStyleFade: 渐变出现
 - WLAlertViewTransitionStyleBounce: 弹性出现
 - WLAlertViewTransitionStyleDropDown: 水滴降落出现
 */
typedef NS_ENUM(NSInteger,WLAlertViewTransitionStyle) {
    WLAlertViewTransitionStyleSlideFromBottom = 0,
    WLAlertViewTransitionStyleSlideFromTop,
    WLAlertViewTransitionStyleFade,
    WLAlertViewTransitionStyleBounce,
    WLAlertViewTransitionStyleDropDown
};
@interface WLAlertView : UIView

/**
 原始window
 */
@property (nonatomic, weak)   UIWindow *oldKeyWindow;

/**
 alert所在的window
 */
@property (nonatomic, strong) UIWindow *alertWindow;

/**
 alertView
 */
@property (nonatomic, strong) UIView * containerView;

/**
 点击alert以外的区域是否不会消失（YES不会消失，NO会消失，默认为NO）
 */
@property (nonatomic, assign) BOOL isTouchOtherUndissmiss;

@property (nonatomic, assign, getter = isVisible) BOOL visible;

@property (nonatomic, readonly, getter = isParallaxEffectEnabled) BOOL enabledParallaxEffect;

@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

/**
 将要出现回调
 */
@property (nonatomic, copy) WLAlertViewHandler willShowHandler;

/**
 已经出现回调
 */
@property (nonatomic, copy) WLAlertViewHandler didShowHandler;

/**
 将要消失回调
 */
@property (nonatomic, copy) WLAlertViewHandler willDismissHandler;

/**
 已经消失回调
 */
@property (nonatomic, copy) WLAlertViewHandler didDismissHandler;

/**
 alert动画样式
 */
@property (nonatomic, assign) WLAlertViewTransitionStyle transitionStyle;

/**
 弹出alert
 */
- (void)show;

/**
 隐藏alert
 
 @param animated 是否带动画
 */
- (void)dismissAnimated:(BOOL)animated;


@end
