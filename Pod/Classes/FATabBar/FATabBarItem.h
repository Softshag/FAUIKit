//
//  FATabBarItem.h
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FATabBarItem : UIControl

@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat itemHeight;

@property (nonatomic, strong) NSDictionary *selectedTitleAttributes;
@property (nonatomic, strong) NSDictionary *unselectedTitleAttributes;

@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *unselectedBackgroundColor;

@property (nonatomic, strong) UIImage *selectedBackgroundImage;
@property (nonatomic, strong) UIImage *unselectedBackgroundImage;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

- (id)initWithTitle:(NSString *)title;

@end
