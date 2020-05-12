//
//  EVOLanScanManager.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOLanScanManager.h"

@implementation EVOLanScanManager

+ (EVOLanScanManager *)shareLanScanManager {
    static EVOLanScanManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [EVOLanScanManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scanDevicesArray = [NSMutableArray array];
        self.lanScanner = [[MMLANScanner alloc] initWithDelegate:self];
    }
    return self;
}

- (void)startScan:(void(^)(void))block {
    [self.lanScanner start];
    self.scanLanFinishHandler = block;
    [self.scanDevicesArray removeAllObjects];
}

- (void)reStartScan {
    
}

#pragma mark - MMLANScannerDelegate
- (void)lanScanDidFindNewDevice:(MMDevice*)device {
    NSLog(@"%@",device.ipAddress);
    if (![self.scanDevicesArray containsObject:device]) {
        [self.scanDevicesArray addObject:device];
        if (device.isLocalDevice) {
            self.mySelfDevice = device;
        }
    }
}

- (void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status {
    if (status==MMLanScannerStatusFinished) {
        if (self.scanLanFinishHandler) {
            self.scanLanFinishHandler();
        }
    }
}

- (void)lanScanProgressPinged:(long)pingedHosts from:(NSInteger)overallHosts {
    
}

- (void)lanScanDidFailedToScan {
    
}




@end
