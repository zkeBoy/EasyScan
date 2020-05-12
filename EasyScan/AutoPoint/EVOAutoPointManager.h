//
//  EVOAutoPointManager.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOPointerObj : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@end

@interface EVOAutoPointManager : NSObject
@property (nonatomic, strong) NSMutableArray <EVOPointerObj *>* pointerArray;

- (void)resetAutoPoint:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
