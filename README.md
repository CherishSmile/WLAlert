# WLAlertView
自定制弹出警告框，多种动画弹出样式

如果不想用系统的alert，自定制自己喜欢的alert，但又想有自然的动画效果，WLAlertView是个不错的选择；
1.把WLAlert文件拖进你的工程
2.继承于UIView，自定制alert的UI
3.在要显示的VC里，创建你的alert，并设置相关属性就可以达到你所需的效果

例如：
 WLFirstExampleAlert * alert = [WLFirstExampleAlert showAlertWithTitle:@"操作" otherTitles:@[@"复制",@"粘贴",@"转发"] completion:^(NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    //
                }
            }];  //自定制的alert
WLAlertView * alertView = [[WLAlertView alloc]init];
alertView.containerView = alert;
alertView.transitionStyle=WLAlertViewTransitionStyleFade;//设置alert的出现动画
[alertView show];

详细见demo里四种不同定制的alert的例子

