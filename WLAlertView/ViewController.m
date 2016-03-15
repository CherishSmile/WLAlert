//
//  ViewController.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "ViewController.h"

#import "WLAlertView.h"
#import "WLFirstExampleAlert.h"
#import "WLSecondExampleAlert.h"
#import "WLThirdExampleAlert.h"
#import "WLFourthExampleAlert.h"

#define SCR_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCR_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UITableView *exampleTab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataArr=@[@"AlertExample1",@"AlertExample2",@"AlertExample3",@"AlertExample4"];
    [self.view addSubview:self.exampleTab];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text=self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            WLFirstExampleAlert * alert = [WLFirstExampleAlert showAlertWithTitle:@"操作" otherTitles:@[@"复制",@"粘贴",@"转发"] completion:^(NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    //
                }
            }];
            WLAlertView * alertView = [[WLAlertView alloc]init];
            alertView.containerView = alert;
            alertView.transitionStyle=WLAlertViewTransitionStyleFade;
            [alertView show];

        }
        break;
        case 1:
        {
            WLSecondExampleAlert * alert = [WLSecondExampleAlert showAlertWithTitle:@"⚠️" message:@"你确定要重发此条消息？" cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex) {
                    
                }
            }];
            [alert setAlertTitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14]];
            [alert setAlertMessageColor:[UIColor redColor] messageFont:[UIFont systemFontOfSize:13]];
            [alert setAlertCancleTitleColor:[UIColor lightGrayColor] cancleTitleFont:[UIFont systemFontOfSize:16]];
            [alert setOtherTitleColor:[UIColor redColor]];
            alert.center=self.view.center;
            WLAlertView * alertView = [[WLAlertView alloc]init];
            alertView.containerView = alert;
            alertView.transitionStyle=WLAlertViewTransitionStyleFade;
            [alertView show];

        }
        break;
        case 2:
        {
            WLThirdExampleAlert * alert = [[WLThirdExampleAlert alloc]initWithTile:nil cancleTitle:@"取消" otherTitle:@"拍照",@"相册选择", nil];
            alert.strBlcok = ^(NSString * title){
                
            };
            WLAlertView * alertView = [[WLAlertView alloc]init];
            alertView.containerView = alert;
            alertView.transitionStyle=WLAlertViewTransitionStyleSlideFromBottom;
            [alertView show];

        }
        break;
        case 3:
        {
            WLFourthExampleAlert * shareView =[[WLFourthExampleAlert alloc]initWithFrame:[[UIScreen mainScreen] bounds] thePlatms:@[@[@"UMS_qq_off",@"QQ"],@[@"UMS_renren_off",@"人人"],@[@"UMS_sina_off",@"新浪"],@[@"UMS_tencent_off",@"腾讯微博"],@[@"UMS_qzone_icon",@"QQ空间"]]];
            shareView.insBlock=^(BOOL isInstall,NSInteger m)
            {
                
            };
            WLAlertView * alertView = [[WLAlertView alloc]init];
            alertView.containerView = shareView;
            alertView.transitionStyle=WLAlertViewTransitionStyleSlideFromBottom;
            [alertView show];

        }
        break;
        default:
        break;
    }
}


-(UITableView*)exampleTab{
    if (!_exampleTab) {
        _exampleTab=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCR_WIDTH,SCR_HEIGHT-64 ) style:UITableViewStylePlain];
        _exampleTab.backgroundColor=[UIColor whiteColor];
        _exampleTab.delegate=self;
        _exampleTab.dataSource=self;
    }
    return _exampleTab;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
