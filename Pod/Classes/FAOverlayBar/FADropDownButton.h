//
//  FADropDownButton.h
//  OverlayTest
//
//  Created by Rasmus Kildevaeld on 14/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+FADropDownButton.h"

@protocol FADropDownButtonDelegate

- (void)dropdownButtonWasTouched:(FADropDownButton *)button;

@end

IB_DESIGNABLE
@interface FADropDownButton : UIControl

@property (nonatomic, strong, readonly) UIPopoverController *popOverController;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic) CGSize disclosureSize;
@property (nonatomic, strong) UIColor *disclosureColor;
@property (nonatomic) CGFloat disclosureWidth;
@property (nonatomic, weak) id<FADropDownButtonDelegate> delegate;

+ (instancetype)buttonWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title contentController:(UIViewController *)controller;

- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)presentViewController:(UIViewController*)controller animated:(BOOL)animated;

- (void)setTitle:(NSString *)title animated:(BOOL)animated;
@end
