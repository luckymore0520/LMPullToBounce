//
//  CircleLayer.m
//  LMPullToBounceDemo
//
//  Created by WangKun on 16/9/3.
//  Copyright © 2016年 com.nju.luckymore. All rights reserved.
//

#import "CircleLayer.h"
#import "NSTimer+PullToBounce.h"

@interface CircleLayer()
@property (nonatomic, strong) CAMediaTimingFunction *timeFunc;
@property (nonatomic, assign) CGFloat upDuration;
@end
@implementation CircleLayer
- (instancetype)initWithSize:(CGFloat)size
                  moveUpDist:(CGFloat)moveUpDist
              superViewFrame:(CGRect)superViewFrame
                       color:(UIColor *)color
                    timeFunc:(CAMediaTimingFunction *)timeFunc
                  upDuration:(CGFloat)upDuration{
    self = [self init];
    if (self) {
        self.timeFunc = timeFunc;
        self.upDuration = upDuration;
        self.moveUpDist = moveUpDist;
        self.frame = CGRectMake(0, 0, superViewFrame.size.width, superViewFrame.size.height);
        self.spiner = [[SpinnerLayer alloc] initWithSuperLayoutFrame:self.frame ballSize:size color:color];
        [self addSublayer:self.spiner];
        CGPoint center = CGPointMake(superViewFrame.size.width / 2, superViewFrame.size.height / 2);
        CGFloat radius = size / 2;
        CGFloat startAngle = 0 - M_PI_2;
        CGFloat endAngle = M_PI * 2 - M_PI_2;
        self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
        self.fillColor = color.CGColor;
        self.strokeColor = self.fillColor;
        self.lineWidth = 0;
        self.strokeEnd = 1;
    }
    return self;
}

#pragma mark - Public
- (void)startAnimation {
    [self moveUp:self.moveUpDist];
    WS(weakSelf);
    [NSTimer schedule:self.upDuration handler:^(CFRunLoopTimerRef timer) {
        [weakSelf.spiner animation];
    }];
}

- (void)endAnimation:(AnimationCompletion)completion{
    [self.spiner stopAnimation];
    [self moveDown:self.moveUpDist];
    self.didEndAnimation = completion;
}

#pragma mark - Private
- (void)moveUp:(CGFloat)distance {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:self.position];
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - distance)];
    move.duration = self.upDuration;
    move.timingFunction = self.timeFunc;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self addAnimation:move forKey:move.keyPath];
}

- (void)moveDown:(CGFloat)distance {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.toValue = [NSValue valueWithCGPoint:self.position];
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - distance)];
    move.duration = self.upDuration;
    move.timingFunction = self.timeFunc;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    move.delegate = self;
    [self addAnimation:move forKey:move.keyPath];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.didEndAnimation) {
        self.didEndAnimation();
    }
}

@end

