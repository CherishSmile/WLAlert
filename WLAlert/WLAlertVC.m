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

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

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

@end
