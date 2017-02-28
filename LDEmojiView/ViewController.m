//
//  ViewController.m
//  LDEmojiView
//
//  Created by xDon on 17/2/28.
//  Copyright © 2017年 xlDong. All rights reserved.
//

#import "ViewController.h"
#import "LDEmojiView.h"

@interface ViewController () <LDEmojiViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet LDEmojiView *emojiView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emojiView.delegate = self;
}

- (IBAction)delete:(id)sender
{
    NSRange selectedRange = self.contentView.selectedRange;
    if (selectedRange.location > 0)
    {
        NSRange range = [self.contentView.text rangeOfComposedCharacterSequenceAtIndex:selectedRange.location - 1];
        if (range.location != NSNotFound)
        {
            self.contentView.text = [self.contentView.text stringByReplacingCharactersInRange:range withString:@""];
            
            range.length = 0;
            self.contentView.selectedRange = range;
        }
    }
}

#pragma mark - LDEmojiViewDelegate
- (void)emojiView:(LDEmojiView *)emojiView didChangePageIndex:(NSInteger)pageIndex
{
    self.pageControl.currentPage = pageIndex;
}

- (void)emojiView:(LDEmojiView *)emojiView didFinishPickingEmotion:(NSString *)emotion
{
     [self.contentView replaceRange:self.contentView.selectedTextRange withText:emotion];
}

@end
