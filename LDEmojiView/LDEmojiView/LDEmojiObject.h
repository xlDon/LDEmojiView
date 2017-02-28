//
//  LDEmojiObject.h
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LDEMOJI_START_CHAR;
extern NSString * const LDEMOJI_END_CHAR;
extern NSString * const LDEMOJI_MID_CHAR;

@interface LDEmojiObject : NSObject

@property (nonatomic, strong) NSString *name;   ///<[smile]
@property (nonatomic, strong) NSString *des;    ///<[微笑]

/**
 * 解析emoji，传入格式是 [微笑|smile]
 * @param text 传入的数据
 * @return 格式正确，解析成功，返回true， 否则，返回false
 */
- (BOOL)decodeEmojiText:(NSString *)text;

@end
