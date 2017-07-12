//
//  ShotVideoViewController.m
//  PlayViewdemo
//
//  Created by lvshasha on 2017/4/24.
//  Copyright © 2017年 com.SmallCircle. All rights reserved.
//

#import "ShotVideoViewController.h"
#import "ShotVideoHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>                  // 系统声音
#import "CustomView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ShotVideoViewController ()<ShotVideoHelperDelegate>
@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) UIColor *themeColor;

@property (strong, nonatomic) NSTimer *stopRecordTimer;
// 开始时间
@property (nonatomic, assign) CFAbsoluteTime beginRecordTime;
// process 计时器
@property (nonatomic, strong) NSTimer *processRecordTimer;
@property (nonatomic, assign) NSTimeInterval processTime;


@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) ShotVideoHelper *recorder;
@property (nonatomic, strong) CustomView *customView;

// 播放视频
@property(nonatomic, strong) AVPlayerItem *item;
@property(nonatomic, strong) AVPlayer *player;

//
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation ShotVideoViewController
#pragma mark - Init

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize themeColor:(UIColor *)themeColor {
    self = [super init];
    if (self) {
        _themeColor = themeColor;
        _outputFilePath = outputFilePath;
        _outputSize = outputSize;
        _videoMaximumDuration = 10; // 最大时间
        self.processTime = 0;
    }
    return self;
}

- (void)dealloc {
    [_recorder stopRunning];
    // 处理清空控制器然后制成 声音不播放的状态
    // 播放视频
    if (self.player) {
        self.player = nil;
    }
    [self.item removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // 添加反转
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-25-27, 20, 27, 25)];
    imageView.image = [UIImage imageNamed:@"PK_Camera_Turn"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swapCamera)];
    [imageView addGestureRecognizer:tap];
    
    //创建视频录制对象
    self.recorder = [[ShotVideoHelper alloc] initWithOutputFilePath:self.outputFilePath outputSize:self.outputSize];
    //通过代理回调
    self.recorder.delegate = self;
    //录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上
    AVCaptureVideoPreviewLayer *previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    CustomView *customView = [[CustomView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 110/2, kScreenHeight - 100 - 110, 110, 110)];
    customView.customTypeBlock = ^(CUSTOMTYPE customType){
        if (customType == CUSTOMCONTINUE) {
            //静止自动锁屏
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            //记录开始录制时间
            self.beginRecordTime = CACurrentMediaTime();
            //开始录制视频
            [self.recorder startRecording];
        } else if (customType == CUSTOMEND) {
            //停止录制
            [self.recorder stopRecording];
            // 获取视频时间
            
        }
    };
    [self.view addSubview:customView];
    self.customView = customView;
    
    [self.recorder startRunning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark 取消
- (void)cancelShoot {
    [self.recorder stopRunning];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 切换前后摄像头
- (void)swapCamera {
    [self.recorder swapFrontAndBackCameras];
}

- (void)recordButtonAction {
//    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
//    [self.recordButton addTarget:self action:@selector(toggleRecording) forControlEvents:UIControlEventValueChanged];
//    [self.recordButton addTarget:self action:@selector(buttonStopRecording) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)sendButtonAction  {
//    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
//    [self.recordButton addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
//    [self.refreshButton addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
//    [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshView {
    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
    
    [self.playButton removeFromSuperview];
    self.playButton = nil;
    [self.refreshButton removeFromSuperview];
    self.refreshButton = nil;
    
//    [self.progressBar restore];
}

- (void)playVideo {
//    UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:self.outputFilePath]];
//    PKFullScreenPlayerViewController *vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:self.outputFilePath previewImage:image];
//    [self presentViewController:vc animated:NO completion:NULL];
}


- (void)endRecordingWithPath:(NSString *)path failture:(BOOL)failture {
    // 提示信息
    NSLog(@"生成视频失败");
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//    self.circlePie.progress = 0.0;
}

+ (void)showAlertViewWithText:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录制小视频失败" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)invalidateTime {
    if ([self.stopRecordTimer isValid]) {
        [self.stopRecordTimer invalidate];
        self.stopRecordTimer = nil;
    }
}

#pragma mark - PKShortVideoRecorderDelegate

///录制开始回调
- (void)recorderDidBeginRecording:(ShotVideoHelper *)recorder {
    //录制长度限制到时间停止
    self.stopRecordTimer = [NSTimer scheduledTimerWithTimeInterval:self.videoMaximumDuration target:self selector:@selector(buttonStopRecording) userInfo:nil repeats:NO];
}

- (void)buttonStopRecording {
    //停止录制
    [self.recorder stopRecording];
}

//录制结束回调
- (void)recorderDidEndRecording:(ShotVideoHelper *)recorder {
    //停止进度条
    NSLog(@"录制结束回掉");
//    self.circlePie.progress = 1.0;
//    [self.progressBar stop];
}

//视频录制结束回调
- (void)recorder:(ShotVideoHelper *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error {
    //解除自动锁屏限制
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //取消计时器
    [self invalidateTime];
    
    if (error) {
        NSLog(@"视频拍摄失败: %@", error );
        [self endRecordingWithPath:outputFilePath failture:YES];
    } else {
        // 视频成功
        self.outputFilePath = outputFilePath;
        NSLog(@"视频成功的路径 %@", self.outputFilePath);
        //
        [self.customView  removeFromSuperview];
        self.customView = nil;
        [self sendAndBackButton];
        
        //
        [self createPlayer];
//        [self.view.layer removeFromSuperlayer];
    }
}

// 播放视频的控制器
- (void)createPlayer
{
    // 播放本地视频
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:self.outputFilePath];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.item = playerItem;
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    playerLayer.videoGravity = AVLayerVideoGravityResize; // 填充屏幕
    [self.view.layer insertSublayer:playerLayer above:self.previewLayer];
    [self.player play];
    //
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]]; //循环播放~
}
///视频循环播放
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}
// 视频状态
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.item.status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"1");
                [self.player seekToTime:CMTimeMake(0, 1)];
                [_player play];
            }
                break;
            case AVPlayerItemStatusFailed:// 视频损坏
            {
                NSLog(@"2");
            }
                break;
            case AVPlayerItemStatusUnknown: // 视频损坏
            {
                NSLog(@"3");
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 发送和返回
- (void)sendAndBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 25;
    backButton.frame = CGRectMake(80, kScreenHeight-120, 50, 50);
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = [UIColor greenColor];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 25;
    sendButton.frame = CGRectMake(kScreenWidth - 80 - 50, kScreenHeight-120, 50, 50);
    [sendButton addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

- (void)backButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didFinishRecordingToOutputFilePath:self.outputFilePath];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
