//
//  EVOLanScanManager.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMLANScanner.h>
#import <MMDevice.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOLanScanManager : NSObject <MMLANScannerDelegate>
kSPrStrong(MMLANScanner * lanScanner);
kSPrCopy__(void(^scanLanFinishHandler)(void));
kSPrStrong(NSMutableArray <MMDevice *>* scanDevicesArray);

+ (EVOLanScanManager *)shareLanScanManager;
- (void)startScan:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
