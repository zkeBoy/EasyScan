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


@interface ViewController () <XHRadarViewDataSource, XHRadarViewDelegate>
@property (nonatomic, strong) NSMutableArray * pointsArray;
@property (nonatomic, strong) XHRadarView    * radarView;
@property (nonatomic, strong) UIButton       * vipBtn;
@property (nonatomic, strong) UILabel        * scanNumberLabel;
@property (nonatomic, strong) UILabel        * scanTextLabel;
@property (nonatomic, strong) UIButton       * scanButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUIConfig];
    
    //目标点位置
    NSArray * arr = @[
                    @[@6, @90],
                    @[@-140, @108],
                    @[@-83, @98],
                    @[@-25, @142],
                    @[@60, @111],
                    @[@-111, @96],
                    @[@150, @145],
                    @[@25, @144],
                    @[@-55, @110],
                    @[@95, @109],
                    @[@170, @180],
                    @[@125, @112],
                    @[@-150, @145],
                    @[@-7, @160],
                    ];
    
    [self.pointsArray addObjectsFromArray:arr];
    
    [self.radarView scan];
    [self startUpdatingRadar];
    
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标", (unsigned long)weakSelf.pointsArray.count];
        [weakSelf.radarView show];
    });
}

#pragma mark - setUI
- (void)setUIConfig {
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar_background"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
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
        make.width.height.mas_equalTo(62);
        make.center.equalTo(self.radarView);
    }];
    
    [self.view addSubview:self.vipBtn];
    self.vipBtn.frame = CGRectMake(kScreenWidth-56, 11+kStatusBarHeight, 46, 20);

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
    return [self.pointsArray count];
}

- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [imageView setImage:[UIImage imageNamed:@"icon_point"]];
    [pointView addSubview:imageView];
    return pointView;
}

- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - XHRadarViewDelegate
- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
}

#pragma mark - Private Method
- (void)vipEnterAction {
    
}

- (void)clickScanDetectingAction {
    
}

#pragma mark - lazy init
- (NSMutableArray *)pointsArray {
    if (!_pointsArray) {
        _pointsArray = [NSMutableArray array];
    }
    return _pointsArray;
}

- (UIButton *)vipBtn {
    if (!_vipBtn) {
        _vipBtn = [UIButton new];
        [_vipBtn setBackgroundImage:[UIImage imageNamed:@"VIP"] forState:UIControlStateNormal];
        [_vipBtn addTarget:self action:@selector(vipEnterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipBtn;
}

- (UILabel *)scanNumberLabel {
    if (!_scanNumberLabel) {
        _scanNumberLabel = [UILabel new];
        _scanNumberLabel.textAlignment = NSTextAlignmentCenter;
        _scanNumberLabel.text = @"15";
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
