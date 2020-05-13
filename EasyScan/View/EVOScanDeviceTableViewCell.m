//
//  EVOScanDeviceTableViewCell.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOScanDeviceTableViewCell.h"

@implementation EVOScanDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgContentView.layer.cornerRadius = 8;
    self.bgContentView.layer.backgroundColor = RGBHex(@"#F5F5F5").CGColor;
}

- (void)setDevice:(MMDevice *)device {
    if (device.isLocalDevice) {
        self.deviceImgView.image = CreateImage(@"my_device");
        self.deviceNameLabel.text = [UIDevice currentDevice].name;
        self.deviceAddressLabel.text = @"我的手机";
    }else {
        self.deviceImgView.image = CreateImage(@"other_device");
        self.deviceNameLabel.text = @"未知设备";
        self.deviceAddressLabel.text = device.ipAddress;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
