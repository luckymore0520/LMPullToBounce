//
//  SpinnerLayer.m
//  LMPullToBounceDemo
//
//  Created by WangKun on 16/9/3.
//  Copyright © 2016年 com.nju.luckymore. All rights reserved.
//

#import "SpinnerLayer.h"
@implementation SpinnerLayer

- (instancetype)initWithSuperLayoutFrame:(CGRect)superLayerFrame
                                ballSize:(CGFloat)ballSize
                                   color:(UIColor *)color {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, superLayerFrame.size.height, superLayerFrame.size.height);
        CGPoint center = CGPointMake(superLayerFrame.size.width / 2, superLayerFrame.origin.y + superLayerFrame.size.height / 2);
        const CGFloat startAngle = - M_PI_2;
        const CGFloat endAngle = (M_PI * 2 - M_PI_2) + M_PI / 8;
        CGFloat radius = ballSize / 2 * 1.2;
        self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
        self.fillColor = nil;
        self.strokeColor = color.CGColor;
        self.lineWidth = 2.0;
        self.lineCap = kCALineCapRound;
        self.strokeStart = 0;
        self.strokeEnd = 0;
        self.hidden = YES;
    }
    return self;
}

#pragma mark - Public
- (void)animation {
    self.hidden = NO;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 1;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    [self addAnimation:rotate forKey:rotate.keyPath];
    [self strokeEndAnimation];
}

- (void)stopAnimation {
    [self setHidden:YES];
    [self removeAllAnimations];
}

#pragma mark - Private
- (void)strokeEndAnimation {
    CABasicAnimation *endPoint = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endPoint.fromValue = @(0);
    endPoint.toValue = @(1.0);
    endPoint.duration = 0.8;
    endPoint.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    endPoint.repeatCount = 1;
    endPoint.fillMode = kCAFillModeForwards;
    endPoint.removedOnCompletion = NO;
    endPoint.delegate = self;
    [self addAnimation:endPoint forKey:endPoint.keyPath];
}


- (void)strokeStartAnimation {
    CABasicAnimation *startPoint = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startPoint.fromValue = @(0);
    startPoint.toValue = @(1.0);
    startPoint.duration = 0.8;
    startPoint.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    startPoint.repeatCount = 1;
    startPoint.delegate = self;
    [self addAnimation:startPoint forKey:startPoint.keyPath];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!self.hidden) {
        CABasicAnimation *animation = (CABasicAnimation *)anim;
        if ([animation.keyPath isEqualToString:@"strokeStart"]) {
            [self strokeEndAnimation];
        } else if ([animation.keyPath isEqualToString:@"strokeEnd"]) {
            [self strokeStartAnimation];
        }
    }
}
@end
