//
//  FADescriptionView.h
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 11/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FADescriptionView : UIView

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *content;

@property (strong, nonatomic) UIFont *headerFont;
@property (strong, nonatomic) UIColor *headerFontColor;

@property (strong, nonatomic) UIFont *contentFont;
@property (strong, nonatomic) UIColor *contentFontColor;

@property (nonatomic) UIEdgeInsets padding;

@property (nonatomic) CGPoint gap;

@property (nonatomic) BOOL vertical;

@end
