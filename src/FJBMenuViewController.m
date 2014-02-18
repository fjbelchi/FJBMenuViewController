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
#import "FJBMenuFacebookAnimation.h"
#import "FJBMenuViewBaseConfiguration.h"

@interface FJBMenuViewController () <UIGestureRecognizerDelegate>
// -- ViewControllers
@property (nonatomic, readwrite) BOOL leftMenuOpened;
@property (nonatomic, readwrite) BOOL rigthMenuOpened;
@property (nonatomic, strong) UIViewController *selectedViewController;

// -- Side states
@property (nonatomic, assign) MenuSide sideOpened;
@property (nonatomic, assign) MenuSide sideOpening;
@property (nonatomic, strong) NSMutableSet *sidesAvailable;

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
    
    [self p_setupGestureRecognizers];
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
        [self.menuAnimation swapCenterView:_centerViewController.view withView:centerViewController.view];
        [_centerViewController willMoveToParentViewController:nil];
        [_centerViewController.view removeFromSuperview];
        [_centerViewController removeFromParentViewController];
    }
    
    _centerViewController = centerViewController;
    
    [self addChildViewController:_centerViewController];
    [self.view addSubview:_centerViewController.view];
    [self didMoveToParentViewController:_centerViewController];
    [self p_setupGestureRecognizers];
/*
 // -- Testing with Animations
    [UIView animateKeyframesWithDuration:3 delay:0
                                 options:UIViewAnimationCurveEaseInOut
                              animations:^{
                                  CGRect frame =  _centerViewController.view.frame;
                                  frame.origin.x += 50;
                                  _centerViewController.view.frame = frame;
                              } completion:^(BOOL finished) {
                                  
                                  if (_centerViewController) {
                                      [self.menuAnimation swapCenterView:_centerViewController.view withView:centerViewController.view];
                                      [_centerViewController willMoveToParentViewController:nil];
                                      [_centerViewController.view removeFromSuperview];
                                      [_centerViewController removeFromParentViewController];
                                  }
                                  _centerViewController = centerViewController;
                                  
                                  [self addChildViewController:_centerViewController];
                                  [self.view addSubview:_centerViewController.view];
                                  [self didMoveToParentViewController:_centerViewController];
                                  [self p_setupGestureRecognizers];
                              }];
    */

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

-(void) p_setupGestureRecognizers
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [pan setDelegate:self];
    [self.centerViewController.view addGestureRecognizer:pan];
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
        [self.delegate menuViewController:self willShowViewController:self.selectedViewController fromMenuSide:side];
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
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
