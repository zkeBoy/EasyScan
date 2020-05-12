//
//  EVOWaterWaveView.h
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVOWaterWaveView : UIView
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
//水波的高度
@property (nonatomic, assign) CGFloat waterWaveHeight;
//Y周的高度
@property (nonatomic, assign) CGFloat height_Y;
//X轴的偏移量
@property (nonatomic, assign) CGFloat offset_X;
@end

NS_ASSUME_NONNULL_END
