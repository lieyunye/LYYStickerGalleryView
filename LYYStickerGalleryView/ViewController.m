//
//  ViewController.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import "ViewController.h"
#import "LYYStickerGalleryView.h"
#import "LYYStickerHelper.h"
#import "LYYStickerGalleryView.h"
#import "ZoomRotatePanImageView.h"

@interface ViewController ()
@property (strong, nonatomic) LYYStickerGalleryView *stickerGalleryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAction:(id)sender {
    
    self.stickerGalleryView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LYYStickerGalleryView class]) owner:self options:nil].firstObject;
    self.stickerGalleryView.frame = self.view.bounds;
    __weak typeof(self) weakSelf = self;
    self.stickerGalleryView.didDismissCallback = ^(BOOL showSticker, LYYStickerModel *stickerModel){
        if (showSticker) {
            [weakSelf addStickerViewWithStickerModel:stickerModel];
        }else {
            weakSelf.stickerGalleryView = nil;
        }
    };
    if ([LYYStickerHelper sharedClient].emojis) {
        if (self.stickerGalleryView.superview) {
            [self.stickerGalleryView removeFromSuperview];
        }else {
            [self.view addSubview:self.stickerGalleryView];
        }
    }else {
        NSLog(@"数据加载中...请稍候");
    }
    
}


- (void)addStickerViewWithStickerModel:(LYYStickerModel *)stickerModel
{
    self.stickerGalleryView = nil;
    ZoomRotatePanImageView *stickerView = [[ZoomRotatePanImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    stickerView.backgroundColor = [UIColor redColor];
    UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    emojiLabel.text = [LYYStickerHelper sharedClient].recentStickerNames.firstObject;
    emojiLabel.font = [UIFont systemFontOfSize:17];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    UIImage *resultImage = nil;
    UIGraphicsBeginImageContextWithOptions(emojiLabel.frame.size, NO, 0.0);
    [emojiLabel drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(emojiLabel.frame), CGRectGetHeight(emojiLabel.frame)) afterScreenUpdates:YES];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    stickerView.image = resultImage;
    [self.view addSubview:stickerView];
    stickerView.center = stickerModel.position;
}
@end
