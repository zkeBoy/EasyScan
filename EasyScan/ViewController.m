//
//  ViewController.m
//  EasyScan
//
//  Created by zkeBoy on 2020/5/6.
//  Copyright © 2020 zkeBoy. All rights reserved.
//

#import "ViewController.h"
#import "XHRadarView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "EVOWaterWaveView.h"
#import "EVOLanScanManager.h"
#import "EVOAutoPointManager.h"


#define WaterWave 1

@interface ViewController () <XHRadarViewDataSource, XHRadarViewDelegate>
@property (nonatomic, strong) XHRadarView    * radarView;
@property (nonatomic, strong) UIButton       * vipBtn;
@property (nonatomic, strong) UILabel        * scanNumberLabel;
@property (nonatomic, strong) UILabel        * scanTextLabel;
@property (nonatomic, strong) UIButton       * scanButton;
@property (nonatomic, strong) EVOAutoPointManager * autoPointTool;
@property (nonatomic, strong) NSTimer        * timer;
@property (nonatomic,   copy) NSArray        * titles;
@property (nonatomic, assign) NSInteger        loadingNumber;
@property (nonatomic, strong) UIImageView    * bgImgView;
@property (nonatomic, strong) EVOWaterWaveView * water;
@property (nonatomic, strong) EVOWaterWaveView * water2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"检测中",@"检测中.",@"检测中..",@"检测中..."];
    
    [self setUIConfig];
    
    self.autoPointTool = [EVOAutoPointManager new];
    
    [self.radarView scan];
    
    [[EVOLanScanManager shareLanScanManager] startScan:^{
        NSInteger number = [EVOLanScanManager shareLanScanManager].scanDevicesArray.count;
        self.scanNumberLabel.text = NSFormatInt(number);
        [self.autoPointTool resetAutoPoint:number];
        [self startUpdatingRadar];
    }];
    
    [self startTimer];
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标", (unsigned long)weakSelf.autoPointTool.pointerArray.count];
        [weakSelf.radarView show];
        [weakSelf stopTimer];
    });
}

#pragma mark - Timer
- (void)refreshScanLoading {
    if (self.loadingNumber>3) {
        self.loadingNumber = 0;
    }
    NSString * title = self.titles[self.loadingNumber];
    [self.scanButton setTitle:title forState:UIControlStateNormal];
    self.loadingNumber++;
}

- (void)startTimer {
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:0.75 target:self selector:@selector(refreshScanLoading) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.scanButton setTitle:@"开始检测" forState:UIControlStateNormal];
    [self resetScan:YES];
}

- (void)resetScan:(BOOL)stop {
    if (stop) {
        self.bgImgView.image = CreateImage(@"radar_background");
        self.water2.hidden = YES;
        self.water.hidden  = YES;
    }else {
        self.bgImgView.image = CreateImage(@"radar_background_1");
        self.water2.hidden = NO;
        self.water.hidden  = NO;
    }
}

#pragma mark - setUI
- (void)setUIConfig {
    
#if WaterWave
    NSString * imageName = @"radar_background_1";
#else
    NSString * imageName = @"radar_background";
#endif
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    self.bgImgView = imageView;
    
    XHRadarView * radarView = [[XHRadarView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+57, kScreenWidth, kScreenWidth)];
    radarView.clipsToBounds = YES;
    radarView.dataSource = self;
    radarView.indicatorStartColor = RGBHex(@"#FFFFFF");
    radarView.indicatorEndColor = RGBHexA(@"#1FA5E0", 0);
    radarView.delegate = self;
    radarView.radius = 200;
    //radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    //radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
    radarView.labelText = @" ";
    radarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:radarView];
    self.radarView = radarView;
    
    UIImageView * centerImgView = [[UIImageView alloc] initWithImage:CreateImage(@"icon_center_point")];
    [self.radarView addSubview:centerImgView];
    [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.center.equalTo(self.radarView);
    }];
    
    [self.view addSubview:self.vipBtn];
    self.vipBtn.frame = CGRectMake(kScreenWidth-56, 11+kStatusBarHeight, 46, 20);

    //添加水波纹
    self.water = [[EVOWaterWaveView alloc] initWithFrame:CGRectMake(0, kScreenHeight-216, kScreenWidth,216)];
    [self.view addSubview:self.water];
    
    self.water2 = [[EVOWaterWaveView alloc] initWithFrame:CGRectMake(0, kScreenHeight-216, kScreenWidth,216)];
    self.water2.waterWaveHeight = 50;
    self.water2.height_Y = 2;
    self.water2.offset_X = 7;
    [self.view addSubview:self.water2];

    NSInteger top = 120;
    if (!isFullScreen) {
        top = 0.4*top;
    }
    [self.view addSubview:self.scanNumberLabel];
    [self.scanNumberLabel setFrame:CGRectMake(0, CGRectGetMaxY(radarView.frame)+top, kScreenWidth, 50)];
    
    [self.view addSubview:self.scanTextLabel];
    [self.scanTextLabel setFrame:CGRectMake(0, CGRectGetMaxY(self.scanNumberLabel.frame)+20, kScreenWidth, 20)];
    
    [self.view addSubview:self.scanButton];
    [self.scanButton setFrame:CGRectMake(73, CGRectGetMaxY(self.scanTextLabel.frame)+15, kScreenWidth-146, 46)];
}

#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView {
    return 4;
}

- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView {
    return self.autoPointTool.pointerArray.count;
}

- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [imageView setImage:[UIImage imageNamed:@"icon_point"]];
    [pointView addSubview:imageView];
    return pointView;
}

- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    EVOPointerObj *point = [self.autoPointTool.pointerArray objectAtIndex:index];
    return CGPointMake(point.x, point.y);
}

#pragma mark - XHRadarViewDelegate
- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
}

#pragma mark - Private Method
- (void)vipEnterAction {
    
}

- (void)clickScanDetectingAction {
    [self startTimer];
    [self resetScan:NO];
}

#pragma mark - lazy init
- (UIButton *)vipBtn {
    if (!_vipBtn) {
        _vipBtn = [UIButton new];
        [_vipBtn setBackgroundImage:[UIImage imageNamed:@"VIP"] forState:UIControlStateNormal];
        [_vipBtn setBackgroundImage:[UIImage imageNamed:@"VIP"] forState:UIControlStateHighlighted];
        [_vipBtn addTarget:self action:@selector(vipEnterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipBtn;
}

- (UILabel *)scanNumberLabel {
    if (!_scanNumberLabel) {
        _scanNumberLabel = [UILabel new];
        _scanNumberLabel.textAlignment = NSTextAlignmentCenter;
        _scanNumberLabel.text = @"0";
        _scanNumberLabel.font = [UIFont boldSystemFontOfSize:50];
        _scanNumberLabel.textColor = UIColor.whiteColor;
    }
    return _scanNumberLabel;
}

- (UILabel *)scanTextLabel {
    if (!_scanTextLabel) {
        _scanTextLabel = [UILabel new];
        _scanTextLabel.textAlignment = NSTextAlignmentCenter;
        _scanTextLabel.text = @"点击按钮开始扫描检测";
        _scanTextLabel.font = [UIFont boldSystemFontOfSize:14];
        _scanTextLabel.textColor = UIColor.whiteColor;
    }
    return _scanTextLabel;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton new];
        _scanButton.layer.cornerRadius = 23;
        _scanButton.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _scanButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _scanButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _scanButton.layer.shadowOpacity = 0.8f;
        _scanButton.layer.shadowOffset = CGSizeMake(2, 0);
        _scanButton.layer.shadowRadius = 5.f;
        [_scanButton addTarget:self action:@selector(clickScanDetectingAction) forControlEvents:UIControlEventTouchUpInside];
        [_scanButton setTitle:@"检测中…" forState:UIControlStateNormal];
        [_scanButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _scanButton;
}

@end
