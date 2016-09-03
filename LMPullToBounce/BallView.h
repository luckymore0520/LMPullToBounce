//
//  BallView.h
//  
//
//  Created by luck-mac on 15/8/18.
//
//

#import <UIKit/UIKit.h>
#import "CircleLayer.h"

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

