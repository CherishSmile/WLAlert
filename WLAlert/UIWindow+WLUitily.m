//
//  UIWindow+WLUitily.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "UIWindow+WLUitily.h"

@implementation UIWindow (WLUitily)
-(UIViewController *)currentViewController
{
    UIViewController * viewController = self.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

@end
