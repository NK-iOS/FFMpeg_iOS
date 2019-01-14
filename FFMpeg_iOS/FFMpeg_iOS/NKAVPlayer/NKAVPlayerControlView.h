//
//  NKAVPlayerControlView.h
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKAVPlayerSilder.h"

@interface NKAVPlayerControlView : UIView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) NKAVPlayerSilder *playerSilder;

@property (nonatomic, strong) UIView *bottomView;

// 是否锁屏
@property (nonatomic, assign) BOOL isLock;
// 菜单是否显示
@property (nonatomic, assign) BOOL menuShow;
@end
