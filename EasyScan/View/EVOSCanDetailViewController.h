//
//  EVOSCanDetailViewController.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOSCanDetailViewController : UIViewController
@property (nonatomic, copy) void (^clickResetScanBlock)(void);
@end

NS_ASSUME_NONNULL_END
