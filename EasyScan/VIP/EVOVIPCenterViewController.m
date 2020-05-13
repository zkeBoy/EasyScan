//
//  EVOVIPCenterViewController.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOVIPCenterViewController.h"

@interface EVOVIPCenterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *buyNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPButton;

@end

@implementation EVOVIPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.centerHeightConstraint.constant = kScreenWidth;
    
    self.buyVIPButton.layer.cornerRadius = 4;
}

#pragma mark - Private Method
- (IBAction)clickPopAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:恢复内购
- (IBAction)restoreBuyAction:(id)sender {
    
}

//MARK:内购
- (IBAction)buyVIPAction:(id)sender {
    
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
