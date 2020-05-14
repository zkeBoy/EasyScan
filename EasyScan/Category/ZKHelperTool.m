//
//  ZKHelperTool.m
//  MaoNu
//
//  Created by zkeBoy on 2018/7/5.
//  Copyright © 2018年 zkeBoy. All rights reserved.
//

#import "ZKHelperTool.h"

#define is_IphoneX    (kScreenHeight==812)
#define NavBarH       (is_IphoneX?88:64)

@implementation ZKHelperTool

+ (void)showMsg:(NSString *)msg {
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [self showMsg:msg toView:view];
}

+ (void)showMsg:(NSString *)msg toView:(UIView *)view {
    UILabel * label = [UILabel new];
    label.text = msg;
    label.textColor = UIColor.blackColor;
    label.layer.cornerRadius = 8;
    label.font = BFont(16);
    //label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.layer.backgroundColor = RGBHex(@"#EAEAEA").CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(kScreenWidth/2-50, kScreenHeight/2-22, 100, 44);
    label.alpha = 0;
    [view addSubview:label];
    [UIView animateWithDuration:0.4 animations:^{
        label.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //label.frame = CGRectMake(0, -NavBarH, kScreenWidth, 44);
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

+ (UIViewController *)currentController {
    UIViewController * topViewController = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = [self topViewController:topViewController.presentedViewController];
    }
    return topViewController;
}

+ (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    }else {
        return vc;
    }
    return nil;
}

@end
