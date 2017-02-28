//
//  LDEmojiPageView.m
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import "LDEmojiPageView.h"
#import "LDZoomAnimationButton.h"

@interface LDEmojiPageView ()

@property (nonatomic, strong) NSArray *emotions;
@property (nonatomic, strong) NSArray *emojiItems;

@end

@implementation LDEmojiPageView

- (instancetype)initWithFrame:(CGRect)frame emotions:(NSArray *)emotions
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _emotions = emotions;
        _numberPerRow = 7;
        _itemHeight = 40;
    }
    return self;
}

- (void)dealloc
{
    for (LDZoomAnimationButton *button in self.emojiItems)
    {
        [button removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    }
}

- (NSArray *)emojiItems
{
    if (!_emojiItems)
    {
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.emotions.count];
        for (NSString *emotion in self.emotions)
        {
            LDZoomAnimationButton *button = [[LDZoomAnimationButton alloc] init];
            button.titleLabel.font = self.font;
            [button setTitle:emotion forState:UIControlStateNormal];
            [button sizeToFit];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [list addObject:button];
            [self addSubview:button];
        }
        
        _emojiItems = list;
    }
    return _emojiItems;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemWidth = self.bounds.size.width / self.numberPerRow;
    CGFloat halfWidth = itemWidth / 2;
    CGFloat halfHeight = self.itemHeight / 2;
    
    __block CGFloat pageLeft = 0;
    __block CGPoint center = CGPointMake(halfWidth, halfHeight);
    
    [self.emojiItems enumerateObjectsUsingBlock:^(LDZoomAnimationButton *button, NSUInteger idx, BOOL *stop) {
        button.center = center;
        
        if ((idx + 1) % self.numberPerRow == 0)
        {
            center.x = pageLeft + halfWidth;
            center.y += self.itemHeight;
        }
        else
        {
            center.x += itemWidth;
        }
    }];
}

- (void)didClickButton:(LDZoomAnimationButton *)button
{
    NSString *emotion = [button titleForState:UIControlStateNormal];
    [self.delegate emojiPageView:self didFinishPickingEmotion:emotion];
}


@end
