//
//  LYYStickerGalleryView.h
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYYStickerGalleryView : UIView
@property (nonatomic, copy) void (^didDismissCallback)(BOOL showSticker);

@end
