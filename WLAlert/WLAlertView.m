//
//  WLAlertView.m
//  WLAlertView
//
//  Created by MWLwx on 16/3/15.
//  Copyright © 2016年 MWLwx. All rights reserved.
//



#import "WLAlertView.h"
#import "WLAlertWindow.h"
#import "WLAlertVC.h"


const UIWindowLevel UIWindowLevelSIAlert = 1996.0;  // 不要和系统的leve了一样
const UIWindowLevel UIWindowLevelSIAlertBackground = 1985.0; // 在alert Window的下面

NSString *const WLAlertViewWillShowNotification = @"WLAlertViewWillShowNotification";
NSString *const WLAlertViewDidShowNotification = @"WLAlertViewDidShowNotification";
NSString *const WLAlertViewWillDismissNotification = @"WLAlertViewWillDismissNotification";
NSString *const WLAlertViewDidDismissNotification = @"WLAlertViewDidDismissNotification";

static NSMutableArray *__nt_alert_queue;
static BOOL __nt_alert_animating;
static WLAlertWindow *__nt_alert_background_window;
static WLAlertView *__nt_alert_current_view;

@interface WLAlertView()

+ (NSMutableArray *)sharedQueue;
+ (WLAlertView *)currentAlertView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;
@end
@implementation WLAlertView
#pragma mark - Class methods
+ (NSMutableArray *)sharedQueue
{
    if (!__nt_alert_queue) {
        __nt_alert_queue = [NSMutableArray array];
    }
    return __nt_alert_queue;
}
+ (WLAlertView *)currentAlertView
{
    return __nt_alert_current_view;
}
+ (void)setCurrentAlertView:(WLAlertView *)alertView
{
    __nt_alert_current_view = alertView;
}
+ (BOOL)isAnimating
{
    return __nt_alert_animating;
}

+ (void)setAnimating:(BOOL)animating
{
    __nt_alert_animating = animating;
}
+ (void)showBackground
{
    if (!__nt_alert_background_window) {
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)])
        {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        
        __nt_alert_background_window = [[WLAlertWindow alloc] initWithFrame:frame];
        [__nt_alert_background_window makeKeyAndVisible];
        __nt_alert_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __nt_alert_background_window.alpha = 1;
                         }];
    }
}
+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [__nt_alert_background_window removeFromSuperview];
        __nt_alert_background_window = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         __nt_alert_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__nt_alert_background_window removeFromSuperview];
                         __nt_alert_background_window = nil;
                     }];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch * touch in touches)
    {
        if (![touch.view isMemberOfClass:[UIView class]]) {
            if (!self.isTouchOtherUndissmiss) {
                [self dismissAnimated:YES];
            }
        };
    }
    
}

-(void)setContainerView:(UIView *)containerView
{
    if (_containerView) {
        [_containerView removeFromSuperview];
        _containerView = nil;
    }
    if (_containerView!=containerView) {
        _containerView = containerView;
        [self addSubview:_containerView];
        [self bringSubviewToFront:_containerView];
    }
}
- (void)teardown
{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    self.layoutDirty = NO;
}
#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case WLAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = (id)self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
        }
            break;
        case WLAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = (id)self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case WLAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case WLAlertViewTransitionStyleBounce:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            
        }
            break;
        case WLAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}


- (void)show
{
    if (self.isVisible) {
        return;
    }
    
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if ([WLAlertView sharedQueue].count) {
        return;
    }
    if (![[WLAlertView sharedQueue] containsObject:self]) {
        [[WLAlertView sharedQueue] addObject:self];
    }
    
    if ([WLAlertView isAnimating]) {
        return; // wait for next turn
    }
    
    if ([WLAlertView currentAlertView].isVisible) {
        WLAlertView *alert = [WLAlertView currentAlertView];
        [alert dismissAnimated:YES cleanup:NO];
        return;
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WLAlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    
    [WLAlertView setAnimating:YES];
    [WLAlertView setCurrentAlertView:self];
    
    // transition background
    [WLAlertView showBackground];
    
    WLAlertVC *viewController = [[WLAlertVC alloc] init];
    viewController.alertView = self;
    
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelSIAlert;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    //    [self validateLayout];
    
    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WLAlertViewDidShowNotification object:self userInfo:nil];
        
        [WLAlertView setAnimating:NO];
        
        NSInteger index = [[WLAlertView sharedQueue] indexOfObject:self];
        if (index < [WLAlertView sharedQueue].count - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WLAlertViewWillDismissNotification object:self userInfo:nil];
    }
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [WLAlertView setCurrentAlertView:nil];
        
        WLAlertView *nextAlertView;
        NSInteger index = [[WLAlertView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [WLAlertView sharedQueue].count - 1) {
            nextAlertView = [WLAlertView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[WLAlertView sharedQueue] removeObject:self];
        }
        
        [WLAlertView setAnimating:NO];
        
        if (isVisible) {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:WLAlertViewDidDismissNotification object:self userInfo:nil];
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextAlertView) {
            [nextAlertView show];
        } else {
            // show last alert view
            if ([WLAlertView sharedQueue].count > 0) {
                WLAlertView *alert = [[WLAlertView sharedQueue] lastObject];
                [alert show];
            }
        }
    };
    
    if (animated && isVisible) {
        [WLAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([WLAlertView sharedQueue].count == 1) {
            [WLAlertView hideBackgroundAnimated:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([WLAlertView sharedQueue].count == 0) {
            [WLAlertView hideBackgroundAnimated:YES];
        }
    }
    
    UIWindow *window = self.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
