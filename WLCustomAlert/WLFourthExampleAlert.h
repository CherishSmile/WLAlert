//
//  WLFourthExampleAlert.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IsInsBlock)(BOOL isInstall,NSInteger m);

@interface WLFourthExampleAlert : UIView
@property(nonatomic ,strong )NSArray * platmsAry;
@property(nonatomic, copy) IsInsBlock insBlock;
-(instancetype)initWithFrame:(CGRect)frame thePlatms:(NSArray *)platmsAry;

@end
