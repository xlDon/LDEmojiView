//
//  LDEmojiView.m
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import "LDEmojiView.h"
#import "LDEmojiPageView.h"
#import "LDEmojiParser.h"

@interface LDEmojiView () <LDEmojiPageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *emotionData;
@property (nonatomic, strong) NSArray *emojiPageList;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LDEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _numberPerRow = 7;
    _numberPerPage = 20;
    _itemSize = CGSizeMake(40, 40);
    _font = [UIFont systemFontOfSize:26];
}

- (void)dealloc
{
    _scrollView.delegate = nil;
}

- (NSArray *)emotionData
{
    if (!_emotionData)
    {
        _emotionData = [[LDEmojiParser sharedInstance] emojis];
    }
    return _emotionData;
}

- (NSUInteger)pageNumber
{
    return (self.emotionData.count + self.numberPerPage - 1) / self.numberPerPage;
}

- (NSArray *)emojiPageList
{
    if (!_emojiPageList)
    {
        NSUInteger pageNumber = [self pageNumber];
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:pageNumber];
        
        NSUInteger itemIndex = 0;
        NSUInteger numberPerPage = self.numberPerPage;
        NSUInteger totalCount = self.emotionData.count;
        CGRect pageFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
        
        while (itemIndex < totalCount)
        {
            NSRange range = NSMakeRange(itemIndex, numberPerPage);
            if (NSMaxRange(range) > totalCount)
            {
                range.length = totalCount - range.location;
            }
            
            NSArray *emotions = [self.emotionData subarrayWithRange:range];
            LDEmojiPageView *pageView = [[LDEmojiPageView alloc] initWithFrame:pageFrame emotions:emotions];
            pageView.font = self.font;
            pageView.numberPerRow = self.numberPerRow;
            pageView.itemHeight = self.itemSize.height;
            pageView.delegate = self;
            [list addObject:pageView];
            [self.scrollView addSubview:pageView];
            
            itemIndex += range.length;
        };
        
        _emojiPageList = list;
    }
    return _emojiPageList;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        [self insertSubview:_scrollView atIndex:0];
    }
    return _scrollView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.pageNumber, self.bounds.size.height);
    
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
    [self.emojiPageList enumerateObjectsUsingBlock:^(LDEmojiPageView *pageView, NSUInteger idx, BOOL *stop) {
        CGRect newFrame = frame;
        newFrame.origin.x = idx * self.bounds.size.width + frame.origin.x;
        pageView.frame = newFrame;
    }];
}

#pragma mark - LDEmojiPageViewDelegate
- (void)emojiPageView:(LDEmojiPageView *)emojiPageView didFinishPickingEmotion:(NSString *)emotion
{
    [self.delegate emojiView:self didFinishPickingEmotion:emotion];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControlIndexWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self updatePageControlIndexWithScrollView:scrollView];
    }
}

- (void)updatePageControlIndexWithScrollView:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(emojiView:didChangePageIndex:)])
    {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
        [self.delegate emojiView:self didChangePageIndex:index];
    }
}


@end
