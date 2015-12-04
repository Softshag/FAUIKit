//
//  FAMediaView.m
//  FAUIKit
//
//  Created by Rasmus Kildevaeld on 11/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAMediaView.h"

static inline CGSize getLabelSize(NSString *text, CGSize frameSize, NSDictionary *attributes,CGSize imageSize, CGPoint gap) {
    CGSize size = CGSizeMake(frameSize.width - imageSize.width - gap.x,frameSize.height);
    CGRect textRect = CGRectZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    else
        textRect.size = [text sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return textRect.size;
}

@interface FAMediaView () {
    CGRect headerFrame;
    CGRect contentFrame;
    CGRect imageFrame;
}

@property (nonatomic) BOOL drawDisclosure;

- (void)_setup;

- (void)onURLAction:(id)sender;

@end

@implementation FAMediaView

- (id)init{
    if ((self = [super init])) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
        // Initialization code
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
    headerFrame = CGRectZero;
    contentFrame = CGRectZero;
    imageFrame = CGRectZero;
    
    self.imageSize = CGSizeMake(33.f, 33.f);
    self.padding = UIEdgeInsetsZero;
    
    self.headerColor = [UIColor whiteColor];
    self.headerFont = [UIFont systemFontOfSize:14.f];
    
    self.contentFont = [UIFont systemFontOfSize:12.f];
    self.contentColor = [UIColor whiteColor];
    
    self.disclosureColor = [UIColor grayColor];
    self.disclosureSize = CGSizeMake(5.f,8.f);
    self.disclosureWidth = 2.f;
    self.gap = CGPointMake(10.f, 5.f);
    
    self.actionURL = nil;
    
}

#pragma mark - Setters
- (void)setHeader:(NSString *)header {
    _header = header;
    [self setNeedsDisplay];
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)setActionURL:(NSURL *)url {
    
    _actionURL = url;
    [self removeTarget:self action:@selector(onURLAction:) forControlEvents:UIControlEventTouchUpInside];
    if (nil == url)  {
        self.drawDisclosure = NO;
        return;
    }
    self.drawDisclosure = YES;
    [self addTarget:self action:@selector(onURLAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGSize)intrinsicContentSize {
    
    CGFloat height = 0;
    CGSize headerSize = getLabelSize(self.header, self.frame.size, [self headerAttributes], self.imageSize,self.gap);
    CGSize contentSize = getLabelSize(self.content, self.frame.size, [self contentAttributes], self.imageSize, self.gap);
    
    height = headerSize.height + contentSize.height + self.gap.y;
    if (height < self.imageSize.height) height = self.imageSize.height;
    //NSLog(@"SIZE %f",height);
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    // Drawing code
    CGSize frameSize = self.superview.frame.size;
    CGRect viewFrame = self.superview.frame;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);

    CGContextSaveGState(context);
    
    imageFrame = CGRectZero;
    headerFrame = CGRectZero;
    contentFrame = CGRectZero;
    
    CGPoint gap = self.gap;
    
    // Draw image
    if (self.image) {
        imageFrame.origin = CGPointMake(self.padding.left, self.padding.top);
        imageFrame.size = self.imageSize;
        [self.image drawInRect:imageFrame];
    }
    
    // Draw header
    if (self.header) {
        CGPoint origin = CGPointMake(imageFrame.origin.x+imageFrame.size.width+gap.x, self.padding.top);
       
        NSDictionary *headerAttributes = [self headerAttributes];
        
        headerFrame.size = getLabelSize(self.header, frameSize, headerAttributes, self.imageSize, self.gap);
        
        if (!self.content) {
            origin.y = (self.imageSize.height/2)-(headerFrame.size.height/2);
        }
        headerFrame.origin = origin;
            
        if (sysVer >= 7.0)
            [self.header drawInRect:headerFrame withAttributes:headerAttributes];
        else {
            [(UIColor *)headerAttributes[NSForegroundColorAttributeName] set];
            [self.header drawInRect:headerFrame withFont:headerAttributes[NSFontAttributeName]];
    
        }
    }
    // Draw content
    if (self.content) {
       
        CGPoint origin = CGPointZero;
       
        CGFloat y = 0;
        
        NSDictionary *contentAttributes = [self contentAttributes];
        
        contentFrame.size = getLabelSize(self.content, frameSize, contentAttributes, self.imageSize, gap);

        y = self.padding.top+headerFrame.size.height+headerFrame.origin.y+gap.y;
        // Centralize if no header.
        if (!self.header && contentFrame.size.height <= self.imageSize.height) {
            y += self.imageSize.height/2 - contentFrame.size.height/2;
        }
        
        origin = CGPointMake(imageFrame.origin.x+imageFrame.size.width+gap.x, y);
        
        contentFrame.origin = origin;
        
            
        if (sysVer >= 7.0)
            [self.content drawInRect:contentFrame  withAttributes:contentAttributes];
        else {
            [(UIColor *)contentAttributes[NSForegroundColorAttributeName] set];
            [self.content drawInRect:contentFrame withFont:contentAttributes[NSFontAttributeName] lineBreakMode:NSLineBreakByWordWrapping];
    
        }
        
        ///NSLog(@"Content Size %@",NSStringFromCGSize(contentFrame.size));
    }
    if (self.drawDisclosure) {
        CGSize dcSize = self.disclosureSize;
        CGFloat rPad = 5.f;
        CGFloat dcStart = frameSize.width-dcSize.width-rPad;
        CGContextMoveToPoint(context, dcStart, self.imageSize.height/2 - dcSize.height/2 );
        CGContextSetStrokeColorWithColor(context, self.disclosureColor.CGColor);
        //Set the width of the pen mark
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextSetLineWidth(context, self.disclosureWidth);
        
        CGContextAddLineToPoint(context, frameSize.width-rPad, self.imageSize.height/2);
        CGContextAddLineToPoint(context, dcStart, self.imageSize.height/2 + dcSize.height/2);
        CGContextStrokePath(context);

    }
    
    CGContextRestoreGState(context);
    
}
#pragma mark - Actions
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super addTarget:target action:action forControlEvents:controlEvents];
    self.drawDisclosure = YES;
    [self setNeedsDisplay];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super removeTarget:target action:action forControlEvents:controlEvents];
    self.drawDisclosure = NO;
    [self setNeedsDisplay];
}


#pragma mark - Getters

- (NSDictionary *)headerAttributes {
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor whiteColor];
    
    return @{NSFontAttributeName: self.headerFont,
             NSForegroundColorAttributeName: self.headerColor,
             NSShadowAttributeName: shadow,
             };
}

- (NSDictionary *)contentAttributes {
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor whiteColor];
    
    return @{NSFontAttributeName: self.contentFont,
             NSForegroundColorAttributeName: self.contentColor,
             NSShadowAttributeName: shadow,
             };
}

- (void)onURLAction:(id)sender {
    UIApplication * app = [UIApplication sharedApplication];
    if ([app canOpenURL:self.actionURL]) {
        [app openURL:self.actionURL];
    }
}


@end
