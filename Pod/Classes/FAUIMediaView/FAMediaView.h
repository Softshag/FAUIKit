//
//  FAMediaView.h
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 11/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAMediaView : UIControl

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIImage *image;

/// ----------------
/// @name Appearance
/// ----------------
@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIColor *headerColor;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic) UIColor *disclosureColor;
@property (nonatomic) CGSize disclosureSize;
@property (nonatomic) CGFloat disclosureWidth;

/// ----------------
/// @name Dimensions
/// ----------------
/** @property The size of the image */
@property (nonatomic) CGSize imageSize;
/** @property Container padding */
@property (nonatomic) UIEdgeInsets padding;
/** @property The gap between image and header/content (x). The gap between header/content (y) */
@property (nonatomic) CGPoint gap;

@property (nonatomic, copy) NSURL *actionURL;

@end
