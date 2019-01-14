//
//  NKAVPlayerControlView.m
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "NKAVPlayerControlView.h"

#define TopMenuH 40
#define BotMenuH 50
#define ImageWithName(imgStr)  [UIImage imageNamed:[NSString stringWithFormat:@"%@", imgStr]]
@interface NKAVPlayerControlView()
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerIndex;
@end

@implementation NKAVPlayerControlView
- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TopMenuH)];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BotMenuH, self.frame.size.width, BotMenuH)];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:ImageWithName(@"btn_player_pause") forState:UIControlStateNormal];
        _playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _playButton.bounds = CGRectMake(0, 0, TopMenuH, TopMenuH);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
        _pauseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _pauseButton.bounds = CGRectMake(0, 0, TopMenuH, TopMenuH);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, TopMenuH, TopMenuH);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, TopMenuH, TopMenuH);
    }
    return _shrinkScreenButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _closeButton.bounds = CGRectMake(0, 0, TopMenuH * 4, TopMenuH);
    }
    return _closeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, TopMenuH, TopMenuH);
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

- (NKAVPlayerSilder *)playerSilder
{
    if (_playerSilder == nil) {
        _playerSilder = [[NKAVPlayerSilder alloc] init];
        _playerSilder.finishValue = 0;
    }
    return _playerSilder;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLab];
        [self.topView addSubview:self.closeButton];
        
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.playButton];
        [self.bottomView addSubview:self.pauseButton];
        [self.bottomView addSubview:self.fullScreenButton];
        [self.bottomView addSubview:self.shrinkScreenButton];
        [self.bottomView addSubview:self.timeLabel];
        [self.bottomView addSubview:self.playerSilder];
        self.menuShow = YES;
        self.timerIndex = 0;
        [self.timer fire];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlViewTapGRAction:)];
        [self addGestureRecognizer:tapGR];
        
        self.playButton.hidden = YES;
        self.shrinkScreenButton.hidden = YES;
    }
    return self;
}

- (void)timerRunAction
{
    self.timerIndex++;
    if (self.timerIndex == 3) {
        self.timerIndex = 0;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self hideAnimate];
    }
}

- (void)hideAnimate
{
    if (_isAnimate) {
        return;
    }
    self.timerIndex = 0;
    _isAnimate = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.frame = CGRectMake(0, -CGRectGetHeight(self.topView.frame), CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame));
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), CGRectGetWidth(self.bottomView.frame), CGRectGetHeight(self.bottomView.frame));
    } completion:^(BOOL finished) {
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.menuShow = NO;
        _isAnimate = NO;
    }];
}

- (void)showAnimate
{
    if (_isAnimate) {
        return;
    }
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    _isAnimate = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.frame = CGRectMake(0, 0, self.frame.size.width, TopMenuH);
        self.bottomView.frame = CGRectMake(0, self.frame.size.height - BotMenuH, self.frame.size.width, BotMenuH);
    } completion:^(BOOL finished) {
        self.menuShow = YES;
        _isAnimate = NO;
        [self.timer setFireDate:[NSDate distantPast]];
    }];
}

- (void)controlViewTapGRAction:(UITapGestureRecognizer *)tapGR
{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timerIndex = 0;
    if (tapGR.numberOfTapsRequired == 1) {
        if (self.menuShow) {
            [self hideAnimate];
        }else
        {
            [self showAnimate];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat viewW = self.frame.size.width;
    self.topView.frame = CGRectMake(0, 0, self.frame.size.width, TopMenuH);
    self.closeButton.frame = CGRectMake(10, CGRectGetMinX(self.topView.bounds), CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.closeButton.frame) - 3 * TopMenuH, CGRectGetMinX(self.topView.bounds), viewW - CGRectGetMaxX(self.closeButton.frame), TopMenuH);
    
    self.bottomView.frame = CGRectMake(0, self.frame.size.height - BotMenuH, self.frame.size.width, BotMenuH);
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomView.bounds) + 10, CGRectGetHeight(self.bottomView.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame   = CGRectMake(CGRectGetWidth(self.bottomView.bounds) - CGRectGetWidth(self.fullScreenButton.bounds) - 10, self.playButton.frame.origin.y, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.fullScreenButton.frame) - 60, self.playButton.frame.origin.y, 60, CGRectGetHeight(self.timeLabel.bounds));
    self.playerSilder.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), (CGRectGetHeight(self.bottomView.frame) - BotMenuH) * 0.5, CGRectGetMinX(self.timeLabel.frame) - CGRectGetMaxX(self.playButton.frame) - 5, BotMenuH);
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
@end
