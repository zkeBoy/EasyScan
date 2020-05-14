//
//  AppDelegate.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/6.
//  Copyright © 2020 zkeBoy. All rights reserved.
//  com.dirtywork.radar
/*
 tony@dirtywork.com
 Dirtywork123
 */

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerStore];
    return YES;
}

- (void)registerStore {
    NSArray * productIds = @[@"unlock001"];
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:productIds] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        if([products count] == 0){
            NSLog(@"--------------没有商品------------------");
            return;
        }
    } failure:^(NSError *error) {
         NSLog(@"--------------请求商品失败------------------");
    }];
}


@end
