//
//  WLFirstExampleAlert.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLFirstExampleAlert.h"
#import "WLAlertView.h"

#define SCR_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCR_WIDTH [UIScreen mainScreen].bounds.size.width
@interface WLFirstExampleAlert ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)UITableView *alertTab;
@property (nonatomic,copy) WLFirstExampleAlertViewCompletionBlock completion;

@end

@implementation WLFirstExampleAlert

-(id)initWithTitle:(NSString *)title
       otherTitles:(NSArray*)titles
        completion:(WLFirstExampleAlertViewCompletionBlock)completion{
    if (self=[super init]) {
        
        self.completion=completion;
        self.titleArr=[NSMutableArray arrayWithArray:titles];
        [self.titleArr insertObject:title atIndex:0];
        self.frame = CGRectMake(50, (SCR_HEIGHT-self.titleArr.count*30)/2, SCR_WIDTH-100, self.titleArr.count*30);
        [self addSubview:self.alertTab];
        
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"CellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (!indexPath.row) {
        cell.textLabel.textColor=[UIColor blueColor];
    }
    cell.textLabel.text=self.titleArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row){
        if (self.completion) {
            self.completion(indexPath.row);
        }
        if ([[self superview]isKindOfClass:[WLAlertView class]]) {
            WLAlertView * alerView =(WLAlertView *)[self superview];
            [alerView dismissAnimated:YES];
        }
    }
    
}

+(instancetype)showAlertWithTitle:(NSString *)title otherTitles:(NSArray *)titles completion:(WLFirstExampleAlertViewCompletionBlock)completion{
    WLFirstExampleAlert *alertView=[[self alloc] initWithTitle:title otherTitles:titles completion:completion];
    return alertView;
}

-(UITableView*)alertTab{
    
    _alertTab=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH-100, _titleArr.count*30) style:UITableViewStylePlain];
    _alertTab.backgroundColor=[UIColor whiteColor];
    _alertTab.layer.masksToBounds=YES;
    _alertTab.layer.cornerRadius=4.f;
    _alertTab.delegate=self;
    _alertTab.dataSource=self;
    _alertTab.bounces=NO;
    return _alertTab;
}



@end
