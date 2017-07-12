//
//  CustomView.m
//  CircularProgressViewDemo
//
//  Created by lvshasha on 2017/4/26.
//  Copyright © 2017年 nijino. All rights reserved.
//

#import "CustomView.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomView ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *bPath;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) NSInteger angle;
@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //重新设置view的大小 设置为以width为边长的正方形区域
        self.frame = CGRectMake(frame.origin.x
                                , frame.origin.y, frame.size.width, frame.size.width);
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 3;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
    
        //初始角度
        _angle = 0;
        //添加按键
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(0, 0, self.frame.size.width, frame.size.width);
        _button.backgroundColor = [UIColor greenColor];
        [self addSubview:_button];
        //添加按键不同事件执行的方法
        [_button addTarget:self action:@selector(cameraButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //绘图
        [self initLayout];
        //定时器设置
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(isButtonClicked) userInfo:nil repeats:YES];
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

- (void)initLayout{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.frame = _button.frame;
    _shapeLayer.lineWidth = 5.0f;
    [self.layer addSublayer:_shapeLayer];
    _bPath = [[UIBezierPath alloc]init];
    //画圆弧
    [_bPath addArcWithCenter:_button.center radius:_button.frame.size.width/2 startAngle:0 endAngle:_angle*M_PI/180 clockwise:YES];
    _shapeLayer.path = _bPath.CGPath;
}

#pragma mark 按键被触摸按下 立刻执行方法内的程序
- (void)cameraButtonTouchDown:(UIButton *)sender{
    [_timer setFireDate:[NSDate distantPast]];
    self.isClicked = YES;
}

#pragma mark 按键按下后执行的方法 注意：isClicked = NO 只有在按键弹起后才会生效
- (void)cameraButtonClicked:(UIButton *)sender
{
    self.isClicked = NO;
}

#pragma mark 定时器方法 重绘角度等

- (void)isButtonClicked
{
    [_shapeLayer removeFromSuperlayer];
    [_bPath removeAllPoints];
    if (self.isClicked) {
        if (_angle < 360) {
            _angle = _angle + 5;
            //重绘
            [self initLayout];
            NSLog(@"绘制");
            self.customTypeBlock(CUSTOMCONTINUE);
        }else{
            //关闭定时器
            [_timer setFireDate:[NSDate distantFuture]];
            //回到初始状态
            _angle = 0;
            [self initLayout];
            NSLog(@"结束一圈");
            self.customTypeBlock(CUSTOMEND);
        }
    }else{
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        //回到初始状态
        _angle = 0;
        [self initLayout];
        NSLog(@"关闭");
        self.customTypeBlock(CUSTOMEND);
    }
}
@end
