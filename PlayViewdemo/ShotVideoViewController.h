//
//  ShotVideoViewController.h
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordShortVideoDelegate <NSObject>
// 录制完视频的路径
- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath;
@end

@interface ShotVideoViewController : UIViewController

@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property (nonatomic, weak) id<RecordShortVideoDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize themeColor:(UIColor *)themeColor;

@end
