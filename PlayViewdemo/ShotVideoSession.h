//
//  ShotVideoSession.h
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@class ShortVideoSessionDelegate;
@protocol ShortVideoSessionDelegate <NSObject>
- (void)sessionDidFinishPreparing:(ShortVideoSessionDelegate *)session;
- (void)session:(ShortVideoSessionDelegate *)session didFailWithError:(NSError *)error;
- (void)sessionDidFinishRecording:(ShortVideoSessionDelegate *)session;
@end

@interface ShotVideoSession : NSObject
@property (nonatomic, readonly) BOOL videoInitialized;
@property (nonatomic, readonly) BOOL audioInitialized;

@property (nonatomic, weak) id<ShortVideoSessionDelegate> delegate;

- (instancetype)initWithTempFilePath:(NSString *)tempFilePath;

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings;
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)prepareToRecord;
- (void)finishRecording;
@end


