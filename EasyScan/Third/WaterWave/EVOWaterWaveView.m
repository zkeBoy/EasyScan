//
//  EVOWaterWaveView.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/12.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "EVOWaterWaveView.h"

@implementation EVOWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIConfig];
    }
    return self;
}

- (void)setUIConfig {
    self.waterWaveHeight = 50;
    self.height_Y = 1.5;
    self.offset_X = 1.0;
    
    //新建一个形状图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //图形填充的颜色
    //shapeLayer.fillColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:0.3] CGColor];
    shapeLayer.fillColor = RGBHexA(@"#ffffff", 0.2).CGColor;
    shapeLayer.strokeColor = RGBHexA(@"#ffffff", 0.2).CGColor;
    //图形线的宽度
    shapeLayer.lineWidth = 1;
    //图形线（边界）的颜色
    //shapeLayer.strokeColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:0.3] CGColor];
    
    //添加形状图层
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    ///创建一个和屏幕刷新频率相同的计时器：CADisplayLink
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(creatAnimationPath)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)creatAnimationPath{
    self.offset_X += 0.1;
    [self craetWavePath];
}

- (void)craetWavePath {
    //绘制图层的路径
    CGMutablePathRef wavePath = CGPathCreateMutable();
    //绘制路径的起始位置
    CGPathMoveToPoint(wavePath, nil, 0, self.waterWaveHeight);
    CGFloat y = 0.f;
    //y=Asin（ωx+φ）+h
    //路径最大的宽度，屏幕的宽度
    CGFloat pathWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat pathheight = [UIScreen mainScreen].bounds.size.height;
    //画点
    for (float x = 0.0; x <= pathWidth; x++) {
        y = 10*self.height_Y * sin((x/180*M_PI) - 2*(self.offset_X/M_PI)) + self.waterWaveHeight;//x= 0.0时 y在self.waterWaveHeight的高度
        CGPathAddLineToPoint(wavePath, nil, x, y);
    }
    
    CGPathAddLineToPoint(wavePath, nil, pathWidth, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, self.waterWaveHeight);
    
    //结束绘图信息
    CGPathCloseSubpath(wavePath);
    
    self.shapeLayer.path = wavePath;
    //释放绘图路径
    CGPathRelease(wavePath);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
