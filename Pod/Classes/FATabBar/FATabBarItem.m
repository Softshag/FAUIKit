//
//  FATabBarItem.m
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 07/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FATabBarItem.h"

@interface FATabBarItem () {
    UIOffset _titlePositionAdjustment;
    UIOffset _imagePositionAdjustment;
}

@end

@implementation FATabBarItem

- (id)initWithTitle:(NSString *)title {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.toggeble = YES;
        NSShadow * shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeZero;
        shadow.shadowColor = [UIColor whiteColor];
        
        _unselectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                       NSShadowAttributeName: shadow,
                                       };
        
        self.selectedBackgroundColor = [UIColor grayColor];
        self.unselectedBackgroundColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    
    UIImage *backgroundImage = nil;
    UIColor *backgroundColor = nil;
    UIImage *image = nil;
    
    if (self.isSelected) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
        backgroundColor = self.selectedBackgroundColor;
        
    } else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
        backgroundColor = self.unselectedBackgroundColor;
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Draw background
    if (nil != backgroundImage) {
        [backgroundImage drawInRect:self.bounds];
    } else if (nil != backgroundColor) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, self.bounds);
    }
    
    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                     _imagePositionAdjustment.horizontal,
                                     roundf(frameSize.height / 2 - imageSize.height / 2) +
                                     _imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
        
    } else {
        CGRect titleRect = CGRectZero;
        
        if ([_title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
            // IOS 7
            titleRect = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20.f) options:0 attributes:titleAttributes context:nil];
        else
            titleRect.size = [_title sizeWithFont:titleAttributes[NSFontAttributeName] forWidth:frameSize.width lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize titleSize = titleRect.size;

        CGFloat imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
        
        if (nil != image) {
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
        }
        
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        
        NSShadow *shadow = titleAttributes[NSShadowAttributeName];
        
        if (shadow) {
            CGColorRef shadowColor = [shadow.shadowColor CGColor];
            CGContextSetShadowWithColor(context, CGSizeMake(shadow.shadowOffset.width, shadow.shadowOffset.height),
                                        1.0, shadowColor);
        }
        
        
        CGRect frame = CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                  _titlePositionAdjustment.horizontal,
                                  imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                  titleSize.width, titleSize.height);
        
        if ([_title respondsToSelector:@selector(drawInRect:withFont:lineBreakMode:)])
            // IOS 6
            [_title drawInRect:frame withFont:titleAttributes[NSFontAttributeName]];
        else
            // IOS 7
            [_title drawInRect:frame withAttributes:titleAttributes];
    }
    
    CGContextRestoreGState(context);
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches && touch.phase != UITouchPhaseCancelled) {
        self.selected = true;
    }
}


@end
