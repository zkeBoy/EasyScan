//
//  EVOAutoPointManager.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOAutoPointManager.h"

@implementation EVOAutoPointManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pointerArray = [NSMutableArray array];
    }
    return self;
}

//重置随机点
- (void)resetAutoPoint:(NSInteger)number {
    [self.pointerArray removeAllObjects];
    for (NSInteger idx = 0; idx<number; idx++) {
        EVOPointerObj * obj = [EVOPointerObj new];
        //获取一个随机整数范围在：[0,100)包括0，不包括100
        int x = arc4random() % 200-100;
        int y = arc4random() % 150-50;
        obj.x = x;
        obj.y = y;
        [self.pointerArray addObject:obj];
    }
}

@end

@implementation EVOPointerObj

@end
