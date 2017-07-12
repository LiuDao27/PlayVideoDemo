//
//  ShotPieView.m
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import "ShotPieView.h"

@implementation ShotPieView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (progress >= 1.0) {
//            [self removeFromSuperview];
        } else {
            [self setNeedsDisplay];
        }
    });
    
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}

@end
