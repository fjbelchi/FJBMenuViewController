//
//  FJBViewControllerAnimationProtocol.h
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


#import <Foundation/Foundation.h>

@protocol FJBViewControllerAnimationProtocol <NSObject>
@optional

#pragma mark - Change Center ViewController
- (void)menuViewController:(FJBMenuViewController *)menuViewController willChangeCenterViewController:(UIViewController *)centerViewController
         forViewController:(UIViewController *)viewController;

- (void)menuViewController:(FJBMenuViewController *)menuViewController animateForViewController:(UIViewController *)viewController withCompletionBlock:(void(^)(BOOL finished))completionBlock;

- (void)menuViewController:(FJBMenuViewController *)menuViewController didChangeCenterViewController:(UIViewController *)centerViewController
         forViewController:(UIViewController *)viewController;

#pragma mark - Add Child ViewController

- (void)menuViewController:(FJBMenuViewController *)menuViewController willAddChildViewController:(UIViewController *)childViewController
          inViewController:(UIViewController *)viewController;

- (void)menuViewController:(FJBMenuViewController *)menuViewController animateToAddChildViewController:(UIViewController *)viewController withCompletionBlock:(void(^)(BOOL finished))completionBlock;

- (void)menuViewController:(FJBMenuViewController *)menuViewController animateToAddChildViewControllerFromViewController:(UIViewController *)viewController withCompletionBlock:(void(^)(BOOL finished))completionBlock;

- (void)menuViewController:(FJBMenuViewController *)menuViewController didAddChildViewController:(UIViewController *)childViewController
          inViewController:(UIViewController *)viewController;

#pragma mark - Remove Child ViewController

- (void)menuViewController:(FJBMenuViewController *)menuViewController willRemoveChildViewController:(UIViewController *)childViewController
          inViewController:(UIViewController *)viewController;

- (void)menuViewController:(FJBMenuViewController *)menuViewController animateToRemoveChildViewController:(UIViewController *)viewController withCompletionBlock:(void(^)(BOOL finished))completionBlock;

- (void)menuViewController:(FJBMenuViewController *)menuViewController animateToRemoveChildViewControllerFromViewController:(UIViewController *)viewController withCompletionBlock:(void(^)(BOOL finished))completionBlock;

- (void)menuViewController:(FJBMenuViewController *)menuViewController didRemoveChildViewController:(UIViewController *)childViewController
          inViewController:(UIViewController *)viewController;

@end
