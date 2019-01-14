//
//  ViewController.m
//  FFMpeg_iOS
//
//  Created by 聂宽 on 2019/1/11.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "ViewController.h"
#import "ffmpeg.h"
#import "ResultViewController.h"
#import "NKAVPlayerView.h"

@interface ViewController ()
@property (nonatomic, strong) NKAVPlayerView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat palyerW = [UIScreen mainScreen].bounds.size.width;
    NKAVPlayerView *playerView = [[NKAVPlayerView alloc] init];
    _playerView = playerView;
    playerView.frame = CGRectMake(0, 0, palyerW, palyerW / 7 * 4);

    [self.view addSubview:playerView];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
}

- (IBAction)converterBtnAction:(UIButton *)sender {
    sender.enabled = NO;
    [sender setTitle:@"ing" forState:UIControlStateNormal];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSString *imageName = @"image%d.jpg";
        NSString *imagesPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], imageName];
        
        int numberOfArgs = 6;
        char** arguments = calloc(numberOfArgs, sizeof(char*));
        
        arguments[0] = "ffmpeg";
        arguments[1] = "-i";
        arguments[2] = (char *)[moviePath UTF8String];
        arguments[3] = "-r";
        arguments[4] = "20";
        arguments[5] = (char *)[imagesPath UTF8String];
        
        int result = ffmpeg_main(numberOfArgs, arguments);
        NSLog(@"----------- %d", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [sender setTitle:@"Converter" forState:UIControlStateNormal];
            [self presentViewController:[[ResultViewController alloc] init] animated:YES completion:^{
                
            }];
        });
        
    });
    
}

@end
