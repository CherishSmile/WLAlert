//
//  WLSecondExampleAlert.m
//  WLAlertView
//
//  Created by Mzywx on 16/3/15.
//  Copyright © 2016年 Mzywx. All rights reserved.
//

#import "WLSecondExampleAlert.h"

#import "WLAlertView.h"


static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 0.5;

@interface WLSecondExampleAlert ()

@property (nonatomic) UILabel  *titleLabel;
@property (nonatomic) UILabel  *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSArray  *buttons;
@property (nonatomic) CGFloat  buttonsY;
@property (nonatomic) CALayer  *verticalLine;
@property (nonatomic, copy) void (^completion)(BOOL cancelled, NSInteger buttonIndex);

@end

@implementation WLSecondExampleAlert

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
         otherTitle:(NSString *)otherTitle
         completion:(WLCAlertViewCompletionBlock)completion
{
    if (self=[super init]) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=4.f;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                    message&&message.length?AlertViewVerticalElementSpace:2*AlertViewVerticalElementSpace,
                                                                    AlertViewWidth - AlertViewContentMargin*2,
                                                                    44)];
        self.titleLabel.text = title;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        self.titleLabel.numberOfLines = 0;
        if (title&&title.length) {
            [self addSubview:self.titleLabel];
        }
        
        
        CGFloat messageLabelY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        self.messageLabel = [[UILabel alloc] initWithFrame:(CGRect){
            AlertViewContentMargin,
            messageLabelY,
            AlertViewWidth - AlertViewContentMargin*2,
            44}];
        self.messageLabel.text = message;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
        if (message&&message.length) {
            [self addSubview:self.messageLabel];
        }
        // Line
        CALayer *lineLayer = [self lineLayer];
        //title不存在，message存在
        if (!(title&&title.length)&&(message&&message.length)) {
            lineLayer.frame = CGRectMake(0, self.messageLabel.frame.origin.y+AlertViewVerticalElementSpace + self.messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, AlertViewLineLayerWidth);
        }
        //title存在，message不存在
        if ((title&&title.length)&&!(message&&message.length)) {
            lineLayer.frame = CGRectMake(0, self.titleLabel.frame.origin.y+AlertViewVerticalElementSpace + self.titleLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, AlertViewLineLayerWidth);
        }
        //title和message都不存在
        if (!(title&&title.length)&&!(message&&message.length)) {
            lineLayer.frame = CGRectMake(0, 0, 0, 0);
        }
        //title和message都存在
        if ((title&&title.length)&&(message&&message.length)) {
            lineLayer.frame = CGRectMake(0, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, AlertViewLineLayerWidth);
        }
        [self.layer addSublayer:lineLayer];
        
        self.buttonsY = lineLayer.frame.origin.y + lineLayer.frame.size.height;
        
        if(cancelTitle)
        {
            [self addButtonWithTitle:cancelTitle];
        }
        if (otherTitle)
        {
            [self addButtonWithTitle:otherTitle];
        }
        self.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        
        if (completion) {
            self.completion = completion;
        }
        [self resizeViewsWithTitle:title message:message];
        
    }
    return self;
}
/**
 *  alert的frame
 */
- (void)resizeViewsWithTitle:(NSString*)title message:(NSString*)message
{
    CGFloat totalHeight = 0;
    for (UIView *view in [self subviews]) {
        if ([view class] != [UIButton class]) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    if (self.buttons) {
        NSUInteger otherButtonsCount = [self.buttons count];
        totalHeight += AlertViewButtonHeight * (otherButtonsCount > 2 ? otherButtonsCount : 1);
    }
    //title存在，message不存在或者message存在，title不存在
    if ((!(title&&title.length)&&(message&&message.length))||((title&&title.length)&&!(message&&message.length))) {
        totalHeight += 3*AlertViewVerticalElementSpace;
    }
    //title和message都存在
    if ((title&&title.length)&&(message&&message.length)) {
        totalHeight += AlertViewVerticalElementSpace;
    }
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            totalHeight);
}
/**
 *  添加按钮
 */
- (NSInteger)addButtonWithTitle:(NSString *)title
{
    UIButton *button = [self genericButton];
    [button setTitle:title forState:UIControlStateNormal];
    
    if (!self.cancelButton) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.cancelButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
    } else if (self.buttons && [self.buttons count] > 1) {
        UIButton *lastButton = (UIButton *)[self.buttons lastObject];
        lastButton.titleLabel.font = [UIFont systemFontOfSize:17];
        if ([self.buttons count] == 2) {
            [self.verticalLine removeFromSuperlayer];
            CALayer *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewLineLayerWidth);
            [self.layer addSublayer:lineLayer];
            lastButton.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewButtonHeight);
            self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
        }
        CGFloat lastButtonYOffset = lastButton.frame.origin.y + AlertViewButtonHeight;
        button.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewButtonHeight);
    } else {
        self.verticalLine = [self lineLayer];
        self.verticalLine.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewLineLayerWidth, AlertViewButtonHeight);
        [self.layer addSublayer:self.verticalLine];
        button.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.otherButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [self addSubview:button];
    self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button] : @[ button ];
    return [self.buttons count] - 1;
}
/**
 *  设置按钮属性
 */
- (UIButton *)genericButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    return button;
}
- (void)setBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}
- (void)dismiss:(id)sender
{
    
    [self dismiss:sender animated:YES];
}
- (CALayer *)lineLayer
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:1] CGColor];
    return lineLayer;
}
/**
 *  标题、内容动态行高的计算
 *
 *  @return CGRect
 */
- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        height = size.height;
#pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width,label.text.length?height:0);
}
/**
 *  Block回调
 */
- (void)dismiss:(id)sender animated:(BOOL)animated
{
    
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completion) {
            BOOL cancelled = NO;
            if (sender == self.cancelButton ) {
                cancelled = YES;
            }
            NSInteger buttonIndex = -1;
            if (self.buttons) {
                NSUInteger index = [self.buttons indexOfObject:sender];
                if (index != NSNotFound) {
                    buttonIndex = index;
                }
            }
            if (sender) {
                self.completion(cancelled, buttonIndex);
            }
        }
        WLAlertView * alerView =(WLAlertView *)[self superview];
        [alerView dismissAnimated:YES];
    }];
}

/**
 *  创建alertView
 *
 *  @return alertView
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(WLCAlertViewCompletionBlock)completion
{
    WLSecondExampleAlert *alertView = [[self alloc] initWithTitle:title
                                                  message:message
                                              cancelTitle:cancelTitle
                                               otherTitle:otherTitle
                                               completion:completion];
    return alertView;
}

//设置警告框的属性
-(void)setAlertCornerRadius:(CGFloat)alertCornerRadius{
    self.layer.cornerRadius=alertCornerRadius;
}
-(void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor=titleColor;
}
-(void)setMessageColor:(UIColor *)messageColor{
    self.messageLabel.textColor=messageColor;
}
-(void)setCancleTitleColor:(UIColor *)cancleTitleColor{
    [self.cancelButton setTitleColor:cancleTitleColor forState:UIControlStateNormal];
}
-(void)setOtherTitleColor:(UIColor *)otherTitleColor{
    [self.otherButton setTitleColor:otherTitleColor forState:UIControlStateNormal];
}

-(void)setAlertTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont{
    self.titleLabel.textColor=titleColor;
    self.titleLabel.font=titleFont;
}
-(void)setAlertMessageColor:(UIColor *)messageColor messageFont:(UIFont *)messageFont{
    self.messageLabel.textColor=messageColor;
    self.messageLabel.font=messageFont;
}
-(void)setAlertCancleTitleColor:(UIColor *)cancleTitleColor cancleTitleFont:(UIFont *)cancleTitleFont{
    [self.cancelButton setTitleColor:cancleTitleColor forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font=cancleTitleFont;
}
-(void)setAlertOtherTitleColor:(UIColor *)otherTitleColor otherTitleFont:(UIFont *)otherTitleFont{
    [self.otherButton setTitleColor:otherTitleColor forState:UIControlStateNormal];
    self.otherButton.titleLabel.font=otherTitleFont;
}


@end
