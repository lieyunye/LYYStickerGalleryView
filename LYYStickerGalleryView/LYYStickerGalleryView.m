//
//  LYYStickerGalleryView.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import "LYYStickerGalleryView.h"
#import "LYYStickerGalleryCategoryCell.h"
#import "LYYStickerHelper.h"

@interface LYYStickerGalleryView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *datalist;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation LYYStickerGalleryView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LYYStickerGalleryCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LYYStickerGalleryCategoryCell class])];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidSelectStickerNotificationString) name:DidSelectStickerNotificationString object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidStickerGalleryViewDismissNotificationString) name:DidStickerGalleryViewDismissNotificationString object:nil];
    
}

- (void)DidStickerGalleryViewDismissNotificationString
{
    [self removeFromSuperview];
    if (self.didDismissCallback) {
        self.didDismissCallback(NO);
    }
}

- (void)DidSelectStickerNotificationString
{
    [self removeFromSuperview];
    if (self.didDismissCallback) {
        self.didDismissCallback(YES);
    }
}

- (NSMutableArray *)datalist
{
    if (_datalist == nil) {
        _datalist = [[NSMutableArray alloc] initWithCapacity:0];
       
        if ([LYYStickerHelper sharedClient].emojis) {
            [_datalist addObject:[LYYStickerHelper sharedClient].emojis];
        }
    }
    if ([LYYStickerHelper sharedClient].recentStickerNames) {
        [_datalist removeObject:[LYYStickerHelper sharedClient].recentStickerNames];
        [_datalist insertObject:[LYYStickerHelper sharedClient].recentStickerNames atIndex:0];
    }
    return _datalist;
}


#pragma mark- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYYStickerGalleryCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LYYStickerGalleryCategoryCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    [cell configContent:self.datalist[indexPath.item]];
    return cell;
}


#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
