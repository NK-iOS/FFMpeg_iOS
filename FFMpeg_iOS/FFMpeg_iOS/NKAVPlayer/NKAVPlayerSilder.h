//
//  NKAVPlayerSilder.h
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapChangeValue)(float value);
@interface NKAVPlayerSilder : UIView
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *bufferView;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) UIImageView *slipImgView;

@property (nonatomic, assign) float bufferValue;
@property (nonatomic, assign) float finishValue;

@property (nonatomic, copy) TapChangeValue tapChangeValue;
@end
