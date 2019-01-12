//
//  ResultViewController.m
//  FFMpeg_iOS
//
//  Created by 聂宽 on 2019/1/11.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultViewCell.h"

@interface ResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;
@end
static NSString *const ResultViewCellID = @"ResultViewCell";
@implementation ResultViewController
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[ResultViewCell class] forCellWithReuseIdentifier:ResultViewCellID];
    }
    return _collectionView;
}

- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        _dataArr = [fileManager contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] error:nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.view.backgroundColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResultViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ResultViewCellID forIndexPath:indexPath];
    NSString *imgName = self.dataArr[indexPath.item];
    cell.imgView.image = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:imgName]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - 2 * 4) / 3;
    return CGSizeMake(itemW, itemW);
}
@end
