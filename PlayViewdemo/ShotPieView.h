//
//  ShotPieView.h
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShotPieView : UIView

//
@property (nonatomic, assign) CGFloat progress;
//
- (void)dismiss;
// 
+ (id)progressView;
@end
