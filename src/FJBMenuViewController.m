//
//  FJBMenuViewController.m
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Francisco J. Belchi (https://github.com/fjbelchi/FJBMenuViewController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "FJBMenuViewController.h"
#import "FJBMenuViewBaseConfiguration.h"
#import "FJBViewControllerAnimationProtocol.h"


@interface FJBMenuViewController () <UIGestureRecognizerDelegate>
// -- ViewControllers
@property (nonatomic, readwrite) BOOL leftMenuOpened;
@property (nonatomic, readwrite) BOOL rigthMenuOpened;
@property (nonatomic, strong) UIViewController *selectedViewController;

// -- Side states
@property (nonatomic, assign) MenuSide sideOpened;
@property (nonatomic, assign) MenuSide sideOpening;
@property (nonatomic, strong) NSMutableSet *sidesAvailable;

// -- Gesture
@property (nonatomic, strong) UIGestureRecognizer *defaultGestureRecognizer;

// -- Configuration
@property (nonatomic, strong) id<FJBMenuAnimationProtocol> menuAnimation;
@property (nonatomic, assign, readonly) BOOL animationNeedHideStatusBar;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@end

@implementation FJBMenuViewController

- (instancetype)init
{
    return [self initWithCenterViewController:nil leftViewController:nil rightViewController:nil];
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
{
    return [self initWithCenterViewController:centerViewController leftViewController:nil rightViewController:nil];
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                          leftViewController:(UIViewController *)leftViewController
{
    return [self initWithCenterViewController:centerViewController
                           leftViewController:leftViewController
                          rightViewController:nil];
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                         rightViewController:(UIViewController *)rightViewController
{
    return [self initWithCenterViewController:centerViewController
                           leftViewController:nil
                          rightViewController:rightViewController];
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                          leftViewController:(UIViewController *)leftViewController
                         rightViewController:(UIViewController *)rightViewController
{
    self = [super init];
    if(self) {
        _centerViewController = centerViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
        _shouldHideStatusBar = NO;
        
        _sidesAvailable = [NSMutableSet set];
        
        if (_leftViewController) {
            [_sidesAvailable addObject:@(MenuLeftSide)];
        }
        if (_rightViewController) {
            [_sidesAvailable addObject:@(MenuRightSide)];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSAssert(self.centerViewController != nil, @"centerViewController was not set");
    [super viewDidLoad];
    
    [self addChildViewController:self.centerViewController];
    [self.view addSubview:self.centerViewController.view];
    [self didMoveToParentViewController:self.centerViewController];
    
    [self p_setupGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden
{
    return self.shouldHideStatusBar;
}

#pragma mark - Properties (Configuration Getters)

- (id<FJBMenuViewConfigurationProtocol>) defaultConfiguration
{
    if (_defaultConfiguration) {
        return _defaultConfiguration;
    }
    
    _defaultConfiguration = [[FJBMenuViewBaseConfiguration alloc] init];
    
    return _defaultConfiguration;
}

- (id<FJBMenuAnimationProtocol>) menuAnimation
{
    if (_menuAnimation) {
        return _menuAnimation;
    }
    if ([self.defaultConfiguration respondsToSelector:@selector(menuViewControllerDefaultAnimation:)]) {
        _menuAnimation = [self.defaultConfiguration menuViewControllerDefaultAnimation:self];
    }
    NSAssert(_menuAnimation !=nil, @"No animaiton provided");
    return _menuAnimation;
}

- (UIGestureRecognizer *)defaultGestureRecognizer
{
    if (_defaultGestureRecognizer) {
        return _defaultGestureRecognizer;
    }
    
    if ([self.defaultConfiguration respondsToSelector:@selector(gestureRecognizerForCenterViewController:)]) {
        _defaultGestureRecognizer = [self.defaultConfiguration gestureRecognizerForCenterViewController:self.centerViewController];
    }
    
    if (!_defaultGestureRecognizer) {
        _defaultGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
        [_defaultGestureRecognizer setDelegate:self];
    }
    
    return _defaultGestureRecognizer;
}

- (BOOL) animationNeedHideStatusBar
{
    if ([self.defaultConfiguration respondsToSelector:@selector(menuViewControllerShouldHideStatusBar:)]) {
        return [self.defaultConfiguration menuViewControllerShouldHideStatusBar:self];
    }
    
    return NO;
}

#pragma mark - Properties (Setters)

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController) {
        [_rightViewController willMoveToParentViewController:nil];
        [_rightViewController.view removeFromSuperview];
        [_rightViewController removeFromParentViewController];
    }
    
    _rightViewController = rightViewController;
    
    if (_rightViewController) {
        [self.sidesAvailable addObject:@(MenuRightSide)];
    } else {
        [self.sidesAvailable removeObject:@(MenuRightSide)];
    }
    
    if (self.rigthMenuOpened) {
        [self addChildViewController:_rightViewController];
        [self.view addSubview:_rightViewController.view];
        [self didMoveToParentViewController:_rightViewController];
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController) {
        [_leftViewController willMoveToParentViewController:nil];
        [_leftViewController.view removeFromSuperview];
        [_leftViewController removeFromParentViewController];
    }
    
    _leftViewController = leftViewController;
    
    if (_leftViewController) {
        [self.sidesAvailable addObject:@(MenuLeftSide)];
    } else {
        [self.sidesAvailable removeObject:@(MenuLeftSide)];
    }
    
    if (self.isLeftMenuOpened) {
        [self addChildViewController:_leftViewController];
        [self.view addSubview:_leftViewController.view];
        [self didMoveToParentViewController:_leftViewController];
    }
}

- (void)setCenterViewController:(UIViewController *)centerViewController
{
   if (_centerViewController) {
        centerViewController.view.frame = _centerViewController.view.frame;
        [_centerViewController willMoveToParentViewController:nil];
        [_centerViewController.view removeFromSuperview];
        [_centerViewController removeFromParentViewController];
    }
    
    _centerViewController = centerViewController;
    
    [self addChildViewController:_centerViewController];
    [self.view addSubview:_centerViewController.view];
    [self didMoveToParentViewController:_centerViewController];
    [self p_setupGestureRecognizer];
}


- (void)setCenterViewController:(UIViewController *)centerViewController
                   withDuration:(CGFloat)duration
                     animations:(void(^)())animationBlock
                     completion:(void(^)())completionBlock
{
    [_centerViewController willMoveToParentViewController:nil];

    [self addChildViewController:centerViewController];
    [self.view addSubview:centerViewController.view];

    [UIView animateWithDuration:duration
                     animations:^{
                         if (animationBlock) {
                             animationBlock();
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         if (completionBlock) {
                             completionBlock();
                         }
                         
                         [_centerViewController.view removeFromSuperview];
                         [_centerViewController removeFromParentViewController];
                         
                         _centerViewController = centerViewController;
                         [_centerViewController didMoveToParentViewController:self];
                         [self p_setupGestureRecognizer];
                         
                     }];

}

- (void)setCenterViewController:(UIViewController *)centerViewController animated:(BOOL)animated
{
    if (!animated) {
        self.centerViewController = centerViewController;
    }
    
    if ([_centerViewController respondsToSelector:@selector(menuViewController:willChangeCenterViewController:forViewController:)]) {
        [(id<FJBViewControllerAnimationProtocol>)_centerViewController menuViewController:self willChangeCenterViewController:_centerViewController forViewController:centerViewController];
    }
    
    if ([centerViewController respondsToSelector:@selector(menuViewController:willChangeCenterViewController:forViewController:)]) {
        [(id<FJBViewControllerAnimationProtocol>)centerViewController menuViewController:self willChangeCenterViewController:_centerViewController forViewController:centerViewController];
    }
    
    [_centerViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:centerViewController];
    [self.view addSubview:centerViewController.view];
    
    void (^fromViewControllerBlock)(BOOL finished) = ^void(BOOL finished){
        
    };
    
    void (^toViewControllerBlock)(BOOL finished) = ^void(BOOL finished){
        
        [_centerViewController.view removeFromSuperview];
        [_centerViewController removeFromParentViewController];
        
        if ([_centerViewController respondsToSelector:@selector(menuViewController:didChangeCenterViewController:forViewController:)]) {
            [(id<FJBViewControllerAnimationProtocol>)_centerViewController menuViewController:self didChangeCenterViewController:_centerViewController forViewController:centerViewController];
        }
        
        _centerViewController = centerViewController;
        [_centerViewController didMoveToParentViewController:self];
        [self p_setupGestureRecognizer];
        
        if ([centerViewController respondsToSelector:@selector(menuViewController:didChangeCenterViewController:forViewController:)]) {
            [(id<FJBViewControllerAnimationProtocol>)centerViewController menuViewController:self didChangeCenterViewController:_centerViewController forViewController:centerViewController];
        }
    };
    
    
    
    if ([_centerViewController respondsToSelector:@selector(menuViewController:animateForViewController:withCompletionBlock:)]) {
        [(id<FJBViewControllerAnimationProtocol>)_centerViewController menuViewController:self
                                                                 animateForViewController:centerViewController
                                                                      withCompletionBlock:fromViewControllerBlock];
    }
    
    if ([centerViewController respondsToSelector:@selector(menuViewController:animateForViewController:withCompletionBlock:)]) {
        [(id<FJBViewControllerAnimationProtocol>)centerViewController menuViewController:self
                                                                animateForViewController:_centerViewController
                                                                     withCompletionBlock:toViewControllerBlock];
    }
}

- (void)presentChildViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)dismissChildViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.childViewControllers containsObject:viewController]) {
        return;
    }
    
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

#pragma mark - Private Methods

- (void)p_showMenuViewControllerFromSide:(MenuSide)side withTransitionStyle:(id<FJBMenuAnimationProtocol>)animation
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self p_menuWillOpenFromSide:side withAnimation:animation];
    
    __weak __typeof(self) weakSelf = self;
    [self.menuAnimation animateCenterView:self.centerViewController.view
                                 menuView:self.selectedViewController.view
                                 fromSide:side
                           extraAnimation:^{
             
                           } completion:^(BOOL finished) {
                               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                               
                               __strong __typeof(weakSelf) strongSelf = weakSelf;
                               if (strongSelf) {
                                   [strongSelf p_menuOpenedFromSide:side];
                               }
                               
                           }
     ];
}

- (void)p_showMenuViewControllerFromSide:(MenuSide)side
                         transitionStyle:(id<FJBMenuAnimationProtocol>)animation
                        recognitionState:(UIGestureRecognizerState)state
                        translationPoint:(CGPoint)point

{
    if (state == UIGestureRecognizerStateBegan) {
        [self p_menuWillOpenFromSide:side withAnimation:animation];
        self.sideOpening = side;
        
    } else if (state == UIGestureRecognizerStateChanged) {
        if (self.sideOpening != side) {
            [self p_menuWillCloseFromSide:self.sideOpening];
            [self p_menuClosedFromSide:self.sideOpening];
            [self p_menuWillOpenFromSide:side withAnimation:animation];
            self.sideOpening = side;
        }
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.menuAnimation animateCenterView:self.centerViewController.view
                                 menuView:self.selectedViewController.view
                                 fromSide:side
                     withTranslationPoint:point
               withGestureRecognizerState:state
                           extraAnimation:^{
                               
                           } completion:^(BOOL opened) {
                               
                               if (state == UIGestureRecognizerStateEnded && opened) {
                                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                                   if (strongSelf) {
                                       [strongSelf p_menuOpenedFromSide:side];
                                   }
                                   
                               } else if (state == UIGestureRecognizerStateEnded && !opened){
                                   // -- not opened?
                                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                                   if (strongSelf) {
                                       [strongSelf p_menuClosedFromSide:side];
                                   }

                               }
                               
                           }
     ];

}

- (void)p_hideMenuViewControllerFromSide:(MenuSide)side
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self p_menuWillCloseFromSide:side];
    
    __weak __typeof(self) weakSelf = self;
    [self.menuAnimation reverseAnimateCenterView:self.centerViewController.view
                                        menuView:self.selectedViewController.view
                                        fromSide:side
                                  extraAnimation:^{}
                                      completion:^(BOOL finished) {
                                          [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                          __strong __typeof(weakSelf) strongSelf = weakSelf;
                                          if (strongSelf) {
                                              [strongSelf p_menuClosedFromSide:side];
                                          }

                                      }
     ];
}

- (void)p_hideMenuViewControllerFromSide:(MenuSide)side
                         transitionStyle:(id<FJBMenuAnimationProtocol>)animation
                        recognitionState:(UIGestureRecognizerState)state
                        translationPoint:(CGPoint)point
{
    if (state == UIGestureRecognizerStateBegan) {
        [self p_menuWillCloseFromSide:side];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.menuAnimation reverseAnimateCenterView:self.centerViewController.view
                                        menuView:self.selectedViewController.view
                                        fromSide:side
                            withTranslationPoint:point
                      withGestureRecognizerState:state
                                  extraAnimation:^{}
                                      completion:^(BOOL finished) {
                                          if (state == UIGestureRecognizerStateEnded) {
                                              __strong __typeof(weakSelf) strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  [strongSelf p_menuClosedFromSide:side];
                                              }
                                          }
                                      }
     ];
}



- (id<FJBMenuAnimationProtocol>) p_animation
{
    id<FJBMenuAnimationProtocol> animation = nil;
    if ([self.defaultConfiguration respondsToSelector:@selector(menuViewControllerDefaultAnimation:)]) {
        animation = [self.defaultConfiguration menuViewControllerDefaultAnimation:self];
    }
    NSAssert(animation !=nil, @"No animaiton provided");
    return animation;
}

#pragma mark - Status Bar
- (void) p_showStatusBar
{
    if (self.animationNeedHideStatusBar) {
        self.shouldHideStatusBar = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void) p_hideStatusBar
{
    if (self.animationNeedHideStatusBar) {
        self.shouldHideStatusBar = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void) p_setupGestureRecognizer
{
    [self.centerViewController.view addGestureRecognizer:self.defaultGestureRecognizer];
}

- (void) p_removeGestureRecognizer
{
    NSArray *gestureRecognizers = self.centerViewController.view.gestureRecognizers;
    for (UIGestureRecognizer *recognizer in gestureRecognizers) {
        [self.centerViewController.view removeGestureRecognizer:recognizer];
    }
}

#pragma mark - MenuViewController Animation End
- (void)p_menuWillOpenFromSide:(MenuSide)side withAnimation:(id<FJBMenuAnimationProtocol>)animation
{
    switch (side) {
        case MenuLeftSide:
            self.selectedViewController = self.leftViewController;
            break;
        case MenuRightSide:
            self.selectedViewController = self.rightViewController;
            break;
        default:
            break;
    }
    
    // -- Add ViewController
    self.menuAnimation = animation;
    [self addChildViewController:self.selectedViewController];
    [self.view addSubview:self.selectedViewController.view];
    [self.view bringSubviewToFront:self.centerViewController.view];
    [self.selectedViewController beginAppearanceTransition:YES animated:YES];
    
    if([self.delegate respondsToSelector:@selector(menuViewController:willShowViewController:fromMenuSide:)]){
        [self.delegate menuViewController:self willShowViewController:self.selectedViewController fromMenuSide:side];
    }
}

- (void)p_menuWillCloseFromSide:(MenuSide)side
{
    if([self.delegate respondsToSelector:@selector(menuViewController:willHideViewController:fromMenuSide:)]){
        [self.delegate menuViewController:self willHideViewController:self.selectedViewController fromMenuSide:side];
    }
    
    switch (side) {
        case MenuLeftSide:
            self.selectedViewController = self.leftViewController;
            break;
        case MenuRightSide:
            self.selectedViewController = self.rightViewController;
            break;
        default:
            break;
    }
    
    [self.selectedViewController willMoveToParentViewController:nil];
}

- (void)p_menuOpenedFromSide:(MenuSide)side
{
    [self p_hideStatusBar];

    [self didMoveToParentViewController:self.selectedViewController];
    switch (side) {
        case MenuLeftSide:
            self.leftMenuOpened = YES;
            self.sideOpened = MenuLeftSide;
            break;
        case MenuRightSide:
            self.rigthMenuOpened = YES;
            self.sideOpened = MenuRightSide;
            break;
        default:
            self.sideOpened = MenuSideNone;
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(menuViewController:didShowViewController:fromMenuSide:)]){
        [self.delegate menuViewController:self didShowViewController:self.selectedViewController fromMenuSide:side];
    }
}

- (void)p_menuClosedFromSide:(MenuSide)side
{
    switch (side) {
        case MenuLeftSide:
            self.leftMenuOpened = NO;
            break;
        case MenuRightSide:
            self.rigthMenuOpened = NO;
            break;
        default:
            break;
    }
    self.sideOpened = MenuSideNone;
    [self p_showStatusBar];
    
    [self.selectedViewController.view removeFromSuperview];
    [self.selectedViewController removeFromParentViewController];
    
    if([self.delegate respondsToSelector:@selector(menuViewController:didHideViewController:fromMenuSide:)]){
        [self.delegate menuViewController:self didHideViewController:self.selectedViewController fromMenuSide:side];
    }
}

#pragma mark - Public Methods

- (void)showLeftMenuViewController
{
    [self showLeftMenuViewControllerWithMenuAnimation:self.menuAnimation];
}

- (void)showLeftMenuViewControllerWithMenuAnimation:(id<FJBMenuAnimationProtocol>)animation
{
    NSAssert(self.leftViewController != nil, @"leftViewController was not set");
    [self p_showMenuViewControllerFromSide:MenuLeftSide withTransitionStyle:animation];
}

- (void)hideLeftMenuViewController
{
    [self p_hideMenuViewControllerFromSide:MenuLeftSide];
}

- (void)showRightMenuViewController
{
    [self showRightMenuViewControllerWithMenuAnimation:self.menuAnimation];
}

- (void)showRightMenuViewControllerWithMenuAnimation:(id<FJBMenuAnimationProtocol>)animation
{
    NSAssert(self.rightViewController != nil, @"rightViewController was not set");
    [self p_showMenuViewControllerFromSide:MenuRightSide withTransitionStyle:animation];
}

- (void)hideRightMenuViewController
{
    [self p_hideMenuViewControllerFromSide:MenuRightSide];
}

- (void)enableGestureRecognizer:(BOOL)enabled
{
    if (enabled) {
        [self p_setupGestureRecognizer];
    } else {
        [self p_removeGestureRecognizer];
    }
}

#pragma mark - GestureRecognizer Handlers

-(void)panGestureCallback:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    MenuSide side;
    BOOL open = YES;
    
    if (point.x >= 0) {
        switch (self.sideOpened) {
            case MenuSideNone:
                side = MenuLeftSide;
                open = YES;
                break;
            case MenuLeftSide:
                if (self.isLeftMenuOpened) {
                    return;
                } else {
                    side = MenuLeftSide;
                    open = YES;
                }
                break;
            case MenuRightSide:
                side = MenuRightSide;
                open = NO;
                break;
            default:
                break;
        }
    } else {
        switch (self.sideOpened) {
            case MenuSideNone:
                side = MenuRightSide;
                open = YES;
                break;
            case MenuLeftSide:
                side = MenuLeftSide;
                open = NO;
                break;
            case MenuRightSide:
                if (self.isRightMenuOpened) {
                    return;
                } else {
                    side = MenuRightSide;
                    open = YES;
                }
                break;
            default:
                break;
        }
    }
  
    if (open && ([self.sidesAvailable containsObject:@(side)] || recognizer.state == UIGestureRecognizerStateEnded)) {
        [self p_showMenuViewControllerFromSide:side
                               transitionStyle:self.menuAnimation
                              recognitionState:recognizer.state
                              translationPoint:point];
        
    } else if([self.sidesAvailable containsObject:@(side)] || recognizer.state == UIGestureRecognizerStateEnded){
        [self p_hideMenuViewControllerFromSide:side
                               transitionStyle:self.menuAnimation
                              recognitionState:recognizer.state
                              translationPoint:point];
    }
  
     
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // -- Default behaviour
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        
        // Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return YES;
        }
        
    }
    
    return NO;
}


@end
