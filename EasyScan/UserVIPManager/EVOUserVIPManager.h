//
//  EVOUserVIPManager.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOUserVIPManager : NSObject
@property (nonatomic, assign) BOOL isVIP;

- (void)saveUserIsVIP;
@end

NS_ASSUME_NONNULL_END
