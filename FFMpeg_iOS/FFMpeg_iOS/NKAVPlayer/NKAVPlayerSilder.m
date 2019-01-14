//
//  NKAVPlayerSilder.m
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "NKAVPlayerSilder.h"

#define SilderH 3
#define SlipW 10
@implementation NKAVPlayerSilder

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor grayColor];
        _baseView.frame = CGRectMake(0, (self.frame.size.height - SilderH) / 2, self.frame.size.width, SilderH);
        _baseView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return _bufferView;
}

- (UIView *)bufferView
{
    if (_bufferView == nil) {
        _bufferView = [[UIView alloc] init];
        _bufferView.backgroundColor = [UIColor grayColor];
        _bufferView.frame = CGRectMake(0, (self.frame.size.height - SilderH) / 2, 0, SilderH);
    }
    return _bufferView;
}

- (UIView *)finishView
{
    if (_finishView == nil) {
        _finishView = [[UIView alloc] init];
        _finishView.backgroundColor = [UIColor orangeColor];
        _finishView.frame = CGRectMake(0,(self.frame.size.height - SilderH) / 2, 0, SilderH);
    }
    return _finishView;
}

- (UIImageView *)slipImgView
{
    if (_slipImgView == nil) {
        _slipImgView = [[UIImageView alloc] init];
        _slipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _slipImgView.image = [UIImage imageNamed:@"btn_player_slider_thumb"];
        _slipImgView.frame = CGRectMake(0, (self.frame.size.height - SlipW) * 0.5, SlipW, SlipW);
        _slipImgView.userInteractionEnabled = YES;
    }
    return _slipImgView;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.bufferView];
        [self addSubview:self.finishView];
        [self addSubview:self.slipImgView];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)tapGRAction:(UITapGestureRecognizer *)tapGR
{
    CGPoint touchPoint = [tapGR locationInView:self];
    
    if (self.tapChangeValue) {
        self.tapChangeValue(touchPoint.x / self.frame.size.width);
        self.finishValue = touchPoint.x / self.frame.size.width;
    }
}

- (void)setBufferValue:(float)bufferValue
{
    _bufferValue = bufferValue;
    self.bufferView.frame = CGRectMake(0, (self.frame.size.height - SilderH) / 2, self.frame.size.width * (bufferValue / 1.0), CGRectGetHeight(self.bufferView.frame));
}

- (void)setFinishValue:(float)finishValue
{
    _finishValue = finishValue;
    CGFloat finishW = self.frame.size.width * finishValue;
    self.finishView.frame = CGRectMake(0, (self.frame.size.height - SilderH) / 2, finishW, CGRectGetHeight(self.finishView.frame));
    self.slipImgView.frame = CGRectMake(finishW - SlipW * 0.5, (self.frame.size.height - SlipW) * 0.5, SlipW, SlipW);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.baseView.frame = CGRectMake(0, (self.frame.size.height - SilderH) / 2, self.frame.size.width, SilderH);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    NSLog(@"-------- %@", NSStringFromCGPoint(locationPoint));
    if (locationPoint.x == 0) {
        return;
    }
    self.finishValue = locationPoint.x / self.frame.size.width;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    if (locationPoint.x == 0) {
        return;
    }
    self.finishValue = locationPoint.x / self.frame.size.width;
    if (self.tapChangeValue) {
        self.tapChangeValue(locationPoint.x / self.frame.size.width);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
