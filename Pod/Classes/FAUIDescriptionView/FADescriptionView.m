//
//  FADescriptionView.m
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 11/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FADescriptionView.h"

static inline CGSize getLabelSize(NSString *text, CGSize size, NSDictionary *attributes) {
    CGRect textRect = CGRectZero;
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    else
        textRect.size = [text sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return textRect.size;
}

@interface FADescriptionView () {
    CGRect contentFrame;
    CGRect headerFrame;
}
- (void)_setup;

- (NSDictionary *)headerAttributes;

- (NSDictionary *)contentAttributes;

@end

@implementation FADescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    //self.growHeight = YES;
    //self.growWidth = NO;
    self.vertical = YES;
    self.gap = CGPointZero;
    self.backgroundColor = [UIColor clearColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    // Drawing code
    CGRect frame = rect; //self.frame;
    CGSize frameSize = rect.size; //self.frame.size;
    frameSize.width -= self.padding.left+self.padding.right;
    frameSize.height -= self.padding.top+self.padding.bottom;
    frame.size = frameSize;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    headerFrame = CGRectZero;
    contentFrame = CGRectZero;
    
    if (nil != self.backgroundColor) {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, self.bounds);
    } else {
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, self.bounds);
    }
    
    
    if (self.header) {
        CGSize size = CGSizeZero;
        CGPoint origin = CGPointMake(self.padding.left, self.padding.top);
        if (self.vertical) {
            size = CGSizeMake(frameSize.width,20.f);
        } else {
            size = CGSizeMake(frameSize.width-((100/60)*frameSize.width), 20.f);
        }
        NSDictionary *headerAttributes = [self headerAttributes];
        
        headerFrame.size = getLabelSize(self.header, size, headerAttributes);
        
        headerFrame.origin = origin;
        
        if (sysVer >= 7.0)
            [self.header drawInRect:headerFrame withAttributes:headerAttributes];
        else {
            [(UIColor *)headerAttributes[NSForegroundColorAttributeName] set];
            [self.header drawInRect:headerFrame withFont:headerAttributes[NSFontAttributeName]];
    
        }
    }
    if (self.content) {
        CGSize size = CGSizeZero;
        CGPoint origin = CGPointZero;
        CGPoint gap = (headerFrame.size.width == 0) ? CGPointZero : self.gap;
        if (self.vertical) {
            size = CGSizeMake(frameSize.width,UIViewNoIntrinsicMetric);
            CGFloat y = self.padding.top+headerFrame.size.height+headerFrame.origin.y;
            origin = CGPointMake(self.padding.left, y+gap.y);
        } else {
            size = CGSizeMake(frameSize.width-headerFrame.origin.x-headerFrame.size.width-self.padding.right-gap.x, 9999.f);
            CGFloat x = self.padding.left+headerFrame.origin.x+headerFrame.size.width;
            origin = CGPointMake(x+gap.x,0);
            
        }
        NSDictionary *contentAttributes = [self contentAttributes];
        
        contentFrame.size = getLabelSize(self.content, size, contentAttributes);
        contentFrame.origin = origin;
        
        

            
        if (sysVer >= 7.0) {
            [self.content drawWithRect:contentFrame options:NSStringDrawingUsesLineFragmentOrigin attributes:contentAttributes context:nil];
        } else {
            [(UIColor *)contentAttributes[NSForegroundColorAttributeName] set];
            [self.content drawInRect:contentFrame withFont:contentAttributes[NSFontAttributeName] lineBreakMode:NSLineBreakByWordWrapping];
        }
            //[self.content drawInRect:contentFrame withAttributes:contentAttributes];
    }
    
    CGContextRestoreGState(context);
    NSLog(@"Content Size %@",NSStringFromCGSize(contentFrame.size));
    //self.frame = contentFrame;
    //[self invalidateIntrinsicContentSize];
    
}

- (CGSize)intrinsicContentSize {
    CGSize frameSize = self.frame.size; //self.frame.size;
    frameSize.width -= self.padding.left+self.padding.right;
    frameSize.height -= self.padding.top+self.padding.bottom;
    
    CGSize contentSize = getLabelSize(self.content, frameSize, [self contentAttributes]);
    CGSize headerSize = getLabelSize(self.header, frameSize, [self headerAttributes]);
    
    CGFloat height = 0;
    if (self.vertical) {
        height = headerSize.height+self.gap.y+contentSize.height+self.padding.top+self.padding.bottom+10;
    } else {
        if (contentSize.height > headerSize.height) {
            height = contentSize.height;
        } else {
            height = headerSize.height;
        }
        height += self.padding.top+self.padding.bottom;
    }
    NSLog(@"ContentSize %@",NSStringFromCGSize(contentSize));
    return  CGSizeMake(frameSize.width, height);
}



- (NSDictionary *)headerAttributes {
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor whiteColor];
    
    return @{NSFontAttributeName: [UIFont systemFontOfSize:14],
             NSForegroundColorAttributeName: [UIColor whiteColor],
             NSShadowAttributeName: shadow,
             };
}

- (NSDictionary *)contentAttributes {
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor whiteColor];
    
    NSParagraphStyle *p = [NSParagraphStyle defaultParagraphStyle];
    
    
    return @{NSFontAttributeName: [UIFont systemFontOfSize:12],
             NSForegroundColorAttributeName: [UIColor whiteColor],
             NSShadowAttributeName: shadow
             };
}


- (void)setContent:(NSString *)content {
    _content = content;
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setHeader:(NSString *)header {
    _header = header;
    [self setNeedsDisplay];
     [self invalidateIntrinsicContentSize];
}

@end
