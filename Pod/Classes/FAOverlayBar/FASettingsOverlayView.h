//
//  FASettingsOverlayView.h
//  OverlayTest
//
//  Created by Rasmus Kildevaeld on 14/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FADropDownButton.h"

IB_DESIGNABLE

@interface FASettingsOverlayView : UIView

@property (nonatomic, strong) IBOutlet UIView *leftViewContainer;
@property (nonatomic, strong) IBOutlet UIView *rightViewContainer;
IBInspectable @property (nonatomic) UIEdgeInsets buttonsEdgeInsert;
IBInspectable @property (nonatomic) CGFloat spacing;

- (void)addButton:(UIControl *)button;

- (void)addLeftButton:(UIControl *)button;

- (void)addRightButton:(UIControl *)button;

@end
