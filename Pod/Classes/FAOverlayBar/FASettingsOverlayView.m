//
//  FASettingsOverlayView.m
//  OverlayTest
//
//  Created by Rasmus Kildevaeld on 14/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FASettingsOverlayView.h"
#import "UIView+FLKAutoLayout.h"

@interface FASettingsOverlayView ()

//@property (nonatomic, strong) UIView *leftViewContainer;
//@property (nonatomic, strong) UIView *rightViewContainer;

- (void)_setup;
@end

@implementation FASettingsOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)_setup {
    self.leftViewContainer = [UIView new];
    self.rightViewContainer = [UIView new];
    
    [self addSubview:self.leftViewContainer];
    [self addSubview:self.rightViewContainer];
}


- (void)dealloc {
    
}

- (void)updateConstraints {
    UIEdgeInsets pad = self.buttonsEdgeInsert;
    [super updateConstraints];
    
    // Setup containers
    [self.leftViewContainer alignTop:@(pad.top).stringValue
                              bottom:@(pad.bottom).stringValue toView:self];
    
    [self.leftViewContainer alignLeading:@(pad.left).stringValue trailing:nil toView:self];
    //[self.leftViewContainer constrainWidthToView:self
    //                                   predicate:@(self.bounds.size.width/2-pad.left-pad.right).stringValue];
    
    [self.leftViewContainer constrainWidthToView:self predicate:@">=*.5"];
    
    [self.rightViewContainer alignTop:@(pad.top).stringValue
                              bottom:@(pad.bottom).stringValue toView:self];
    
    [self.rightViewContainer constrainLeadingSpaceToView:self.leftViewContainer predicate:@">=0"];
    
    //[self.rightViewContainer constrainWidthToView:self
      //                                 predicate:@(self.bounds.size.width/2).stringValue];
  
    [self.rightViewContainer constrainWidthToView:self predicate:@">=*.5"];
    
    if (self.leftViewContainer.subviews.count >= 1) {
        [self.leftViewContainer.subviews[0] alignLeadingEdgeWithView:self predicate:@(pad.left).stringValue];
        [self.leftViewContainer.subviews[0] alignTop:@(pad.top).stringValue bottom:@(pad.bottom).stringValue toView:self];
    }
    if (self.leftViewContainer.subviews.count > 1) {
        [UIView alignTopAndBottomEdgesOfViews:self.leftViewContainer.subviews];
        [UIView spaceOutViewsHorizontally:self.leftViewContainer.subviews predicate:@(self.spacing).stringValue];
    }
    
    if (self.rightViewContainer.subviews.count >= 1) {
        UIView *view = [self.rightViewContainer.subviews lastObject];
        [view alignLeading:nil trailing:@"0" toView:self.rightViewContainer];
        [view alignTop:@"0" bottom:@"0" toView:self.rightViewContainer];
    }
    if (self.rightViewContainer.subviews.count > 1) {
        NSArray *subs = self.rightViewContainer.subviews;
        NSInteger count = self.rightViewContainer.subviews.count;
        NSInteger index = count-1;
        while (index > 0) {
            UIView *parent = subs[index];
            UIView *current = subs[--index];
            
            [current alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:parent predicate:@(-self.spacing).stringValue];
        }
    }
    
}

- (void)addButton:(UIControl *)button {
    UIEdgeInsets pad = self.buttonsEdgeInsert;
    CGRect frame = self.bounds;
    frame.size.height -= pad.top+pad.bottom;
    frame.size.width -= pad.left+pad.right;
    [self.leftViewContainer addSubview:button];
    button.frame = frame;
}

- (void)addLeftButton:(UIControl *)button {
    UIEdgeInsets pad = self.buttonsEdgeInsert;
    CGRect frame = self.leftViewContainer.bounds;
    frame.size.height -= pad.top+pad.bottom;
    frame.size.width -= pad.left+pad.right;
    [self.leftViewContainer addSubview:button];
    button.frame = frame;
    //[self setNeedsLayout];
    //[self setNeedsDisplay];
}

- (void)addRightButton:(UIControl *)button {
    UIEdgeInsets pad = self.buttonsEdgeInsert;
    CGRect frame = self.rightViewContainer.bounds;
    frame.size.height -= pad.top+pad.bottom;
    frame.size.width -= pad.left+pad.right;
    [self.rightViewContainer addSubview:button];
    button.frame = frame;
    //[self setNeedsDisplay];
}

- (void)setButtonsEdgeInsert:(UIEdgeInsets)buttonsEdgeInsert {
    _buttonsEdgeInsert = buttonsEdgeInsert;
    [self setNeedsDisplay];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsDisplay];
}


@end
