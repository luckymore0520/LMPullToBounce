//
//  BallView.m
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import "BallView.h"
#import "UIView+PullToBounce.h"

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
        UIView *circleMoveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, moveUpDist, moveUpDist)];
        circleMoveView.center = CGPointMake(self.width / 2, self.height + circleSize / 2);
        [self addSubview:circleMoveView];
        self.circleLayer = [[CircleLayer alloc] initWithSize:circleSize moveUpDist:moveUpDist superViewFrame:circleMoveView.frame color:color timeFunc:timeFunction upDuration:moveUpDuration];
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





