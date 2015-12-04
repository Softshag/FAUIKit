//
//  FA.m
//  FAToggleButton
//
//  Created by Rasmus Kildevaeld on 06/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAContainerView.h"
#import "UIView+FLKAutoLayout.h"

@interface FAContainerView ()

@property (nonatomic, weak, readwrite) UIView *selectedView;

@property (nonatomic, getter = isInTransition, readwrite) BOOL transition;

- (void)setup;

@end

@implementation FAContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.transitionStyle = FAContainerViewTransitionFlipHorizontal;
    self.transitionDuration = 1.f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.selectedView.superview == self) {
        return;
    }
    if (self.views.count > 0) {
        [self selectViewAtIndex:0 animated:NO];
    }
    
}

- (void)layoutSubviews {
    self.selectedView.frame = self.contentView.bounds;
    [super layoutSubviews];
}

- (void)selectViewAtIndex:(NSInteger)index {
    [self selectViewAtIndex:index animated:YES];
}

- (void)selectViewAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (self.isInTransition) return;
    
    if (index >= self.views.count) {
        return;
    }
    
    self.transition = YES;
    
    __weak typeof(&*self) weakSelf = self;
    
    UIView *nextView = [self.views objectAtIndex:index];
    
    NSInteger currentIndex = [self.views indexOfObject:self.selectedView];
    
    nextView.frame = self.contentView.bounds;
    nextView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    if (self.transitionStyle == FAContainerViewTransitionSlide) {
        // Custom style
    } else {
        UIViewAnimationOptions option;
        switch (self.transitionStyle) {
            case FAContainerViewTransitionCrossDisolve:
                option = UIViewAnimationOptionTransitionCrossDissolve;
                break;
            case FAContainerViewTransitionFlipHorizontal:
                option = (index > currentIndex) ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop;
                break;
            case FAContainerViewTransitionFlipVertical:
                option = (index > currentIndex) ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
                break;
        }
        [self.contentView addSubview:nextView];
        
        if (animated) {
            [UIView transitionFromView:self.selectedView
                                toView:nextView
                              duration:self.transitionDuration
                               options:option
                            completion:^(BOOL finished) {
                                
                                weakSelf.transition = NO;
                            }];
        } else {
            self.transition = NO;
        }
        
        self.selectedView = nextView;
    }
}

- (void)selectView:(UIView*)view {
    NSInteger index = [self.views indexOfObject:view];
    if (index == NSNotFound) return;
    [self selectViewAtIndex:index];
}

#pragma mark - Getters -
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

@end
