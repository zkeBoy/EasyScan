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

#pragma mark - MMLANScannerDelegate
- (void)lanScanDidFindNewDevice:(MMDevice*)device {
    //NSLog(@"%@",device.ipAddress);
    if (![self.scanDevicesArray containsObject:device]) {
        if (device.isLocalDevice) {
            self.mySelfDevice = device;
        }else {
            [self.scanDevicesArray addObject:device];
        }
    }
}

- (void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status {
    if (status==MMLanScannerStatusFinished) {
        [self.scanDevicesArray insertObject:self.mySelfDevice atIndex:0];
        if (self.scanLanFinishHandler) {
            self.scanLanFinishHandler();
        }
    }
}

- (void)lanScanProgressPinged:(long)pingedHosts from:(NSInteger)overallHosts {
    
}

- (void)lanScanDidFailedToScan {
    if (self.scanLanFinishHandler) {
        self.scanLanFinishHandler();
    }
}

//MARK:获取当前网速
- (NSString *)getByteRate {
    long long intcurrentBytes = [self getInterfaceBytes];
    NSString * rateStr = [self formatNetWork:intcurrentBytes];
    return rateStr;
}

- (long long)getInterfaceBytes {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    struct timeval32 time;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        // Not a loopback device.
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
            time = if_data->ifi_lastchange;
        }
        
        //wifi flow
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        
        //3G and gprs flow
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    return wifiFlow;
}

- (NSString *)formatNetWork:(long long int)size {
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0 KB",@"");
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qubytes", size];
    }else if (size >= 1024 && size < pow(1024, 2)){
        formattedStr = [NSString stringWithFormat:@"%quKB", (size / 1024)];
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        int intsize = size / pow(1024, 2);
        formattedStr = [NSString stringWithFormat:@"%dMB", intsize];
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dGB", intsize];
    }
    return formattedStr;
}

- (NSString *)getBand {
    long long size = [self getInterfaceBytes];
    size *=8;
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    return formattedStr;
}


@end
