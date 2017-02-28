//
//  LDEmojiParser.h
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDEmojiParser : NSObject

@property (nonatomic, readonly) NSArray *emojis;

+ (instancetype)sharedInstance;

/// 把收到的表情字符转为表情 比如 [小鸡|chicken]  输出 🐤
- (NSString *)decodeEmojiText:(NSString *)text;

/// 把输入的表情转为协议编码 比如🐤 出来结果就是[小鸡|chicken]
- (NSString *)encodeEmojiText:(NSString *)emojiText;

@end
