//
//  EVOSCanDetailViewController.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOSCanDetailViewController.h"
#import "EVOLanScanManager.h"
#import "EVOScanDeviceTableViewCell.h"
#import "EVOLanScanManager.h"

@interface EVOSCanDetailViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *reScanBtn;
@property (weak, nonatomic) IBOutlet UILabel *speedTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EVOSCanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reScanBtn.layer.cornerRadius = 14;
    
    NSString * speed = [EVOLanScanManager shareLanScanManager].getByteRate;
    NSString * brand = [[EVOLanScanManager shareLanScanManager] getBand];
    self.speedTextLabel.text = [NSString stringWithFormat:@"网速：%@,相当于%@宽带",speed,brand];
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVOScanDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"EVOScanDeviceTableViewCell"];
}

#pragma mark - Private Method
- (IBAction)clickBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetScanWIFIAction:(id)sender {
    [self clickBackAction:nil];
    if (self.clickResetScanBlock) {
        self.clickResetScanBlock();
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVOLanScanManager.shareLanScanManager.scanDevicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMDevice * device = EVOLanScanManager.shareLanScanManager.scanDevicesArray[indexPath.row];
    EVOScanDeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EVOScanDeviceTableViewCell" forIndexPath:indexPath];
    cell.device = device;
    return cell;
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
