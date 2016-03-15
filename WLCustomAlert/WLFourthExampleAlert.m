//
//  WLFourthExampleAlert.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLFourthExampleAlert.h"
#import "WLShareCell.h"
#import "WLAlertView.h"

#define SCR_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCR_WIDTH [UIScreen mainScreen].bounds.size.width

#define k_btn_count 3
#define k_btn_intevel 2
#define K_btn_tag 501
#define k_cell_width (SCR_WIDTH-3*k_btn_intevel)/k_btn_count
#define k_cell_hight (SCR_WIDTH-3*k_btn_intevel)/k_btn_count*(8/9.0)


@interface WLFourthExampleAlert ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *shareCollectionView;
}
@end

@implementation WLFourthExampleAlert
-(instancetype)initWithFrame:(CGRect)frame thePlatms:(NSArray *)platmsAry
{
    
    if (self =  [super initWithFrame:frame]) {
        _platmsAry = platmsAry;
        NSInteger lines = _platmsAry.count/k_btn_count+(_platmsAry.count%k_btn_count?1:0);
        self.frame=CGRectMake(0, SCR_HEIGHT-lines*(k_cell_hight),SCR_WIDTH, lines*(k_cell_hight));
        [self creatShareUI];
    }
    return self;
}
-(void)setPlatmsAry:(NSArray *)platmsAry
{
    if (![_platmsAry isEqual:platmsAry]) {
        _platmsAry = platmsAry;
        [shareCollectionView reloadData];
    }
}
-(void)creatShareUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(k_cell_width, k_cell_hight);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(1, 1,1, 1);
    shareCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    shareCollectionView.backgroundColor=[UIColor whiteColor];
    shareCollectionView.dataSource = self;
    shareCollectionView.delegate = self;
    shareCollectionView.bounces=NO;
    shareCollectionView.showsVerticalScrollIndicator=NO;
    [shareCollectionView registerClass:[WLShareCell class] forCellWithReuseIdentifier:@"WLShareCellId"];
    [self addSubview:shareCollectionView];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _platmsAry.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLShareCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"WLShareCellId" forIndexPath:indexPath] ;
    [cell showDateWithArr:_platmsAry indexPath:indexPath];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_insBlock) {
        _insBlock(YES,indexPath.row);
    }
    if ([[self superview]isKindOfClass:[WLAlertView class]]) {
        WLAlertView * alerView =(WLAlertView *)[self superview];
        [alerView dismissAnimated:YES];
    }
    
}

@end
