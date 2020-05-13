//
//  EVOScanDeviceTableViewCell.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDevice.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOScanDeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLabel;
@property (nonatomic, strong) MMDevice * device;
@end

NS_ASSUME_NONNULL_END
