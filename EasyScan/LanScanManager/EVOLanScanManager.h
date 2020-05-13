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
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOLanScanManager : NSObject <MMLANScannerDelegate>
kSPrStrong(MMLANScanner * lanScanner);
kSPrCopy__(void(^scanLanFinishHandler)(void));
kSPrStrong(NSMutableArray <MMDevice *>* scanDevicesArray);
kSPrStrong(MMDevice * mySelfDevice);

+ (EVOLanScanManager *)shareLanScanManager;
- (void)startScan:(void(^)(void))block;
//MARK:获取当前网速
- (NSString *)getByteRate;
//转化为带宽
- (NSString *)getBand;
@end

NS_ASSUME_NONNULL_END
