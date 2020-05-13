//
//  EVOUserVIPManager.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/13.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#define UserVIPStatusKey @"UserVIPStatusKey"

#import "EVOUserVIPManager.h"

@implementation EVOUserVIPManager

+ (EVOUserVIPManager *)shareUserVIPManager {
    static EVOUserVIPManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [EVOUserVIPManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isVIP = [self getUserIsVIP];
    }
    return self;
}

- (void)saveUserIsVIP {
    NSNumber * number = @YES;
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:UserVIPStatusKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getUserIsVIP {
    NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:UserVIPStatusKey];
    return number.boolValue;
}

@end
