//
//  WLShareCell.h
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLShareCell : UICollectionViewCell
@property (nonatomic ,assign)BOOL hasApp;
-(void)showDateWithArr:(NSArray*)shareArr indexPath:(NSIndexPath*)index;

@end
