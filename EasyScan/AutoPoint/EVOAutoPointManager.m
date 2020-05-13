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
    if (number>10) {
        for (NSInteger idx = 0; idx<10; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 100-100;
            int y = arc4random() % 150-50;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>20) {
        for (NSInteger idx = 10; idx<20; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 100;
            int y = arc4random() % 150;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>30) {
        for (NSInteger idx = 20; idx<30; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 100-50;
            int y = arc4random() % 100-50;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>40) {
        for (NSInteger idx = 30; idx<40; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 200-150;
            int y = arc4random() % 100;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>50) {
        for (NSInteger idx = 40; idx<50; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 150;
            int y = arc4random() % 200;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>60) {
        for (NSInteger idx = 50; idx<60; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 250-100;
            int y = arc4random() % 150-50;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>70) {
        for (NSInteger idx = 60; idx<70; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 250;
            int y = arc4random() % 150;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>80) {
        for (NSInteger idx = 70; idx<80; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 100;
            int y = arc4random() % 100;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
    
    if (number>80) {
        for (NSInteger idx = 80; idx<number; idx++) {
            EVOPointerObj * obj = [EVOPointerObj new];
            //获取一个随机整数范围在：[0,100)包括0，不包括100
            int x = arc4random() % 250;
            int y = arc4random() % 150-50;
            obj.x = x;
            obj.y = y;
            [self.pointerArray addObject:obj];
        }
    }
}

@end

@implementation EVOPointerObj

@end
