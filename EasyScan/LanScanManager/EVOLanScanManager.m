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

//MARK:获取当前网速
- (NSString *)getByteRate {
    long long intcurrentBytes = [self getInterfaceBytes];
    NSString *rateStr = [self formatNetWork:intcurrentBytes];
    return rateStr;
}

- (long long) getInterfaceBytes {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)){
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    return iBytes + oBytes;
}

- (NSString *)formatNetWork:(long long int)rate {
    if (rate <1024) {
        return [NSString stringWithFormat:@"%lldB/秒", rate];
    } else if (rate >=1024&& rate <1024*1024) {
        return [NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
    } else if (rate >=1024*1024&& rate <1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
    } else {
        return@"10Kb/秒";
    };
}


@end
