//
//  FJBMenuViewController.h
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

#import <UIKit/UIKit.h>
#import "FJBMenuViewControllerDelegate.h"
#import "UIViewController+FJBMenuViewController.h"
#import "FJBMenuViewConfigurationProtocol.h"
#import "FJBMenuAnimationProtocol.h"


@interface FJBMenuViewController : UIViewController
@property (nonatomic, readonly, getter = isLeftMenuOpened) BOOL leftMenuOpened;
@property (nonatomic, readonly, getter = isRightMenuOpened) BOOL rigthMenuOpened;
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, strong) id<FJBMenuViewConfigurationProtocol> defaultConfiguration;

@property (nonatomic, weak) id<FJBMenuViewControllerDelegate> delegate;

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController;

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                          leftViewController:(UIViewController *)leftViewController;

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                         rightViewController:(UIViewController *)rightViewController;

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                          leftViewController:(UIViewController *)leftViewController
                         rightViewController:(UIViewController *)rightViewController;

- (void)showLeftMenuViewController;
- (void)showLeftMenuViewControllerWithMenuAnimation:(id<FJBMenuAnimationProtocol>)animation;
- (void)hideLeftMenuViewController;

- (void)showRightMenuViewController;
- (void)showRightMenuViewControllerWithMenuAnimation:(id<FJBMenuAnimationProtocol>)animation;
- (void)hideRightMenuViewController;

- (void)setCenterViewController:(UIViewController *)centerViewController
                   withDuration:(CGFloat)duration
                     animations:(void(^)())animationBlock
                     completion:(void(^)())completionBlock;

- (void)setCenterViewController:(UIViewController *)centerViewController animated:(BOOL)animated;


@end
