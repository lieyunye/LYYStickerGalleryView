//
//  LYYStickerGalleryCategoryCell.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2016/12/13.
//  Copyright © 2016年 lieyunye. All rights reserved.
//

#import "LYYStickerGalleryCategoryCell.h"
#import "LYYStickerGalleryStickerCell.h"
#import "LYYStickerHelper.h"

@interface  LYYStickerGalleryCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *datalist;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat panOffsetY;
@property (nonatomic, assign) CGFloat scrollViewOffsetY;
@property (nonatomic, assign) BOOL panToDismiss;
@property (nonatomic, assign) NSInteger state;

@end

@implementation LYYStickerGalleryCategoryCell
- (void)configContent:(id)content
{
    self.datalist = content;
    [self.collectionView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LYYStickerGalleryStickerCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LYYStickerGalleryStickerCell class])];
    [self.collectionView.panGestureRecognizer addTarget:self action:@selector(scrollPanGesture:)];
}


- (void)scrollPanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    CGFloat scrollViewOffsetY = self.collectionView.contentOffset.y;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.panOffsetY = point.y;
            self.scrollViewOffsetY = scrollViewOffsetY;
            self.state = 0;
        case UIGestureRecognizerStateChanged:
        {
            float velocityY = [gesture velocityInView:gesture.view].y;
            if (velocityY > 0 && self.state == 0) {
                self.panToDismiss = YES;
                self.state = 1;
            }else {
                self.state = 1;
            }
            
            if (self.panToDismiss) {
                CGRect frame = self.collectionView.frame;
                frame.origin.y = point.y - self.panOffsetY;
                if (self.collectionView.contentOffset.y <= 0) {
                    self.collectionView.frame = frame;
                    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, 0);
                }
                if (self.collectionView.frame.origin.y > 0) {
                    self.collectionView.frame = frame;
                    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, 0);
                }
                
                if (self.collectionView.frame.origin.y < 0) {
                    frame.origin.y = 0;
                    self.collectionView.frame = frame;
                }
            }
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.panToDismiss) {
                CGFloat finalY = 0;
                if (self.collectionView.frame.origin.y > CGRectGetHeight(self.bounds) / 2.0) {
                    finalY = CGRectGetHeight(self.bounds);
                }
                NSTimeInterval duration = 0.3;
                [UIView animateWithDuration:duration
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     CGRect frame = self.collectionView.frame;
                                     frame.origin.y = finalY;
                                     self.collectionView.frame= frame;
                                 }
                                 completion:^(BOOL finished) {
                                     if (self.collectionView.frame.origin.y != 0) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:DidStickerGalleryViewDismissNotificationString object:nil];

                                     }
                                 }];

            }
            self.panToDismiss = NO;
            
        }
            break;
        default:
            break;
    }
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
    LYYStickerGalleryStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LYYStickerGalleryStickerCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    [cell configContent:self.datalist[indexPath.item]];
    return cell;
}


#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[LYYStickerHelper sharedClient] addRecentEmoji:self.datalist[indexPath.item]];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectStickerNotificationString object:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.bounds) / 4.0;
    return CGSizeMake(width, width);
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
