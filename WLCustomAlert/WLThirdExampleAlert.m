//
//  WLThirdExampleAlert.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLThirdExampleAlert.h"
#import "WLAlertView.h"
#define SCR_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCR_WIDTH [UIScreen mainScreen].bounds.size.width
@interface UIAlertCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelbl;
-(void)configWithName:(NSString *)name;
@end

@implementation UIAlertCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatInit];
    }
    return self;
}
-(void)creatInit{
//    [self setSelectedBackgroundView:[[UIImageView alloc] initWithImage:createImg(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), [UIColor lightGrayColor])]];
    
    _titlelbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, CGRectGetHeight(self.frame))];
    _titlelbl.textAlignment = NSTextAlignmentCenter;
    _titlelbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titlelbl];
}
-(void)configWithName:(NSString *)name{
    _titlelbl.text = name;
}

-(void)configWithNameColorGry:(NSString *)name{
    _titlelbl.textColor = [UIColor grayColor];
    _titlelbl.font=[UIFont systemFontOfSize:15];
    _titlelbl.text = name;
}

@end


@interface WLThirdExampleAlert ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * alertTab;
    NSString * titleStr;
    NSMutableArray * otherArr;
    NSString * cancleStr;
    NSMutableArray * alertArr;
}
@end

@implementation WLThirdExampleAlert

-(instancetype)initWithTile:(NSString *)title cancleTitle:(NSString *)cancle otherTitle:(NSString *)other, ...{
    if (self = [super init]) {
        titleStr = title;
        cancleStr = cancle;
    }
    otherArr = [NSMutableArray array];
    if (other) {
        [otherArr addObject:other];
        va_list argList;
        va_start(argList, other);
        id arg;
        while ((arg = va_arg(argList, id)))
        {
            [otherArr addObject:arg];
        }
        va_end(argList);
        [self Init];
    }
    return self;
}
-(instancetype)initWithTile:(NSString *)title cancleTitle:(NSString *)cancle otherTitles:(NSArray *)others{
    if (self = [super init]) {
        titleStr = title;
        cancleStr = cancle;
        otherArr=[others mutableCopy];
        [self Init];
    }
    return self;
}
-(void)Init{
    self.frame = [[UIScreen mainScreen] bounds];
    [self creatAlertArr];
    [self creatAlertTab];
}

-(void)creatAlertArr{
    alertArr = [NSMutableArray array];
    if (titleStr.length) {
        [alertArr addObject:@[titleStr]];
    }
    if (otherArr.count) {
        for (NSString * str in otherArr) {
            [alertArr addObject:@[str]];
        }
    }
    if (cancleStr.length) {
        [alertArr addObject:@[cancleStr]];
    }
    
}

-(void)creatAlertTab{
    NSInteger num = 0;
    for (NSInteger i = 0; i < alertArr.count; i++) {
        for (NSInteger j = 0; j < [alertArr[i] count]; j++) {
            num++;
        }
    }
    alertTab = [[UITableView alloc]initWithFrame:CGRectMake(0, SCR_HEIGHT-num*49.f-5.f, SCR_WIDTH, num*49.f+5.f) style:UITableViewStylePlain];
    [alertTab registerClass:[UIAlertCell class] forCellReuseIdentifier:@"UIAlertCell"];
    alertTab.dataSource = self;
    alertTab.delegate = self;
    alertTab.bounces=NO;
    [self addSubview:alertTab];
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (section == alertArr.count-2) {
        view.tintColor = [UIColor grayColor];
    }else{
        view.tintColor=[UIColor lightGrayColor];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == alertArr.count-2) {
        return 5.f;
    }
    if (section == alertArr.count-1) {
        return 0.1f;
    }
    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return alertArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alertArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UIAlertCell" forIndexPath:indexPath];
    if ([alertArr[indexPath.section][indexPath.row] isEqualToString:titleStr]&&titleStr.length) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithNameColorGry:alertArr[indexPath.section][indexPath.row]];
    }else{
        if (![alertArr[indexPath.section][indexPath.row] isEqualToString:cancleStr]) {
            cell.titlelbl.textColor=self.alertTitleColor;
            cell.titlelbl.font=self.alertTitleFont;
        }
        [cell configWithName:alertArr[indexPath.section][indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![alertArr[indexPath.section][indexPath.row] isEqualToString:titleStr]&&![alertArr[indexPath.section][indexPath.row] isEqualToString:cancleStr]){
        if (self.strBlcok){
            self.strBlcok(alertArr[indexPath.section][indexPath.row]);
        }
    }
    if (!([alertArr[indexPath.section][indexPath.row] isEqualToString:titleStr]&&titleStr.length)) {
        if ([[self superview]isKindOfClass:[WLAlertView class]]) {
            WLAlertView * alerView =(WLAlertView *)[self superview];
            [alerView dismissAnimated:YES];
        }
    }
}


@end
