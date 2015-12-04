//
//  FAChildViewController.m
//  FAToggleButton
//
//  Created by Rasmus Kildevaeld on 06/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAContainerViewController.h"
#import "FATabBar.h"

@interface FAContainerViewController ()

@property (nonatomic, weak, readwrite) UIViewController *selectedViewController;


- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (void)_setup;

@end

@implementation FAContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.transitionStyle = FAContainerViewTransitionSlide;
    self.transitionDuration = 0.6f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.selectedViewController.parentViewController == self)
	{
		// nowthing to do
		return;
	}
    
    if (!self.selectedViewController && self.viewControllers.count > 0) {
        CGRect frame = _contentView.bounds;
        
        UIViewController *vc = self.selectedViewController = self.viewControllers[0];
        
        vc.view.frame = frame;
        
        // add as child VC
        [self addChildViewController:vc];
        
        // add it to container view, calls willMoveToParentViewController for us
        [_contentView addSubview:vc.view];
        
        // notify it that move is done
        [vc didMoveToParentViewController:self];
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Selection -
- (NSInteger)selectedIndex {
    return [self indexOfViewController:self.selectedViewController];
}

- (void)selectViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) return;
    [self selectViewControllerAtIndex:index];
}

- (void)selectViewControllerAtIndex:(NSInteger)index {
    if (self.isInTransition) return;
    if (index > self.viewControllers.count-1) return;
    
    self.transition = YES;
    
    UIViewController *nextController = self.viewControllers[index];
    NSInteger currentIndex = [self indexOfViewController:self.selectedViewController];
    if (self.transitionStyle == FAContainerViewTransitionSlide) {
        // Slide
        [self transitionFromViewController:self.selectedViewController toViewController:nextController];
    } else {
        [self addChildViewController:nextController];
        UIViewAnimationOptions option;
        switch (self.transitionStyle) {
            case FAContainerViewTransitionCrossDisolve:
                option = UIViewAnimationOptionTransitionCrossDissolve;
                break;
            case FAContainerViewTransitionFlipHorizontal:
                option = (index > currentIndex) ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop;
                break;
            case FAContainerViewTransitionFlipVertical:
                option = (index > currentIndex) ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
                break;
        }
        __weak typeof (&*self) weakSelf = self;
        [self transitionFromViewController:self.selectedViewController toViewController:nextController duration:self.transitionDuration options:option animations:Nil completion:^(BOOL finished) {
            weakSelf.selectedViewController = nextController;
            weakSelf.transition = NO;
        }];
    }
}

- (void)selectViewControllerWithTitle:(NSString *)title {
    NSInteger index = 0;
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller.title isEqualToString:title]) {
            [self selectViewControllerAtIndex:index];
            break;
        }
        index++;
    }
}

- (NSInteger)indexOfViewController:(UIViewController*)controller {
    return [self.viewControllers indexOfObject:controller];
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    if (fromViewController == toViewController) {
        self.transition = NO;
        return;
    }
    
    // Notify current viewController
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    CGRect frame = _contentView.bounds;
	
    NSInteger current = [self indexOfViewController:fromViewController];
    NSInteger next = [self indexOfViewController:toViewController];
    
	CGFloat x = 0.0f;
	if (next < current)
		x = _contentView.bounds.size.width*-1;
	else
		x = _contentView.bounds.size.width;
	
	frame.origin = CGPointMake(x, 0);
    
	toViewController.view.frame = frame;
    
	__weak __block typeof(&*self) weakSelf = self;
    
    [self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:self.transitionDuration
							   options:0
							animations:^{
								toViewController.view.center = fromViewController.view.center;
								CGFloat x = fromViewController.view.center.x;
								
								if (next < current)
									x += _contentView.bounds.size.width;
								else
									x -= _contentView.bounds.size.width;
								
								fromViewController.view.center = CGPointMake(x, fromViewController.view.center.y);
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:weakSelf];
								weakSelf.selectedViewController = toViewController;
                                weakSelf.transition = NO;
							}];
}


#pragma mark - Getter -
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _contentView;
}

#pragma mark - Setters -
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    if (self.tabBar) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:viewControllers.count];
        for (UIViewController *controller in viewControllers) {
            FATabBarItem *item = [[FATabBarItem alloc] initWithTitle:controller.title];
            [array addObject:item];
        }
        self.tabBar.items = array;
    }
    
}

- (void)setTabBar:(FATabBar *)tabBar {
    _tabBar = tabBar;
    _tabBar.delegate = self;
}


#pragma mark - FATabBarDelegate
- (void)tabBar:(FATabBar *)tabBar didSelectItem:(FATabBarItem *)item atIndex:(NSInteger)index {
    [self selectViewControllerAtIndex:index];
}

@end
