//
//  EVOSCanDetailViewController.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOSCanDetailViewController.h"
#import "EVOLanScanManager.h"

@interface EVOSCanDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reScanBtn;
@property (weak, nonatomic) IBOutlet UILabel *speedTextLabel;

@end

@implementation EVOSCanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reScanBtn.layer.cornerRadius = 14;
    
    NSString * speed = [EVOLanScanManager shareLanScanManager].getByteRate;
    NSString * brand = [[EVOLanScanManager shareLanScanManager] getBand];
    self.speedTextLabel.text = [NSString stringWithFormat:@"网速：%@,相当于%@宽带",speed,brand];
}

#pragma mark - Private Method
- (IBAction)clickBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetScanWIFIAction:(id)sender {
    [self clickBackAction:nil];
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
