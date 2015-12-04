//
//  FATabBar.h
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FATabBarItem.h"

@protocol FATabBarDelegate;

@interface FATabBar : UIView

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, copy) IBOutletCollection(FATabBarItem) NSArray *items;
@property (nonatomic) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, readonly) NSInteger selectedIndex;

@property (nonatomic, weak) id<FATabBarDelegate> delegate;

- (id)initWithItems:(NSArray *)items;

- (void)onItemSelected:(FATabBarItem*)item;

- (CGFloat)minimumContentHeight;

- (void)selectItemAtIndex:(NSInteger)index;

@end

@protocol FATabBarDelegate <NSObject>

- (void)tabBar:(FATabBar*)tabBar didSelectItem:(FATabBarItem *)item atIndex:(NSInteger)index;

@end