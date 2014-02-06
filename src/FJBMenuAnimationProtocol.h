//
//  FJBMenuAnimation.h
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

typedef enum {
    MenuSideNone,
    MenuLeftSide,
    MenuRightSide
} MenuSide;

@protocol FJBMenuAnimationProtocol <NSObject>

@property (nonatomic, assign) BOOL shouldHideStatusBar;

@required

- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL finished))completion;

- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
     withTranslationPoint:(CGPoint)point
withGestureRecognizerState:(UIGestureRecognizerState)state
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL opened))completion;


- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL finished))completion;

- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
            withTranslationPoint:(CGPoint)point
      withGestureRecognizerState:(UIGestureRecognizerState)state
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL opened))completion;


@optional
- (void)resetMenuPosition:(UIView *)menuView;
- (void)resetCenterPosition:(UIView *)centerView;
@end
