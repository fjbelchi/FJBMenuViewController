//
//  FJBMenuFacebookAnimation.m
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

#import "FJBMenuFacebookAnimation.h"

@implementation FJBMenuFacebookAnimation

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.visibleWidthCenterView = 260;
        self.animationDuration = 0.3;
        self.reverseAnimationDuration = self.animationDuration;
        self.shouldHideStatusBar = YES;
    }
    return self;
}


- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL finished))completion
{
    [super animateCenterView:centerView
                    menuView:menuView
                    fromSide:menuSide
              extraAnimation:animationBlock
                  completion:completion];
    
    CGRect centerFrame = centerView.frame;
    
    switch (menuSide) {
        case MenuLeftSide:
            centerFrame.origin.x += self.visibleWidthCenterView;
            break;
        case MenuRightSide:
            centerFrame.origin.x -= self.visibleWidthCenterView;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.frame = centerFrame;
                         animationBlock();
                     }
                     completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
     withTranslationPoint:(CGPoint)point
    withGestureRecognizerState:(UIGestureRecognizerState)state
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL opened))completion
{
    CGRect centerFrame = centerView.frame;
    BOOL opened = NO;
    if (state == UIGestureRecognizerStateBegan) {
        
        [super animateCenterView:centerView
                        menuView:menuView
                        fromSide:menuSide
                  extraAnimation:animationBlock
                      completion:completion];
         
        
    } else if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        centerFrame.origin.x = point.x;
    } else if (state == UIGestureRecognizerStateEnded) {
        if (centerFrame.origin.x > (self.visibleWidthCenterView/2) || centerFrame.origin.x < -(self.visibleWidthCenterView/2)) {
            switch (menuSide) {
                case MenuLeftSide:
                    centerFrame.origin.x = self.visibleWidthCenterView;
                    break;
                case MenuRightSide:
                    centerFrame.origin.x = -self.visibleWidthCenterView;
                    break;
                default:
                    break;
            }
            opened = YES;
        } else {
            centerFrame.origin.x = 0;
        }
    }


    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.frame = centerFrame;
                         animationBlock();
                     }
                     completion:^(BOOL finished) {
                         completion(opened);
                     }];

}


- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL finished))completion
{
    [super reverseAnimateCenterView:centerView
                           menuView:menuView
                           fromSide:menuSide
                     extraAnimation:animationBlock
                         completion:completion];
    
    CGRect centerFrame = centerView.frame;
    centerFrame.origin.x = 0;

    [UIView animateWithDuration:self.reverseAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.frame = centerFrame;
                         animationBlock();
                     }
                     completion:^(BOOL finished) {
                         completion(finished);
                     }];
}


- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
            withTranslationPoint:(CGPoint)point
      withGestureRecognizerState:(UIGestureRecognizerState)state
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL finished))completion
{
    CGRect centerFrame = centerView.frame;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        switch (menuSide) {
            case MenuLeftSide:
                centerFrame.origin.x = MAX(self.visibleWidthCenterView + point.x,0);
                break;
            case MenuRightSide:
                centerFrame.origin.x = -(centerFrame.size.width-(centerFrame.size.width-self.visibleWidthCenterView))+point.x;
            default:
                break;
        }
    } else if (state == UIGestureRecognizerStateEnded) {
        centerFrame.origin.x = 0;
    }
    
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.frame = centerFrame;
                         animationBlock();
                     }
                     completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

- (void)swapCenterView:(UIView *)centerView withView:(UIView *)view;
{
    view.frame = centerView.frame;
}

@end
