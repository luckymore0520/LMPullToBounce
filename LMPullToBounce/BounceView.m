//
//  BounceView.m
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import "BounceView.h"
#import "NSTimer+PullToBounce.h"
#import "UIView+PullToBounce.h"

@interface BounceView()
@property (nonatomic, strong)BallView *ballView;
@property (nonatomic, strong)WaveView *waveView;
@end
@implementation BounceView

- (instancetype)initWithFrame:(CGRect)frame
               bounceDuration:(CFTimeInterval)duration
                     ballSize:(CGFloat)ballSize
         ballMovingTimingFunc:(CAMediaTimingFunction *)ballMovingTimingFunc         moveUpDuration:(CFTimeInterval)moveUpDuration
                   moveUpDist:(CGFloat)moveUpDist
                        color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        if (color == nil) {
            color = [UIColor whiteColor];
        }
        CGFloat ballViewHeight = 100.0;
        
        self.ballView = [[BallView alloc] initWithFrame:CGRectMake(0, -(ballViewHeight + 1), self.width, ballViewHeight)
                                             circleSize:ballSize
                                             timingFunc:ballMovingTimingFunc
                                         moveUpDuration:moveUpDuration
                                             moveUpDist:moveUpDist
                                            color:color];
        self.waveView = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, self.ballView.width, self.height)
                                         bounceDuration:duration
                                                  color:color];
        self.ballView.hidden = YES;
        [self addSubview:self.ballView];
        [self addSubview:self.waveView];
        WS(weakSelf);
        [self.waveView setDidEndPull:^(){
            [NSTimer schedule:0.2 handler:^(CFRunLoopTimerRef timer) {
                weakSelf.ballView.hidden = NO;
                [weakSelf.ballView startAnimation];
            }];
        }];
    }
    return self;
}

#pragma mark - Public
- (void)endingAnimation:(AnimationCompletion)completion {
    WS(weakSelf);
    [self.ballView endAnimationWithCompletion:^{
        weakSelf.ballView.hidden = YES;
        if (completion) {
            completion();
        }
    }];
}

- (void)wave:(CGFloat)y {
    [self.waveView wave:y];
}

- (void)didRelease:(CGFloat)y {
    [self.waveView didReleaseWithAmountX:0 amountY:y];
}

@end
