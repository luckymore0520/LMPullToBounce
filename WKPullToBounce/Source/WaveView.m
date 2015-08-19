//
//  WaveView.m
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import "WaveView.h"
#import "UIView+PullToBounce.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface WaveView()
@property (nonatomic, assign) CFTimeInterval bounceDuration;
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@end
@implementation WaveView

- (instancetype) initWithFrame:(CGRect)frame
                bounceDuration:(CFTimeInterval) duration
                         color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        self.bounceDuration = duration;
        self.waveLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
        self.waveLayer.lineWidth = 0;
        self.waveLayer.path = [self wavePathWithAmountX:0 amountY:0];
        self.waveLayer.strokeColor = color.CGColor;
        self.waveLayer.fillColor = color.CGColor;
        [self.layer addSublayer:self.waveLayer];
    }
    return self;
}

#pragma mark - Public
- (void)wave:(CGFloat)y {
    self.waveLayer.path = [self wavePathWithAmountX:0 amountY:y];
}

- (void)didReleaseWithAmountX:(CGFloat)amountX amountY:(CGFloat)amountY {
    [self boundAnimationWithPositionX:amountX positionY:amountY];
    if (self.didEndPull) {
        self.didEndPull();
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.waveLayer.path = [self wavePathWithAmountX:0 amountY:0];
}

#pragma mark - Private
- (void)boundAnimationWithPositionX:(CGFloat) positionX positionY:(CGFloat)positionY {
    self.waveLayer.path = [self wavePathWithAmountX:0 amountY:0];
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    bounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    NSArray *values = @[
                 (__bridge id)[self wavePathWithAmountX:positionX amountY:positionY],
                (__bridge id)[self wavePathWithAmountX:-(positionX * 0.7) amountY:-(positionY * 0.7)],
                (__bridge id)[self wavePathWithAmountX:(positionX * 0.4) amountY:(positionY * 0.4)],
                (__bridge id)[self wavePathWithAmountX:-(positionX * 0.3) amountY:-(positionY * 0.3)],
                (__bridge id)[self wavePathWithAmountX:(positionX * 0.15) amountY:(positionY * 0.15)],
                (__bridge id)[self wavePathWithAmountX:0 amountY:0]
                ];
    bounce.values = values;
    bounce.duration = self.bounceDuration;
    bounce.removedOnCompletion = YES;
    bounce.fillMode = kCAFillModeForwards;
    bounce.delegate = self;
    [self.waveLayer addAnimation:bounce forKey:@"return"];
}

- (CGPathRef)wavePathWithAmountX:(CGFloat)amountX amountY:(CGFloat)amountY {
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat centerY = 0;
    CGFloat bottomY = height;
    CGPoint topLeftPoint = CGPointMake(0, centerY);
    CGPoint topMidPoint = CGPointMake(width / 2 + amountX, centerY + amountY);
    CGPoint topRightPoint = CGPointMake(width, centerY);
    CGPoint bottomLeftPoint = CGPointMake(0, bottomY);
    CGPoint bottomRightPoint = CGPointMake(width, bottomY);
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:bottomLeftPoint];
    [bezierPath addLineToPoint:topLeftPoint];
    [bezierPath addQuadCurveToPoint:topRightPoint controlPoint:topMidPoint];
    [bezierPath addLineToPoint:bottomRightPoint];
    return bezierPath.CGPath;
}

@end
