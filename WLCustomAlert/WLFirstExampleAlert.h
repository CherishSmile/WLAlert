//
//  WLFirstExampleAlert.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WLFirstExampleAlertViewCompletionBlock)(NSInteger buttonIndex);

@interface WLFirstExampleAlert : UIView
+ (instancetype)showAlertWithTitle:(NSString *)title
                       otherTitles:(NSArray*)titles
                        completion:(WLFirstExampleAlertViewCompletionBlock)completion;
@end
