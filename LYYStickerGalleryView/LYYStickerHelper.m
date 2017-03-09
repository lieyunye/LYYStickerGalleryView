//
//  LYYStickerHelper.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import "LYYStickerHelper.h"
#import "LYYEmojiUtil.h"

@interface LYYStickerHelper ()
@end

@implementation LYYStickerHelper
+ (instancetype)sharedClient
{
    static LYYStickerHelper *_sharedClient = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _sharedClient = [[LYYStickerHelper alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadEmojis];
    }
    return self;
}

- (void)addRecentEmoji:(NSString *)emojiName
{
    if (emojiName) {
        if ([_recentStickerNames containsObject:emojiName]) {
            [_recentStickerNames removeObject:emojiName];
        }
        [_recentStickerNames insertObject:emojiName atIndex:0];
        [self saveRecentEmojis];
    }
}

- (void)saveRecentEmojis
{
    [_recentStickerNames writeToFile:[self recentEmojiFilePath] atomically:YES];
}

- (NSString *)recentEmojiFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/recentStickerNames.plist",paths.firstObject];
    return path;
}

- (void)loadEmojis
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _recentStickerNames = [[NSMutableArray alloc] initWithContentsOfFile:[self recentEmojiFilePath]];
        if (_recentStickerNames == nil) {
            _recentStickerNames = [[NSMutableArray alloc] initWithCapacity:0];
        }
        self.emojis = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *item in [LYYEmojiUtil emojis] ) {
            [self.emojis addObjectsFromArray:[item allValues].firstObject];
        }
    });
}
@end
