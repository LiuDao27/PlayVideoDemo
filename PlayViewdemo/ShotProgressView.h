//
//  ShotProgressView.h
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/25.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShotProgressView : UIView
@property (assign, nonatomic) float progress;
// 
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat lineWidth;
@end
