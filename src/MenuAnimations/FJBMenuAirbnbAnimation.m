//
//  FJBMenuAirbnbAnimation.m
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

#import "FJBMenuAirbnbAnimation.h"

@implementation FJBMenuAirbnbAnimation
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
    
    CATransform3D contentTransform = CATransform3DIdentity;
    contentTransform.m34 = -1.0f / 800.0f;
    centerView.layer.zPosition = 100;
    
    CATransform3D menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.7, 1.7, 1.7);
    menuView.layer.transform = menuTransform;
    
    menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.0, 1.0, 1.0);
    
    if(menuSide == MenuLeftSide){
        contentTransform = CATransform3DTranslate(contentTransform, self.visibleWidthCenterView - (centerView.frame.size.width / 2 * 0.4), 0.0, 0.0);
        contentTransform = CATransform3DScale(contentTransform, 0.6, 0.6, 0.6);
        contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(-45), 0.0, 1.0, 0.0);
    } else {
        contentTransform = CATransform3DTranslate(contentTransform, 0 - self.visibleWidthCenterView + (centerView.frame.size.width / 2 * 0.4), 0.0, 0.0);
        contentTransform = CATransform3DScale(contentTransform, 0.6, 0.6, 0.6);
        contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(45), 0.0, 1.0, 0.0);
    }
    
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.layer.transform = contentTransform;
                         menuView.layer.transform = menuTransform;
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
               completion:(void (^)(BOOL finished))completion
{
    CATransform3D contentTransform = CATransform3DIdentity;
    CATransform3D menuTransform = CATransform3DIdentity;

    if (state == UIGestureRecognizerStateBegan) {
        [super animateCenterView:centerView
                        menuView:menuView
                        fromSide:menuSide
                  extraAnimation:animationBlock
                      completion:completion];
    } else if(state == UIGestureRecognizerStateChanged) {
        
        contentTransform.m34 = -1.0f / 800.0f;
        centerView.layer.zPosition = 100;
        
        menuTransform = CATransform3DScale(menuTransform, 1.7, 1.7, 1.7);
        menuView.layer.transform = menuTransform;
        
        menuTransform = CATransform3DIdentity;
        CGFloat scale = 1.0f;//(menuView.frame.size.width-point.x)/menuView.frame.size.width;
        menuTransform = CATransform3DScale(menuTransform, scale, scale, scale);
        
        if(menuSide == MenuLeftSide){
            contentTransform = CATransform3DTranslate(contentTransform, MIN(point.x,self.visibleWidthCenterView), 0.0, 0.0);
            //Scale
            CGFloat scale = ((centerView.frame.size.width-point.x)/centerView.frame.size.width);
            scale = MAX(scale, 0.6f);
            contentTransform = CATransform3DScale(contentTransform, scale, scale, scale);
            // -- Rotate
            CGFloat rotation = (point.x * (-45))/self.visibleWidthCenterView;
            contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(rotation), 0.0, 1.0, 0.0);
        } else {
            contentTransform = CATransform3DTranslate(contentTransform, 0 - point.x + (centerView.frame.size.width / 2 * 0.4), 0.0, 0.0);
            contentTransform = CATransform3DScale(contentTransform, 0.6, 0.6, 0.6);
            contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(45), 0.0, 1.0, 0.0);
        }
        
    } else if(state == UIGestureRecognizerStateEnded) {
        
    }
    
    
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.layer.transform = contentTransform;
                         menuView.layer.transform = menuTransform;
                         animationBlock();
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
    
    CATransform3D contentTransform = CATransform3DIdentity;
    contentTransform.m34 = -1.0f / 800.0f;
    centerView.layer.zPosition = 100;
    contentTransform = CATransform3DTranslate(contentTransform, 0.0, 0.0, 0.0);
    contentTransform = CATransform3DScale(contentTransform, 1.0, 1.0, 1.0);
    contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(0), 0.0, 1.0, 0.0);
    
    __block CATransform3D menuTransform = CATransform3DIdentity;
    menuTransform = CATransform3DScale(menuTransform, 1.7, 1.7, 1.7);
    
    [UIView animateWithDuration:self.reverseAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         centerView.layer.transform = contentTransform;
                         menuView.layer.transform = menuTransform;
                         animationBlock();
                     }
                     completion:^(BOOL finished) {
                         menuTransform = CATransform3DIdentity;
                         menuTransform = CATransform3DScale(menuTransform, 1.0, 1.0, 1.0);
                         menuView.layer.transform = menuTransform;
                         completion(finished);
                     }];
}

- (void)swapCenterView:(UIView *)centerView withView:(UIView *)view;
{
    view.layer.transform = centerView.layer.transform;    
}

@end
