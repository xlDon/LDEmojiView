//
//  LDEmojiPageView.h
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDEmojiPageView;

@protocol LDEmojiPageViewDelegate <NSObject>

- (void)emojiPageView:(LDEmojiPageView *)emojiPageView didFinishPickingEmotion:(NSString *)emotion;

@end

@interface LDEmojiPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame emotions:(NSArray *)emotions;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSUInteger numberPerRow;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, weak) id<LDEmojiPageViewDelegate> delegate;

@end
