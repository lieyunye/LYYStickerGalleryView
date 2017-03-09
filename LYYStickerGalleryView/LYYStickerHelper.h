//
//  LYYStickerHelper.h
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DidSelectStickerNotificationString = @"DidSelectStickerNotificationString";
static NSString *DidStickerGalleryViewDismissNotificationString = @"DidStickerGalleryViewDismissNotificationString";


@interface LYYStickerHelper : NSObject
@property (nonatomic, strong) NSMutableArray *recentStickerNames;
@property (nonatomic, strong) NSMutableArray *emojis;


+ (instancetype)sharedClient;
- (void)addRecentEmoji:(NSString *)emojiName;

@end
