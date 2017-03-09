//
//  LYYStickerGalleryStickerCell.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2016/12/13.
//  Copyright © 2016年 lieyunye. All rights reserved.
//

#import "LYYStickerGalleryStickerCell.h"

@interface LYYStickerGalleryStickerCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LYYStickerGalleryStickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configContent:(id)content
{
    if ([content isKindOfClass:[NSString class]]) {
        self.label.text = content;
        self.label.hidden = NO;
        self.imageView.hidden = YES;
    }else {
        self.imageView.image = content;
        self.imageView.hidden = NO;
        self.label.hidden = YES;
    }
}

@end
