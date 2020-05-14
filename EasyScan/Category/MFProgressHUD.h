//
//  MFProgressHUD.h
//  MFProject
//
//  Created by xinxian on 2019/11/28.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,MFProgressHUDStatus) {
    /** 成功 */
    MFProgressHUDStatusSuccess,
    /** 失败 */
    MFProgressHUDStatusError,
    /** 警告*/
    MFProgressHUDStatusWaitting,
    /** 提示 */
    MFProgressHUDStatusInfo,
    /** 等待 */
    MFProgressHUDStatusLoading
};

@interface MFProgressHUD : MBProgressHUD

/** 返回一个 HUD 的单例 */

+ (instancetype)sharedHUD;

/** 在 window 上添加一个 HUD */

+ (void)showStatus:(MFProgressHUDStatus)status text:(NSString*)text;

#pragma mark - 建议使用的方法

/** 在 window 上添加一个只显示文字的 HUD */

+ (void)showMessage:(NSString*)text;

/** 在 window 上添加一个提示`信息`的 HUD */

+ (void)showWaiting:(NSString*)text;

/** 在 window 上添加一个提示`失败`的 HUD */

+ (void)showError:(NSString*)text;

/** 在 window 上添加一个提示`成功`的 HUD */

+ (void)showSuccess:(NSString*)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */

+ (void)showLoading:(NSString*)text;

/// 支付失败
+ (void)showPayFail;

/// 加载到视图
+ (void)showVideo:(UIView *)view setText:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hideHUD;

///立即隐藏
+ (void)hideHUDNow;
@end

NS_ASSUME_NONNULL_END
