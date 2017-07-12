//
//  ShotVideoHelper.h
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ShotVideoHelper;
@protocol ShotVideoHelperDelegate <NSObject>
@required
- (void)recorderDidBeginRecording:(ShotVideoHelper *)recorder;
- (void)recorderDidEndRecording:(ShotVideoHelper *)recorder;
- (void)recorder:(ShotVideoHelper *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error;
@end

@class AVCaptureVideoPreviewLayer;

@interface ShotVideoHelper : NSObject
@property (nonatomic, weak) id<ShotVideoHelperDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;

- (void)swapFrontAndBackCameras;

- (AVCaptureVideoPreviewLayer *)previewLayer;
@end
