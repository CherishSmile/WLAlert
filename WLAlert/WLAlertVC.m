//
//  WLAlertVC.m
//  WLAlertView
//
//  Created by MWLwx on 16/3/15.
//  Copyright © 2016年 MWLwx. All rights reserved.
//

#import "WLAlertVC.h"
#import "WLAlertView.h"
#import "UIWindow+WLUitily.h"

@implementation WLAlertVC

-(void)loadView
{
    [super loadView];
    self.view = self.alertView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#ifdef __IPHONE_7_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
#elif __IPHONE_8_0
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
#endif

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}

#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *window = self.alertView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    return [[window viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *window = self.alertView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    return [[window viewControllerForStatusBarHidden] prefersStatusBarHidden];
}
#endif

@end
