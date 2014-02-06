//
//  FJBMenuBaseAnimation.m
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

#import "FJBMenuBaseAnimation.h"

@interface FJBMenuBaseAnimation ()
@end

@implementation FJBMenuBaseAnimation

- (instancetype) initWithVisibleWidthCenter:(CGFloat) visibleWidthCenterView
                          animationDuration:(CGFloat) animationDuration
                   reverseAnimationDuration:(CGFloat) reverseAnimationDuration
                        shouldHideStatusBar:(BOOL)shouldHideStatusBar
{
    self = [super init];
    if (self) {
        _visibleWidthCenterView = visibleWidthCenterView;
        _animationDuration = animationDuration;
        _reverseAnimationDuration = reverseAnimationDuration;
        _shouldHideStatusBar = shouldHideStatusBar;
    }
    return self;
}

- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL finished))completion
{
    [self resetMenuPosition:menuView];
    [self resetCenterPosition:centerView];

}

- (void)animateCenterView:(UIView *)centerView
                 menuView:(UIView *)menuView
                 fromSide:(MenuSide)menuSide
                  toPoint:(CGPoint) point
           extraAnimation:(void (^)())animationBlock
               completion:(void (^)(BOOL finished))completion
{
    
}

- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL finished))completion
{    
 
}

- (void)reverseAnimateCenterView:(UIView *)centerView
                        menuView:(UIView *)menuView
                        fromSide:(MenuSide)menuSide
                         toPoint:(CGPoint)point
                  extraAnimation:(void (^)())animationBlock
                      completion:(void (^)(BOOL finished))completion
{
    
}

- (void)resetMenuPosition:(UIView *)menuView
{
    /*
    CATransform3D resetTransform = CATransform3DIdentity;
    resetTransform = CATransform3DRotate(resetTransform, DEG2RAD(0), 1, 1, 1);
    resetTransform = CATransform3DScale(resetTransform, 1.0, 1.0, 1.0);
    resetTransform = CATransform3DTranslate(resetTransform, 0.0, 0.0, 0.0);
    menuView.layer.transform = resetTransform;
    
    CGRect resetFrame = menuView.frame;
    resetFrame.origin.x = 0;
    resetFrame.origin.y = 0;
    menuView.frame = resetFrame;
     */
    
    [menuView.superview sendSubviewToBack:menuView];
    //menuView.layer.zPosition = 0;
}

- (void)resetCenterPosition:(UIView *)centerView
{
    /*
    CATransform3D resetTransform = CATransform3DIdentity;
    resetTransform = CATransform3DRotate(resetTransform, DEG2RAD(0), 1, 1, 1);
    resetTransform = CATransform3DScale(resetTransform, 1.0, 1.0, 1.0);
    resetTransform = CATransform3DTranslate(resetTransform, 0.0, 0.0, 0.0);
    centerView.layer.transform = resetTransform;
    
    CGRect resetFrame = centerView.frame;
    resetFrame.origin.x = 0;
    resetFrame.origin.y = 0;
    centerView.frame = resetFrame;*/
    
    [centerView.superview bringSubviewToFront:centerView];
    //centerView.layer.zPosition = 0;
}

@end
