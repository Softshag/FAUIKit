//
//  FATabBar.m
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FATabBar.h"

@interface FATabBar ()

@property (nonatomic, strong, readwrite) UIView *backgroundView;

@property (nonatomic) CGFloat itemWidth;

@property (nonatomic, readwrite) NSInteger selectedIndex;


- (void)_setup;



@end

@implementation FATabBar

- (id)initWithItems:(NSArray *)items {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString *title in items) {
        FATabBarItem *item = [[FATabBarItem alloc] init];
        item.title = title;
        [tmp addObject:item];
    }
    self.items = tmp;
    return [self init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _setup];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)_setup {
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor grayColor];
    [self addSubview:_backgroundView];
}

- (void)layoutSubviews {
    CGSize frameSize = self.bounds.size;
    
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                               frameSize.width, frameSize.height)];
    
    [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left -
                               [self contentEdgeInsets].right) / [[self items] count])];
    
    NSInteger index = 0;
    
    for (FATabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        CGRect frame = CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contentEdgeInsets.bottom);
        
        [item setFrame:frame];
        [item setNeedsDisplay];
        
        index++;
    }
}


#pragma mark - Setters - 
- (void)setItems:(NSArray *)items {
    for (FATabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (FATabBarItem *item in items) {
        [item addTarget:self action:@selector(onItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
    [self selectItemAtIndex:0];
    
    
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (FATabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

- (void)onItemSelected:(FATabBarItem *)item {
    NSInteger index = [self.items indexOfObject:item];
    
    if (index == NSNotFound) return;
    self.selectedIndex = index;
    
    for (FATabBarItem *it in self.items) {
        if (it == item) continue;
        it.selected = NO;
    }
    if (self.delegate)
        [self.delegate tabBar:self didSelectItem:item atIndex:index];
}

- (void)selectItemAtIndex:(NSInteger)index {
    if (index >= self.items.count) return;
    self.selectedIndex = index;
    for (FATabBarItem *it in self.items) {
        it.selected = NO;
    }
    FATabBarItem *item = [self.items objectAtIndex:index];
    item.selected = YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
