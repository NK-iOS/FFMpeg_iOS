//
//  NKAVPlayerView.m
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "NKAVPlayerView.h"

@interface NKAVPlayerView()
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) CGRect shrinkRect;
@end

@implementation NKAVPlayerView
- (AVPlayer *)avPlayer
{
    if (_avPlayer == nil) {
        _avPlayer = [[AVPlayer alloc] init];
        // 设置默认音量
//        _avPlayer.volume = 0.5;
        // 获取系统声音
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        CGFloat currentVolume = audioSession.outputVolume;
        _avPlayer.volume = currentVolume;
    }
    return _avPlayer;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)init
{
    if (self = [super init]) {
        // 让view的layerClass为AVPlayerLayer类，那么self.layer就为AVPlayerLayer的实例
        self.playerLayer = (AVPlayerLayer *)self.layer;
        self.playerLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        // 初始化playerLayer的player
        self.playerLayer.player = self.avPlayer;
        [self settingControlUI];
        [self setupNotification];
    }
    return self;
}

- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem
{
    if (self = [super init]) {
        self.playerLayer = (AVPlayerLayer *)self.layer;
        self.playerLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        self.playerLayer.player = self.avPlayer;
        
        _playerItem = playerItem;
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        
        [self settingControlUI];
        [self setupNotification];
    }
    return self;
}

- (void)settingControlUI
{
    self.controlView = [[NKAVPlayerControlView alloc] initWithFrame:self.bounds];
    [self addSubview:_controlView];
    
    [self.controlView.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    self.controlView.playerSilder.tapChangeValue = ^(float value) {
        CMTime duration = weakSelf.playerItem.duration;
        [weakSelf.playerItem seekToTime:CMTimeMake(CMTimeGetSeconds(duration) * value, 1.0) completionHandler:^(BOOL finished) {
            
        }];
    };
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.controlView.frame = self.bounds;
}

- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl
{
    [self settingPlayerItem:[[AVPlayerItem alloc] initWithURL:playerUrl]];
}

- (void)settingPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self removeObserver];
    [self pause];
    /*
     replaceCurrentItemWithPlayerItem: 用于切换视频
     */
    // 设置当前playerItem
    [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self addObserver];
}

- (void)removeObserver
{
    // 移除监听 和通知
    // 监控它的status也可以获得播放状态
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    // 缓冲加载
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    // 播放完成
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.avPlayer removeTimeObserver:self.timeObserver];
}

- (void)addObserver{
    
    // 监控它的status也可以获得播放状态
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监控缓冲加载
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监控播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    
    //监控时间进度(根据API提示，如果要监控时间进度，这个对象引用计数器要+1，retain)
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 获取 item 当前播放秒
        float currentPlayTime = (double)weakSelf.avPlayer.currentItem.currentTime.value/ weakSelf.avPlayer.currentItem.currentTime.timescale;
        [weakSelf updateVideoSlider:currentPlayTime];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        // 播放状态
        AVPlayerItemStatus status = [[change objectForKey:@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                [self play];
            }
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"加载失败");
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"未知资源");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array = playerItem.loadedTimeRanges;
        // 缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        [self updateVideoBufferProgress:totalBuffer];
    }else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        
    } else if ([keyPath isEqualToString:@"currentItem"]) {
       
    }
}

- (void)playFinished:(NSNotification *)notifi
{
    [self.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    [self pause];
}

- (void)play{
    [self.avPlayer play];
    
    self.controlView.playButton.hidden = YES;
    self.controlView.pauseButton.hidden = NO;
}

- (void)pause
{
    [self.avPlayer pause];
    self.controlView.playButton.hidden = NO;
    self.controlView.pauseButton.hidden = YES;
}

// 更新进度条时间
- (void)updateVideoSlider:(float)currentPlayTime
{
    CMTime duration = _playerItem.duration;
    self.controlView.timeLabel.text = [NSString stringWithFormat:@"%.0f:%.0f", currentPlayTime, CMTimeGetSeconds(duration)];
    self.controlView.playerSilder.finishValue = currentPlayTime / CMTimeGetSeconds(duration);
}

// 更新缓冲进度
- (void)updateVideoBufferProgress:(NSTimeInterval)buffer
{
    CMTime duration = _playerItem.duration;
    self.controlView.playerSilder.bufferValue = buffer / CMTimeGetSeconds(duration);
}

- (void)setupNotification {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        [self fullScreenButtonClick];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!_isFullScreen) {
        _shrinkRect = frame;
    }
}

- (void)fullScreenButtonClick {
    [self forceChangeOrientation:UIInterfaceOrientationLandscapeRight];
    self.controlView.fullScreenButton.hidden = YES;
    self.controlView.shrinkScreenButton.hidden = NO;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void)shrinkScreenButtonClick {
    
    [self forceChangeOrientation:UIInterfaceOrientationPortrait];
    self.controlView.fullScreenButton.hidden = NO;
    self.controlView.shrinkScreenButton.hidden = YES;
    self.frame = _shrinkRect;
}

/**
 *    强制横屏
 *
 *    @param orientation 横屏方向
 */
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark Notification Handler
/**
 *    屏幕旋转处理
 */
- (void)orientationHandler {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            _isFullScreen = YES;
            
        }else {
            _isFullScreen = NO;
        }
//        [self.controlView autoFadeOutControlBar];
    }else
    {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
            _isFullScreen = YES;
            
        }else
        {
            _isFullScreen = NO;
        }
    }
    
}

/**
 *    即将进入后台的处理
 */
- (void)applicationWillEnterForeground {
    [self play];
}

/**
 *    即将返回前台的处理
 */
- (void)applicationWillResignActive {
    [self pause];
}


- (void)dealloc
{
    [self removeObserver];
    // 注销通知
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.avPlayer = nil;
}
@end
