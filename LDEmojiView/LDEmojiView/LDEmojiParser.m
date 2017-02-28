//
//  LDEmojiParser.m
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import "LDEmojiParser.h"
#import "LDEmojiObject.h"

@interface LDEmojiParser ()

@property (nonatomic, strong) NSMutableCharacterSet *emojiCharacterSet;
@property (nonatomic, strong) NSMutableCharacterSet *emojiDesCharacterSet;
@property (nonatomic, strong) LDEmojiObject *emojiObject;
@property (nonatomic, strong) NSDictionary *emojiDictionary;
@property (nonatomic, strong) NSDictionary *iEmojiDictionary;
@property (nonatomic, strong) NSArray *emotionData;

@end

@implementation LDEmojiParser

+ (instancetype)sharedInstance
{
    static LDEmojiParser *g_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = [[LDEmojiParser alloc] init];
    });
    return g_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupEmojiCharset];
        _emojiObject = [[LDEmojiObject alloc] init];
    }
    return self;
}

// emoji的编码，可以自己增添，记得解析字典也要改
- (NSArray *)emotionData
{
    if (!_emotionData)
    {
        _emotionData = [NSArray arrayWithObjects:@"\U0001f60a",@"\U0001f602",@"\U0001f603",@"\U0001f610",@"\U0001f604",@"\U0001f60d",@"\U0001f60e",@"\U0001f61b",@"\U0001f61c",@"\U0001f61d",@"\U0001f607",@"\U0001f608",@"\U0001f609",@"\U0001f611",@"\U0001f612",@"\U0001f613",@"\U0001f614",@"\U0001f62a",@"\U0001f62b",@"\U0001f62d",@"\U0001f617",@"\U0001f618",@"\U0001f619",@"\U0001f620",@"\U0001f621",@"\U0001f622",@"\U0001f623",@"\U0001f624",@"\U0001f625",@"\U0001f626",@"\U0001f627",@"\U0001f628",@"\U0001f629",@"\U0001f630",@"\U0001f631",@"\U0001f632",@"\U0001f633",@"\U0001f634",@"\U0001f635",@"\U0001f636",@"\U0001f637",@"\U0001f60b",@"\U0001f615",@"\U0001f616",@"\U0001f62c",@"\U0001f60f",@"\U0001f61e",@"\U0001f61f",@"\U0001f62e",@"\U0001f62f",@"\U0001f605",@"\U0001f61a", nil];
    }
    return _emotionData;
}

- (NSArray *)emojis
{
    return [self emotionData];
}

- (void)setupEmojiCharset
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
        for ( NSString * key in self.emotionData)
        {
            [_emojiCharacterSet addCharactersInString:key];
        }
        
        _emojiDesCharacterSet = [[NSMutableCharacterSet alloc] init];
        for (NSString *key in self.iEmojiDictionary.allKeys)
        {
            [_emojiDesCharacterSet addCharactersInString:key];
        }
    });
}

- (NSString *)encodeEmojiText:(NSString *)emojiText
{
    if (emojiText.length == 0)
    {
        return emojiText;
    }
    NSMutableString *result = [emojiText mutableCopy];
    NSRange range = [result rangeOfCharacterFromSet:_emojiCharacterSet options:NSLiteralSearch range:NSMakeRange(0, result.length)];
    while (range.location != NSNotFound) {
        NSString *emoji = [result substringWithRange:range];
        NSString *emojiString = [self.emojiDictionary objectForKey:emoji];
        if (emojiString)
        {
            [result replaceCharactersInRange:range withString:emojiString];
        } else {
            [result replaceCharactersInRange:range withString:@""];
        }
        range = [result rangeOfCharacterFromSet:_emojiCharacterSet options:NSLiteralSearch range:NSMakeRange(0, result.length)];
    }
    return result;
}

- (NSString *)decodeEmojiText:(NSString *)text
{
    if (text.length == 0)
    {
        return text;
    }
    
    NSString *result = text;
    NSMutableString *emojiString = [[NSMutableString alloc] init];
    NSUInteger length = text.length;
    BOOL inTag = NO;
    int position = 0;
    do{
        NSString *c = [text substringWithRange:NSMakeRange(position, 1)];
        if (!inTag && [c isEqualToString:LDEMOJI_START_CHAR])
        {
            emojiString = [[NSMutableString alloc] init];
            inTag = true;
        }
        
        if (inTag)
        {
            [emojiString appendString:c];
            if ([c isEqualToString:LDEMOJI_END_CHAR])
            {
                inTag = false;
                
                NSString *emoji = [self.iEmojiDictionary objectForKey:emojiString];
                if (emoji)
                {
                    result = [result stringByReplacingOccurrencesOfString:emojiString withString:emoji];
                }
                else
                {
                    if ([_emojiObject decodeEmojiText:emojiString])
                    {
                        result = [result stringByReplacingOccurrencesOfString:emojiString withString:_emojiObject.des];
                    }
                }
            }
        }
        position++;
        
    } while (position < length);
    
    return result;
}

- (NSDictionary *)emojiDictionary
{
    if (!_emojiDictionary) {
        _emojiDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"[高兴|1f60a]",@"\U0001f60a",
                            @"[妙|1f60b]",@"\U0001f60b",
                            @"[思考|1f60c]",@"\U0001f60c",
                            @"[爱你|1f60d]",@"\U0001f60d",
                            @"[酷|1f60e]",@"\U0001f60e",
                            @"[假笑一下|1f60f]",@"\U0001f60f",
                            @"[亲一下|1f61a]",@"\U0001f61a",
                            @"[吐舌|1f61b]",@"\U0001f61b",
                            @"[鬼脸|1f61c]",@"\U0001f61c",
                            @"[闭眼|1f61d]",@"\U0001f61d",
                            @"[失望|1f61e]",@"\U0001f61e",
                            @"[发呆|1f61f]",@"\U0001f61f",
                            @"[好困|1f62a]",@"\U0001f62a",
                            @"[好烦|1f62b]",@"\U0001f62b",
                            @"[微笑|1f62c]",@"\U0001f62c",
                            @"[大哭|1f62d]",@"\U0001f62d",
                            @"[啊|1f62e]",@"\U0001f62e",
                            @"[嘘|1f62f]",@"\U0001f62f",
                            @"[微笑|1f601]",@"\U0001f601",
                            @"[大哭|1f602]",@"\U0001f602",
                            @"[开心|1f603]",@"\U0001f603",
                            @"[哈哈|1f604]",@"\U0001f604",
                            @"[呵呵|1f605]",@"\U0001f605",
                            @"[闭眼|1f606]",@"\U0001f606",
                            @"[我是无辜的|1f607]",@"\U0001f607",
                            @"[恶魔|1f608]",@"\U0001f608",
                            @"[眨眼|1f609]",@"\U0001f609",
                            @"[不开心|1f610]",@"\U0001f610",
                            @"[闭嘴|1f611]",@"\U0001f611",
                            @"[思考ing|1f612]",@"\U0001f612",
                            @"[汗颜|1f613]",@"\U0001f613",
                            @"[深思中|1f614]",@"\U0001f614",
                            @"[困惑|1f615]",@"\U0001f615",
                            @"[困惑|1f616]",@"\U0001f616",
                            @"[亲一口|1f617]",@"\U0001f617",
                            @"[爱你|1f618]",@"\U0001f618",
                            @"[亲亲|1f619]",@"\U0001f619",
                            @"[怒了|1f620]",@"\U0001f620",
                            @"[大怒|1f621]",@"\U0001f621",
                            @"[冷汗|1f622]",@"\U0001f622",
                            @"[坚持|1f623]",@"\U0001f623",
                            @"[凯旋而归|1f624]",@"\U0001f624",
                            @"[冒汗|1f625]",@"\U0001f625",
                            @"[皱眉|1f626]",@"\U0001f626",
                            @"[好痛苦|1f627]",@"\U0001f627",
                            @"[好害怕|1f628]",@"\U0001f628",
                            @"[好烦|1f629]",@"\U0001f629",
                            @"[真糟糕|1f630]",@"\U0001f630",
                            @"[好恐怖|1f631]",@"\U0001f631",
                            @"[惊讶|1f632]",@"\U0001f632",
                            @"[脸红了|1f633]",@"\U0001f633",
                            @"[困了|1f634]",@"\U0001f634",
                            @"[吃惊|1f635]",@"\U0001f635",
                            @"[闭嘴|1f636]",@"\U0001f636",
                            @"[生病了|1f637]",@"\U0001f637",nil];
    }
    
    return _emojiDictionary;
}

- (NSDictionary *)iEmojiDictionary
{
    if (!_iEmojiDictionary)
    {
        _iEmojiDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"\U0001f60a", @"[高兴|1f60a]",
                             @"\U0001f60b", @"[妙|1f60b]",
                             @"\U0001f60c", @"[思考|1f60c]",
                             @"\U0001f60d", @"[爱你|1f60d]",
                             @"\U0001f60e", @"[酷|1f60e]",
                             @"\U0001f60f", @"[假笑一下|1f60f]",
                             @"\U0001f61a", @"[亲一下|1f61a]",
                             @"\U0001f61b", @"[吐舌|1f61b]",
                             @"\U0001f61c", @"[鬼脸|1f61c]",
                             @"\U0001f61d", @"[闭眼|1f61d]",
                             @"\U0001f61e", @"[失望|1f61e]",
                             @"\U0001f61f", @"[发呆|1f61f]",
                             @"\U0001f62a", @"[好困|1f62a]",
                             @"\U0001f62b", @"[好烦|1f62b]",
                             @"\U0001f62c", @"[微笑|1f62c]",
                             @"\U0001f62d", @"[大哭|1f62d]",
                             @"\U0001f62e", @"[啊|1f62e]",
                             @"\U0001f62f", @"[嘘|1f62f]",
                             @"\U0001f601", @"[微笑|1f601]",
                             @"\U0001f602", @"[大哭|1f602]",
                             @"\U0001f603", @"[开心|1f603]",
                             @"\U0001f604", @"[哈哈|1f604]",
                             @"\U0001f605", @"[呵呵|1f605]",
                             @"\U0001f606", @"[闭眼|1f606]",
                             @"\U0001f607", @"[我是无辜的|1f607]",
                             @"\U0001f608", @"[恶魔|1f608]",
                             @"\U0001f609", @"[眨眼|1f609]",
                             @"\U0001f610", @"[不开心|1f610]",
                             @"\U0001f611", @"[闭嘴|1f611]",
                             @"\U0001f612", @"[思考ing|1f612]",
                             @"\U0001f613", @"[汗颜|1f613]",
                             @"\U0001f614", @"[深思中|1f614]",
                             @"\U0001f615", @"[困惑|1f615]",
                             @"\U0001f616", @"[困惑|1f616]",
                             @"\U0001f617", @"[亲一口|1f617]",
                             @"\U0001f618", @"[爱你|1f618]",
                             @"\U0001f619", @"[亲亲|1f619]",
                             @"\U0001f620", @"[怒了|1f620]",
                             @"\U0001f621", @"[大怒|1f621]",
                             @"\U0001f622", @"[冷汗|1f622]",
                             @"\U0001f623", @"[坚持|1f623]",
                             @"\U0001f624", @"[凯旋而归|1f624]",
                             @"\U0001f625", @"[冒汗|1f625]",
                             @"\U0001f626", @"[皱眉|1f626]",
                             @"\U0001f627", @"[好痛苦|1f627]",
                             @"\U0001f628", @"[好害怕|1f628]",
                             @"\U0001f629", @"[好烦|1f629]",
                             @"\U0001f630", @"[真糟糕|1f630]",
                             @"\U0001f631", @"[好恐怖|1f631]",
                             @"\U0001f632", @"[惊讶|1f632]",
                             @"\U0001f633", @"[脸红了|1f633]",
                             @"\U0001f634", @"[困了|1f634]",
                             @"\U0001f635", @"[吃惊|1f635]",
                             @"\U0001f636", @"[闭嘴|1f636]",
                             @"\U0001f637", @"[生病了|1f637]", nil];
        
    }
    return _iEmojiDictionary;
}

@end
