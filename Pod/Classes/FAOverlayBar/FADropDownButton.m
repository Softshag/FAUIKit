//
//  FADropDownButton.m
//  OverlayTest
//
//  Created by Rasmus Kildevaeld on 14/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FADropDownButton.h"
#import <objc/runtime.h>
static inline CGSize getLabelSize(NSString *text, CGSize size, NSDictionary *attributes) {
    CGRect textRect = CGRectZero;
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    else
        textRect.size = [text sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return textRect.size;
}

@interface FADropDownButton ()

@property (nonatomic, strong, readwrite) UIPopoverController *popOverController;
//@property (nonatomic, strong) UIViewController *contentViewController;
- (NSDictionary *)titleAttributes;
- (void)removeAssociatedDropdown:(UIViewController*)controller;
- (void)setAssociatedDropdown:(UIViewController *)controller;
- (void)_setup;

@end

@implementation FADropDownButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    return [self initWithTitle:title contentController:nil];
}

- (id)initWithTitle:(NSString *)title contentController:(UIViewController *)controller {
    if ((self = [super init])) {
        self.title = title;
        self.contentViewController = controller;

        
        [self _setup];
    }
    return self;
}

- (void)_setup {
    CGFloat size = [UIFont systemFontSize];
    self.disclosureColor = [UIColor whiteColor];
    self.disclosureSize = CGSizeMake(8.f, 6.f);
    self.disclosureWidth = 1.f;
    self.titleColor = [UIColor whiteColor];
    self.titleFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.f];
    self.backgroundColor = [UIColor clearColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    
    if (self.popOverController.isPopoverVisible) {
        [self.popOverController dismissPopoverAnimated:YES];
        return;
    }
    
    if (self.delegate) {
        [self.delegate dropdownButtonWasTouched:self];
    }
    if (self.contentViewController) {
        [self presentViewController:self.contentViewController animated:YES];
    }

}

- (void)dismissPopoverAnimated:(BOOL)animated {
    if (_popOverController) {
        id controller = [_popOverController contentViewController];
        if (controller) {
            [self removeAssociatedDropdown:controller];
        }
        [_popOverController dismissPopoverAnimated:animated];
    }
    
}


- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated {
    
    if (_popOverController) {
        if (_popOverController.isPopoverVisible) {
            [_popOverController dismissPopoverAnimated:NO];
        }
        
    }
    
    [self setAssociatedDropdown:controller];
    
    _popOverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    [_popOverController presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    CGRect _titleFrame = CGRectZero;
    
    
    NSDictionary *titleAttributes = [self titleAttributes];
    
    _titleFrame.size = getLabelSize(self.title, self.bounds.size, titleAttributes);
    
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake(0.f, 0.f);
    frame.size = CGSizeMake(rect.size.width, 22.f);
    
    _titleFrame.origin.x += 10.f;
    _titleFrame.origin.y = (rect.size.height - _titleFrame.size.height) / 2;
    [self.title drawInRect:_titleFrame withAttributes:titleAttributes];
    
    
    
    CGSize dcSize = self.disclosureSize;
    CGFloat lPad = 10.f;
    CGFloat dcStartX = _titleFrame.size.width+lPad+_titleFrame.origin.x;//rect.size.width-dcSize.width-rPad;
    CGFloat dcStartY = (rect.size.height-dcSize.height) /2;
    
    
    CGContextMoveToPoint(context, dcStartX, dcStartY );
    CGContextSetStrokeColorWithColor(context, self.disclosureColor.CGColor);
    //Set the width of the pen mark
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context, self.disclosureWidth);
    
    //CGFloat y = rect.size.height-
    CGContextAddLineToPoint(context, dcStartX+dcSize.width/2, dcStartY+dcSize.height);
    CGContextAddLineToPoint(context, dcStartX+dcSize.width, dcStartY);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    [self invalidateIntrinsicContentSize];
    //_headerFrame.origin = CGPointMake(0.f, 0.f);
    // Drawing code
    
}

- (CGSize)intrinsicContentSize {
    CGRect titleFrame = CGRectZero;
    titleFrame.size = getLabelSize(_title, CGSizeMake(9999, 9999), self.titleAttributes);
    // Apply padding
    titleFrame.size.width += 2*10.f +10.f+ self.disclosureSize.width;
    return CGSizeMake(titleFrame.size.width, self.bounds.size.height);
}


/*- (UIPopoverController *)popOverController {
    if (!_popOverController) {
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:self.contentViewController];
    }
    return _popOverController;
}*/

- (NSDictionary *)titleAttributes {
    
    return @{
             NSFontAttributeName: self.titleFont,
             NSForegroundColorAttributeName: self.titleColor
             };
}


- (void)setTitle:(NSString *)title {
    [self setTitle:title animated:NO];
    
}

- (void)setTitle:(NSString *)title animated:(BOOL)animated {
    _title = title;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
    if (animated)
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    _contentViewController = contentViewController;
    
    if (_contentViewController == nil) {
        
    } else {
        [self setAssociatedDropdown:contentViewController];
    }
    

    //[_contentViewController setDropDownButton:self];
}

- (void)setAssociatedDropdown:(UIViewController *)controller {
    objc_setAssociatedObject(controller, "dropDownButton", self, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeAssociatedDropdown:(UIViewController *)controller {
    if (objc_getAssociatedObject(controller, "dropDownButton") != nil) {
        objc_setAssociatedObject(controller,"dropDownButton",  NULL, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.frame = self.superview.bounds;
}
@end
