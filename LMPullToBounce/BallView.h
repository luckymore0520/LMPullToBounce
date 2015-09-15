//
//  BallView.h
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import <UIKit/UIKit.h>
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef void (^AnimationCompletion)();
@interface BallView : UIView
- (instancetype) initWithFrame:(CGRect) frame
                    circleSize:(CGFloat)circleSize
                    timingFunc:(CAMediaTimingFunction *)timeFunction
                moveUpDuration:(CFTimeInterval)moveUpDuration
                    moveUpDist:(CGFloat)moveUpDist
                         color:(UIColor *)color;
- (void) startAnimation;
- (void) endAnimationWithCompletion:(AnimationCompletion)completion;
@end

