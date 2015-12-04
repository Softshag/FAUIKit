//
//  FA.h
//  FAToggleButton
//
//  Created by Rasmus Kildevaeld on 06/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "enums.h"

@interface FAContainerView : UIView

@property (nonatomic, getter = isInTransition,readonly) BOOL transition;


@property (nonatomic ,strong) IBOutlet UIView *contentView;

@property (nonatomic ,strong) IBOutletCollection(UIView) NSArray *views;

@property (nonatomic, weak, readonly) UIView *selectedView;

@property (nonatomic) FAContainerViewTransition transitionStyle;

@property (nonatomic) CGFloat transitionDuration;

- (void)selectViewAtIndex:(NSInteger)index;

- (void)selectViewAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)selectView:(UIView*)view;



@end
