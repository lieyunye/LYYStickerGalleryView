//
//  LYYEmojiUtil.m
//  LYYStickerGalleryView
//
//  Created by lieyunye on 2017/3/8.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

#import "LYYEmojiUtil.h"

@interface UIKeyboardEmojiCategory : NSObject
+ (id)categoryForType:(int)arg1;
+ (id)enabledCategoryIndexes;
+ (int)numberOfCategories;

@end


@implementation LYYEmojiUtil

+ (NSArray *)emojis
{
    NSMutableArray *allEmojis = [NSMutableArray arrayWithCapacity:0];
    
    Class UIKeyboardEmojiCategoryClass = NSClassFromString(@"UIKeyboardEmojiCategory");
    NSMutableArray *categoryIndexes = [NSMutableArray array];
    if ([UIKeyboardEmojiCategoryClass respondsToSelector:@selector(enabledCategoryIndexes)]) {
        NSArray *enabledCategoryIndexes = [UIKeyboardEmojiCategoryClass enabledCategoryIndexes];
        [categoryIndexes setArray:enabledCategoryIndexes];
    }else if ([UIKeyboardEmojiCategoryClass respondsToSelector:@selector(numberOfCategories)]){
        int numberOfCategories = [UIKeyboardEmojiCategoryClass numberOfCategories];
        for (int index = 0 ; index < numberOfCategories; index ++){
            [categoryIndexes addObject:@(index)];
        }
    }
    for (NSNumber *index in categoryIndexes) {
        NSMutableDictionary *emojisAndCategoryName = [NSMutableDictionary dictionaryWithCapacity:0];
        id keyboardEmojiCategoryType = [UIKeyboardEmojiCategoryClass categoryForType:index.intValue];
        
        //name
        NSString *name = nil;
        if ([keyboardEmojiCategoryType respondsToSelector:@selector(name)]) {
            name = [keyboardEmojiCategoryType performSelector:@selector(name)];
        }
        if (!name || [name isEqualToString:@"UIKeyboardEmojiCategoryRecent"]){
            continue;
        }
        
        NSArray *emojis = nil;
        if ([keyboardEmojiCategoryType respondsToSelector:@selector(emoji)]) {
            emojis = [keyboardEmojiCategoryType performSelector:@selector(emoji)];
        }

        NSMutableArray *emojisInCate = [NSMutableArray array];
        for (id item in emojis) {
            
            NSString *key = [item performSelector:@selector(key)];
            if (key.length < 1) {
                continue;
            }
            [emojisInCate addObject:key];
            NSLog(@"cateName %@  emojis %@   %lu",name,key,(unsigned long)key.length);
        }
        
        [emojisAndCategoryName setValue:emojisInCate forKey:name];
        [allEmojis addObject:emojisAndCategoryName];
    }
    
    return allEmojis;
}

@end
