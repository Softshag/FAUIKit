//
//  FAUIKit.m
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAUIKit.h"


CGSize FAGetLabelSize(NSString *text, CGSize size, NSDictionary *attributes) {
    CGRect textRect = CGRectZero;
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    else
        textRect.size = [text sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return textRect.size;
}
