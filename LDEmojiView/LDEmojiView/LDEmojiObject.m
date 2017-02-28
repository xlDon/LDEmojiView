//
//  LDEmojiObject.m
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import "LDEmojiObject.h"

NSString * const LDEMOJI_START_CHAR = @"[";
NSString * const LDEMOJI_END_CHAR = @"]";
NSString * const LDEMOJI_MID_CHAR = @"|";

@implementation LDEmojiObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _name = @"";
        _des = @"";
    }
    return self;
}

- (BOOL)decodeEmojiText:(NSString *)text
{
    if ([text rangeOfString:LDEMOJI_MID_CHAR].location != NSNotFound)
    {
        NSArray *strArray = [text componentsSeparatedByString:LDEMOJI_MID_CHAR];
        if (strArray.count == 2)
        {
            self.des = [[strArray objectAtIndex:0] stringByAppendingString:LDEMOJI_END_CHAR];
            self.name = [LDEMOJI_START_CHAR stringByAppendingString:[strArray objectAtIndex:1]];
            return YES;
        }
    }
    
    return NO;
}

@end
