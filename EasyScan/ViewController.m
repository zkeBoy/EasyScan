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
#import "XHRadarIndicatorView.h"
#import "EVOSCanDetailViewController.h"
#import "EVOVIPCenterViewController.h"

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
@property (nonatomic, strong) NSMutableArray   <UIView *>* localPointerArray;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.localPointerArray = [NSMutableArray array];
    
    self.titles = @[@"检测中",@"检测中.",@"检测中..",@"检测中..."];
    
    [self setUIConfig];
    
    self.autoPointTool = [EVOAutoPointManager new];
    
    //隐藏
    [self resetScan:YES];
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    self.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标", (unsigned long)self.autoPointTool.pointerArray.count];
    [self.radarView show];
    [self stopTimer];
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
        [self.radarView stop];
        [self.radarView hide];
    }else {
        self.bgImgView.image = CreateImage(@"radar_background_1");
        self.water2.hidden = NO;
        self.water.hidden  = NO;
        self.scanNumberLabel.text = @"0";
        [self.radarView scan];
        for (UIView * view in self.localPointerArray) {
            view.hidden = YES;
            [view removeFromSuperview];
        }
    }
}

#pragma mark - setUI
- (void)setUIConfig {

    NSString * imageName = @"radar_background_1";
    
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
    radarView.radius = kScreenWidth/2;
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
    [self.localPointerArray addObject:pointView];
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
    EVOVIPCenterViewController * vipVC = [EVOVIPCenterViewController new];
    [self.navigationController pushViewController:vipVC animated:YES];
}

- (void)clickScanDetectingAction {
    self.scanButton.enabled = NO;
    self.vipBtn.enabled = NO;
    [self startTimer];
    [self resetScan:NO];
    
    [[EVOLanScanManager shareLanScanManager] startScan:^{
        NSInteger number = [EVOLanScanManager shareLanScanManager].scanDevicesArray.count;
        self.scanNumberLabel.text = NSFormatInt(number);
        [self.autoPointTool resetAutoPoint:number];
        [self startUpdatingRadar];
        self.scanButton.enabled = YES;
        self.vipBtn.enabled = YES;
        [self presentScanDetailVC];
    }];
    
    if (@available(iOS 11.0, *)) {
        // 初始化震动反馈类
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        // 准备
        [generator prepare];
        // 调用
        [generator impactOccurred];
     }
}

- (void)presentScanDetailVC {
    WeakSelf(self);
    EVOSCanDetailViewController * vc = [[EVOSCanDetailViewController alloc] initWithNibName:@"EVOSCanDetailViewController" bundle:nil];
    vc.clickResetScanBlock = ^{
        [WeakSelf clickScanDetectingAction];
    };
    [self presentViewController:vc animated:YES completion:nil];
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
        [_scanButton setTitle:@"开始检测" forState:UIControlStateNormal];
        [_scanButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _scanButton;
}

@end
