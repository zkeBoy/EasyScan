//
//  EVOLanScanManager.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMLANScanner.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOLanScanManager : NSObject <MMLANScannerDelegate>
kSPrStrong(MMLANScanner * lanScanner);

+ (EVOLanScanManager *)shareLanScanManager;
@end

NS_ASSUME_NONNULL_END
