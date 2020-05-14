//
//  MFProgressHUD.m
//  MFProject
//
//  Created by xinxian on 2019/11/28.
//

#import "MFProgressHUD.h"

#define BGVIEW_WIDTH 70.0f
#define TEXT_SIZE    16.0f

@implementation MFProgressHUD

+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(MFProgressHUDStatus)status text:(NSString*)text {
    MFProgressHUD * HUD = [MFProgressHUD sharedHUD];
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.color = [UIColor blackColor];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [HUD showAnimated:YES];
    HUD.square = NO;//等宽高
    HUD.margin = 15;//修改该值，可以修改加载框大小
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.label.textColor = [UIColor whiteColor];
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    HUD.bezelView.layer.cornerRadius = 10;
    [HUD setMinSize:CGSizeZero];
    //图片文件获取
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MBProgressHUD" ofType:@"bundle"];
    switch(status) {
        case MFProgressHUDStatusSuccess: {
            NSString*sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Success.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            HUD.customView= sucView;
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
            break;
        case MFProgressHUDStatusError: {
            NSString * errPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Error.png"];
            UIImage * errImage = [UIImage imageWithContentsOfFile:errPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView * errView = [[UIImageView alloc] initWithImage:errImage];
            HUD.customView = errView;
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
            break;
        case MFProgressHUDStatusLoading: {
            HUD.userInteractionEnabled = YES;
            HUD.square = YES;//等宽高
            [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
            //设置菊花框为白色
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            HUD.mode = MBProgressHUDModeIndeterminate;
        }
            break;
        case MFProgressHUDStatusWaitting: {
            NSString * infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Warn.png"];
            UIImage * infoImage = [UIImage imageWithContentsOfFile:infoPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView * infoView = [[UIImageView alloc]initWithImage:infoImage];
            HUD.customView= infoView;
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
            break;
        case MFProgressHUDStatusInfo: {
            NSString * infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Info.png"];
            UIImage*infoImage = [UIImage imageWithContentsOfFile:infoPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView*infoView = [[UIImageView alloc]initWithImage:infoImage];
            HUD.customView= infoView;
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
            break;
        default:
            break;
     }
    
    [self.currentController.view addSubview:HUD];
}

+ (void)showMessage:(NSString*)text {
    MFProgressHUD *HUD = [MFProgressHUD sharedHUD];
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor blackColor];
    [HUD showAnimated:YES];
    HUD.square = NO;//等宽高
    HUD.margin = 15;//修改该值，可以修改加载框大小
    HUD.label.text = text;
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.layer.cornerRadius = 10;
    [HUD setMinSize:CGSizeZero];
    [HUD setMode:MBProgressHUDModeText];
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MFProgressHUD sharedHUD] hideAnimated:YES];
    });
}

+ (void)showWaiting:(NSString*)text {
    [self showStatus:MFProgressHUDStatusWaitting text:text];
}

+ (void)showError:(NSString*)text {
    [self showStatus:MFProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString*)text {
    [self showStatus:MFProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString*)text {
    [self showStatus:MFProgressHUDStatusLoading text:text];
}

+ (void)showPayFail {
    MFProgressHUD *HUD = [MFProgressHUD sharedHUD];
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    [HUD showAnimated:YES];
    HUD.square = NO;//等宽高
    HUD.margin = 20;//修改该值，可以修改加载框大小
    //蒙版显示 YES , NO 不显示
    //HUD.dimBackground = YES;
    HUD.label.text= @"支付失败\n请联系在线客服";
    HUD.label.numberOfLines=0;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.layer.cornerRadius = 15;
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont systemFontOfSize:14];
    [HUD setMinSize:CGSizeZero];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    UIImage *errImage = [UIImage imageNamed:@"pay_icon_lose_red"];
    HUD.mode = MBProgressHUDModeCustomView;
    UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
    HUD.customView= errView;
    [HUD hideAnimated:YES afterDelay:1.5f];
}

+ (void)showVideo:(UIView *)view setText:(NSString *)text {
    MFProgressHUD *HUD = [MFProgressHUD sharedHUD];
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    [HUD showAnimated:YES];
    HUD.square = NO;//等宽高
    HUD.margin = 15;//修改该值，可以修改加载框大小
    HUD.label.numberOfLines=0;
    HUD.label.textColor = [UIColor whiteColor];
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    HUD.bezelView.layer.cornerRadius = 10;
    [HUD setMinSize:CGSizeZero];
    HUD.square = YES;//等宽高
    HUD.label.text= text;
    [view addSubview:HUD];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    HUD.mode = MBProgressHUDModeIndeterminate;
}

+ (void)hideHUD {
    [[MFProgressHUD sharedHUD] hideAnimated:YES afterDelay:1.f];
}

+ (void)hideHUDNow {
    [[MFProgressHUD sharedHUD] hideAnimated:YES afterDelay:0];
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
