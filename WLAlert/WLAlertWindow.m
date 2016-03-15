//
//  WLAlertWindow.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLAlertWindow.h"

@implementation WLAlertWindow
-(instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}
@end
