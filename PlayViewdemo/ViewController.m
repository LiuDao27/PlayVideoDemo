//
//  ViewController.m
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import "ViewController.h"
#import "ShotVideoViewController.h"
#import "ShotProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<RecordShortVideoDelegate>
@property (nonatomic, strong) NSString *videoImageString;   // 第一张图片
@property (nonatomic, assign) NSInteger videoTimeLonger;    // 视频时间
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
//    ShotProgressView *processView = [[ShotProgressView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 150/2, kScreenHeight - 100 - 150, 150, 150)];
//    static CGFloat progress = 0;
//    if (progress < 1.0) {
//        progress += 0.1;
//        
//        // 循环
//        if (progress >= 1.0) progress = 0;
//        processView.progress = progress;
//    }
//    [self.view addSubview:processView];
    
//    ShotCirclePieview *circlePie = [ShotCirclePieview progressView];
//    circlePie.frame = CGRectMake(kScreenWidth/2 - 100/2, kScreenHeight - 100 - 100, 100, 100);
////    circlePie.progress = 0.3;
//    [self.view addSubview:circlePie];
//    
    
}

- (void)buttonClick:(UIButton *)button
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
    //跳转默认录制视频ViewController
    ShotVideoViewController *viewController = [[ShotVideoViewController alloc] initWithOutputFilePath:path outputSize:CGSizeMake(kScreenWidth, kScreenHeight) themeColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1]];
    //通过代理回调
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - PKRecordShortVideoDelegate
//视频拍摄完成输出图片
- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath {
    NSLog(@"路径 %@", outputFilePath);
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:outputFilePath] options:nil];
    self.videoTimeLonger = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    self.videoImageString = [self obtainVideoFirstImage:outputFilePath];
    NSLog(@"视频图片 %@", self.videoImageString);
}

//
#pragma mark 获取视频的第一张图片
- (NSString *)obtainVideoFirstImage:(NSString *)videoFilePath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoFilePath] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0.1f;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, self.videoTimeLonger) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    NSData *data = UIImageJPEGRepresentation(thumbnailImage, 1.0f);
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
