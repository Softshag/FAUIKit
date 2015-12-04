//
//  FALinkView.h
//  LiveJazzDanmark
//
//  Created by Rasmus Kildevæld on 9/21/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FALinkView : UIControl

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) UIFont *headerFont;
@property (nonatomic, copy) UIColor *headerColor;

@property (nonatomic, copy) UIFont *contentFont;
@property (nonatomic, copy) UIColor *contentColor;

@end
