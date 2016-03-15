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

typedef NS_ENUM(NSInteger,WLAlertViewTransitionStyle) {
    WLAlertViewTransitionStyleSlideFromBottom = 0,
    WLAlertViewTransitionStyleSlideFromTop,
    WLAlertViewTransitionStyleFade,
    WLAlertViewTransitionStyleBounce,
    WLAlertViewTransitionStyleDropDown
};
@interface WLAlertView : UIView

@property (nonatomic, weak)   UIWindow *oldKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, assign) BOOL isTouchOtherUndissmiss;
@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, readonly, getter = isParallaxEffectEnabled) BOOL enabledParallaxEffect;
@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;
@property (nonatomic, copy) WLAlertViewHandler willShowHandler;
@property (nonatomic, copy) WLAlertViewHandler didShowHandler;
@property (nonatomic, copy) WLAlertViewHandler willDismissHandler;
@property (nonatomic, copy) WLAlertViewHandler didDismissHandler;
@property (nonatomic, assign) WLAlertViewTransitionStyle transitionStyle;

- (void)show;

- (void)dismissAnimated:(BOOL)animated;

@end
