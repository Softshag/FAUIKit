//
//  FALinkView.m
//  LiveJazzDanmark
//
//  Created by Rasmus Kildevæld on 9/21/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FALinkView.h"

@interface FALinkView () {
    CGRect _headerFrame;
    CGRect _contentFrame;
}

- (NSDictionary *)headerAttributes;

- (NSDictionary *)contentAttributes;

- (void)_setup;
@end

@implementation FALinkView

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
    
    //background-color: clear;
    self.headerColor = [UIColor whiteColor];
    self.headerFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.f];
    
    self.contentColor = [UIColor colorWithRed:0.216 green:0.671 blue:0.784 alpha:1.000];
    self.contentFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.f];
    
        
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    _headerFrame = CGRectZero;
    _contentFrame = CGRectZero;
    NSMutableString *string = [NSMutableString new];
    NSDictionary *headerAttributes = [self headerAttributes];
    NSDictionary *contentAttributes = [self contentAttributes];
    
    if (self.header) {
        [string appendString:self.header];
        _headerFrame = [self.header boundingRectWithSize:rect.size options:0 attributes:headerAttributes context:nil];
    }
    if (self.content) {
        [string appendFormat:@" %@",self.content];
        _contentFrame = [self.content boundingRectWithSize:rect.size options:0 attributes:contentAttributes context:nil];
    }
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake(0.f, 0.f);
    frame.size = CGSizeMake(rect.size.width, 22.f);
    
    NSMutableAttributedString *astring = [[NSMutableAttributedString alloc] initWithString:string];
    if (self.header)
        [astring addAttributes:headerAttributes range:[string rangeOfString:self.header]];
    if (self.content)
        [astring addAttributes:contentAttributes range:[string rangeOfString:self.content]];
    [astring drawInRect:frame];
    
    CGContextRestoreGState(context);
    [self invalidateIntrinsicContentSize];
    //_headerFrame.origin = CGPointMake(0.f, 0.f);
    // Drawing code
}

- (CGSize)intrinsicContentSize {
    CGRect cFrame = [self.content boundingRectWithSize:CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric) options:0 attributes:[self contentAttributes] context:nil];
    CGRect hFrame = [self.header boundingRectWithSize:CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric) options:0 attributes:[self headerAttributes] context:nil];

    CGFloat height = (cFrame.size.height > hFrame.size.height) ? cFrame.size.height : hFrame.size.height;
    
    return CGSizeMake(cFrame.size.width,height);
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self setNeedsDisplay];
}

- (void)setHeader:(NSString *)header {
    _header = header;
    [self setNeedsDisplay];
}

- (NSDictionary *)headerAttributes {
    return @{
             NSFontAttributeName: self.headerFont,
             NSForegroundColorAttributeName: self.headerColor
             };
}

- (NSDictionary *)contentAttributes {
    return @{
             NSFontAttributeName: self.contentFont,
             NSForegroundColorAttributeName: self.contentColor
             };
}


@end
