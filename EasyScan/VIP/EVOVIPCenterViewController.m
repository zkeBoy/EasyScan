//
//  EVOVIPCenterViewController.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOVIPCenterViewController.h"
#import "ZKHelperTool.h"
#import "MFProgressHUD.h"

@interface EVOVIPCenterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * centerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel  * buyNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton * buyVIPButton;
@property (nonatomic, copy) NSString * productId;
@end

@implementation EVOVIPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.centerHeightConstraint.constant = kScreenWidth;
    
    self.productId = @"unlock001";
    
    self.buyVIPButton.layer.cornerRadius = 4;
}

#pragma mark - Private Method
- (IBAction)clickPopAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:恢复内购
- (IBAction)restoreBuyAction:(id)sender {
    [self restoreProduct];
}

//MARK:内购
- (IBAction)buyVIPAction:(id)sender {
    [self startBuyVIP];
}

#pragma mark - Store
- (void)startBuyVIP {
    NSString * appleProductId = self.productId;
    [MFProgressHUD showLoading:@"支付中..."];
    [[RMStore defaultStore] addPayment:appleProductId success:^(SKPaymentTransaction *transaction) {
        NSLog(@"－－－－－－交易成功－－－－－－");
        [[EVOUserVIPManager shareUserVIPManager] saveUserIsVIP];
        [ZKHelperTool showMsg:@"交易成功"];
        [MFProgressHUD hideHUDNow];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        NSLog(@"－－－－－－交易失败－－－－－－");
        NSLog(@"error:%@",error);
        [ZKHelperTool showMsg:@"交易失败"];
        [MFProgressHUD hideHUDNow];
    }];
}

- (void)restoreProduct {
    [MFProgressHUD showLoading:@"恢复..."];
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        [[EVOUserVIPManager shareUserVIPManager] saveUserIsVIP];
        [ZKHelperTool showMsg:@"恢复成功"];
        [MFProgressHUD hideHUDNow];
    } failure:^(NSError *error) {
        [ZKHelperTool showMsg:@"恢复失败"];
        [MFProgressHUD hideHUDNow];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
