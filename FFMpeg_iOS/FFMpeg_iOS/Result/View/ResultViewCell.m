//
//  ResultViewCell.m
//  FFMpeg_iOS
//
//  Created by 聂宽 on 2019/1/11.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "ResultViewCell.h"

@implementation ResultViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        _imgView.frame = self.bounds;
    }
    return self;
}
@end
