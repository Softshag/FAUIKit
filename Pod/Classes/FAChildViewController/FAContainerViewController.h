//
//  FAChildViewController.h
//  FAToggleButton
//
//  Created by Rasmus Kildevaeld on 06/09/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "enums.h"
@protocol FATabBarDelegate;
@class FATabBar;

@interface FAContainerViewController : UIViewController <FATabBarDelegate>

@property (nonatomic, strong)  IBOutlet FATabBar *tabBar;

/** View Controller */
@property (nonatomic, strong) IBOutletCollection(UIViewController) NSArray *viewControllers;
/** The view container the view controllers */
@property (nonatomic, strong) IBOutlet UIView *contentView;
/** The selected index */
@property (nonatomic, readonly) NSInteger selectedIndex;
/** The currently selected viewcontroller */
@property (nonatomic, readonly) UIViewController *selectedViewController;
/** Wheter the the viewcontroller is in transition */
@property (nonatomic, getter = isInTransition) BOOL transition;

@property (nonatomic) FAContainerViewTransition transitionStyle;

@property (nonatomic) CGFloat transitionDuration;
/** Select a view controller 
 * @param [UIViewController] ViewController The view controller to select
 */
- (void)selectViewController:(UIViewController *)viewController;
/** Select a viewcontroller by index
 * @param [NSInteger] index
 */
- (void)selectViewControllerAtIndex:(NSInteger)index;
/** Select viewcontroller with title 
 * @param [NSString] title
 */
- (void)selectViewControllerWithTitle:(NSString *)title;
/** Get index of a specific view controller
 * @param [UIViewController] controller
 * @return [NSInteger]
 */
- (NSInteger)indexOfViewController:(UIViewController*)controller;

@end
