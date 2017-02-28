//
//  LDEmojiView.h
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDEmojiView;
@protocol LDEmojiViewDelegate <NSObject>

- (void)emojiView:(LDEmojiView *)emojiView didFinishPickingEmotion:(NSString *)emotion;

@optional
- (void)emojiView:(LDEmojiView *)emojiView didChangePageIndex:(NSInteger)pageIndex;

@end

@interface LDEmojiView : UIView

@property (nonatomic) IBInspectable NSUInteger numberPerRow;
@property (nonatomic) IBInspectable NSUInteger numberPerPage;
@property (nonatomic) IBInspectable CGSize itemSize;
@property (nonatomic) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, strong) UIFont *font;

// 此处可以在storyboard或xib直接拖delegate
@property (nonatomic, weak) IBOutlet id<LDEmojiViewDelegate> delegate;

- (NSUInteger)pageNumber;

@end
