//
//  CustomView.h
//  CircularProgressViewDemo
//
//  Created by lvshasha on 2017/4/26.
//  Copyright © 2017年 nijino. All rights reserved.
//

#import <UIKit/UIKit.h>
//
typedef NS_ENUM(NSInteger, CUSTOMTYPE) {// 点击状态
    CUSTOMBEGIN,              // 开始
    CUSTOMCONTINUE,           // 持续点击
    CUSTOMEND,                // 结束
};
typedef void (^customTypeBlock)(CUSTOMTYPE customType);
@interface CustomView : UIView
@property (nonatomic, copy) customTypeBlock customTypeBlock;
@end
