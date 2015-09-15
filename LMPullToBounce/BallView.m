//
//  BallView.m
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import "BallView.h"
#import "NSTimer+PullToBounce.h"
#import "UIView+PullToBounce.h"


CAMediaTimingFunction *timeFunc;
CGFloat upDuration;


@interface SpinerLayer :CAShapeLayer
- (void)animation;
- (void)stopAnimation;
- (instancetype)initWithSuperLayoutFrame:(CGRect)superLayerFrame
                                ballSize:(CGFloat)ballSize
                                   color:(UIColor *)color;
@end

@interface CircleLayer :CAShapeLayer
@property (nonatomic, assign) CGFloat moveUpDist;
@property (nonatomic, strong) SpinerLayer *spiner;
@property (nonatomic, strong) AnimationCompletion didEndAnimation;
- (instancetype)initWithSize:(CGFloat)size
                  moveUpDist:(CGFloat)moveUpDist
              superViewFrame:(CGRect)superViewFrame
                       color:(UIColor *)color;
- (void)startAnimation;
- (void)endAnimation:(AnimationCompletion)completion;
@end

@interface BallView()
@property (nonatomic, strong) CircleLayer *circleLayer;
@end

@implementation BallView

- (instancetype) initWithFrame:(CGRect) frame
                    circleSize:(CGFloat)circleSize
                    timingFunc:(CAMediaTimingFunction *)timeFunction
                moveUpDuration:(CFTimeInterval)moveUpDuration
                    moveUpDist:(CGFloat)moveUpDist
                         color:(UIColor *)color{
    self = [self initWithFrame:frame];
    if (self) {
        timeFunc = timeFunction;
        upDuration = moveUpDuration;
        
        UIView *circleMoveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, moveUpDist, moveUpDist)];
        circleMoveView.center = CGPointMake(self.width / 2, self.height + circleSize / 2);
        [self addSubview:circleMoveView];
        self.circleLayer = [[CircleLayer alloc] initWithSize:circleSize moveUpDist:moveUpDist superViewFrame:circleMoveView.frame color:color];
        [circleMoveView.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void) startAnimation {
    [self.circleLayer startAnimation];
}

- (void) endAnimationWithCompletion:(AnimationCompletion)completion {
    [self.circleLayer endAnimation:completion];
}

@end





@implementation CircleLayer


- (instancetype)initWithSize:(CGFloat)size
                  moveUpDist:(CGFloat)moveUpDist
              superViewFrame:(CGRect)superViewFrame
                       color:(UIColor *)color {
    self = [self init];
    if (self) {
        self.moveUpDist = moveUpDist;
        self.frame = CGRectMake(0, 0, superViewFrame.size.width, superViewFrame.size.height);
        self.spiner = [[SpinerLayer alloc] initWithSuperLayoutFrame:self.frame ballSize:size color:color];
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
    [NSTimer schedule:upDuration handler:^(CFRunLoopTimerRef timer) {
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
    move.duration = upDuration;
    move.timingFunction = timeFunc;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self addAnimation:move forKey:move.keyPath];
}

- (void)moveDown:(CGFloat)distance {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.toValue = [NSValue valueWithCGPoint:self.position];
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - distance)];
    move.duration = upDuration;
    move.timingFunction = timeFunc;
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




@implementation SpinerLayer

- (instancetype)initWithSuperLayoutFrame:(CGRect)superLayerFrame
                                ballSize:(CGFloat)ballSize
                                   color:(UIColor *)color {
    self = [self init];
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