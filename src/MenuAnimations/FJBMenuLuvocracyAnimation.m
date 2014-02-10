//
//  FJBMenuLuvocracyAnimation.m
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

#import "FJBMenuLuvocracyAnimation.h"

@implementation FJBMenuLuvocracyAnimation
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
    
    CATransform3D centerTransform = CATransform3DIdentity;
    centerTransform.m34 = -1.0f / 800.0f;
    centerView.layer.zPosition = 100;
    
    CATransform3D menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.7, 1.7, 1.7);
    menuView.layer.transform = menuTransform;
    
    menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.0, 1.0, 1.0);
    
    switch (menuSide) {
        case MenuLeftSide:
            centerTransform = CATransform3DTranslate(centerTransform,
                                                      self.visibleWidthCenterView - (centerView.frame.size.width / 2 * 0.4),
                                                      0.0,
                                                      0.0);
            centerTransform = CATransform3DScale(centerTransform, 0.6, 0.6, 0.6);
            break;
        case MenuRightSide:
            centerTransform = CATransform3DTranslate(centerTransform,
                                                     0 - self.visibleWidthCenterView + (centerView.frame.size.width / 2 * 0.4),
                                                     0.0,
                                                     0.0);
            centerTransform = CATransform3DScale(centerTransform, 0.6, 0.6, 0.6);
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.layer.transform = centerTransform;
                         menuView.layer.transform = menuTransform;
                     }
                     completion:^(BOOL finished) {
                         completion(finished);
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
    
    __block CATransform3D centerTransform = CATransform3DIdentity;
    centerTransform.m34 = -1.0f / 800.0f;
    centerView.layer.zPosition = 100;
    centerTransform = CATransform3DTranslate(centerTransform, 0.0, 0.0, 0.0);
    centerTransform = CATransform3DScale(centerTransform, 1.0, 1.0, 1.0);
    
    __block CATransform3D menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.7, 1.7, 1.7);
    
    [UIView animateWithDuration:self.reverseAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuView.layer.transform = menuTransform;
                         centerView.layer.transform = centerTransform;
                     }
                     completion:^(BOOL finished) {
                         completion(finished);
                         menuTransform = CATransform3DIdentity;
                         menuTransform = CATransform3DScale(menuTransform, 1.0, 1.0, 1.0);
                         menuView.layer.transform = menuTransform;
                     }];
}


- (void)swapCenterView:(UIView *)centerView withView:(UIView *)view;
{
    view.layer.transform = centerView.layer.transform;
}

@end
